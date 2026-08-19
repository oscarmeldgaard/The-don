#!/usr/bin/env node
// Deck verification against the files ON DISK. Run this as its own step after
// any numbers pass — not only as part of `flutter test`.
//
//   node tools/verify_deck.js
//
// Why it exists: during the commission pass a script wrote inside its own
// scaling loop and threw before its correction step, and a follow-up run then
// scaled the already-scaled deck a second time. Batch 3's commission net
// reached +102, well outside the ±50 limit — and `flutter test` had reported
// 140/140 shortly beforehand, because the suite had been run before the second
// write. **A deck can be structurally perfect and numerically ruined, and a
// stale green will hide it.**
//
// So this is deliberately independent of the Dart suite: zero dependencies,
// under a second to run, and it re-implements the DeckBalance rules from
// lib/deck_balance.dart rather than importing them, so the two act as a check
// on each other. Exits non-zero on any violation.

const fs = require('fs');
const path = require('path');

// Optional dir argument so the guard itself can be tested against a
// deliberately corrupted copy. Defaults to the shipping deck.
const ROOT = process.argv[2] || path.join(__dirname, '..', 'assets', 'cards');
const METERS = ['family', 'commission', 'cops', 'cash'];
const MAX_NET = 50;
const MIN_ORDINARY = 0.60;
const MAX_VICE_NET = 30;

// The 13-14 gap is now empty across all nine batches. Batch 1 carried eight
// cash deltas in it until its mechanical defects were corrected after batch 9;
// there is no exemption any more, and any delta landing here is a failure.
const KNOWN_GAP = new Set();

let failures = 0;
const fail = (m) => { console.log('  FAIL  ' + m); failures++; };

const batches = fs.readdirSync(ROOT)
  .filter((f) => /^batch_\d+\.json$/.test(f))
  .sort((a, b) => Number(a.match(/\d+/)[0]) - Number(b.match(/\d+/)[0]));

if (!batches.length) { console.error('no batch files found in ' + ROOT); process.exit(1); }

console.log(`verifying ${batches.length} batches on disk\n`);

const allIds = new Set();
const meterTravel = {};
for (const m of METERS) meterTravel[m] = { sides: 0, sum: 0 };

for (const file of batches) {
  const label = file.replace('.json', '');
  const deck = JSON.parse(fs.readFileSync(path.join(ROOT, file), 'utf8'));

  if (deck.length !== 100) fail(`${label}: ${deck.length} cards, expected 100`);

  const nets = {}, viceNets = {};
  for (const m of METERS) { nets[m] = 0; viceNets[m] = 0; }
  const band = { lo: 0, ord: 0, gap: 0, hi: 0, over: 0 };
  let total = 0, inert = 0, garnish = 0, vices = 0, gapCards = [];

  for (const c of deck) {
    if (allIds.has(c.id)) fail(`duplicate id ${c.id}`);
    allIds.add(c.id);
    if (c.vice) vices++;
    for (const side of [c.left, c.right]) {
      let moved = 0, largest = 0;
      for (const m of METERS) {
        const v = side.effects[m];
        if (typeof v !== 'number' || !Number.isInteger(v)) {
          fail(`${c.id}: ${m} is not an integer`); continue;
        }
        nets[m] += v;
        if (c.vice) viceNets[m] += v;
        if (v === 0) continue;
        moved++; total++;
        const a = Math.abs(v);
        if (a > largest) largest = a;
        meterTravel[m].sides++; meterTravel[m].sum += a;
        if (a <= 4) band.lo++;
        else if (a <= 12) band.ord++;
        else if (a <= 14) { band.gap++; gapCards.push(c.id); }
        else if (a <= 25) band.hi++;
        else { band.over++; fail(`${c.id}: ${m} = ${v}, past the 25 ceiling`); }
      }
      if (side.effects.blood < 0) fail(`${c.id}: negative blood`);
      if (moved === 0) inert++;
      if (moved > 0 && largest <= 4 && side.effects.blood === 0) garnish++;
    }
  }

  for (const m of METERS) {
    if (Math.abs(nets[m]) > MAX_NET) {
      fail(`${label}: ${m} net ${nets[m] > 0 ? '+' : ''}${nets[m]}, over ±${MAX_NET}`);
    }
    if (vices && Math.abs(viceNets[m]) > MAX_VICE_NET) {
      fail(`${label}: vices lean on ${m}, net ${viceNets[m]}, over ±${MAX_VICE_NET}`);
    }
  }
  const ordinary = band.ord / total;
  if (ordinary < MIN_ORDINARY) {
    fail(`${label}: only ${(ordinary * 100).toFixed(1)}% in the 5-12 band`);
  }
  if (inert) fail(`${label}: ${inert} inert choice-side(s)`);
  for (const id of new Set(gapCards)) {
    if (!KNOWN_GAP.has(id)) fail(`${label}: ${id} has a delta in the 13-14 gap`);
  }

  console.log(`  ${label}  ` +
    METERS.map((m) => m[0] + (nets[m] >= 0 ? '+' : '') + nets[m]).join(' ').padEnd(30) +
    `5-12 ${(ordinary * 100).toFixed(1)}%   1-4 ${(band.lo * 100 / total).toFixed(1)}%   ` +
    `15-25 ${(band.hi * 100 / total).toFixed(1)}%   garnish ${garnish}` +
    (band.gap ? `   gap ${band.gap} (known)` : ''));
}

console.log('\nmeter travel across the whole deck:');
for (const m of METERS) {
  const t = meterTravel[m];
  console.log(`  ${m.padEnd(11)} ${String(t.sides).padStart(5)} sides  ` +
    `${(t.sides * 100 / (batches.length * 200)).toFixed(1)}%   mean |d| ${(t.sum / t.sides).toFixed(2)}`);
}

console.log(failures
  ? `\n${failures} FAILURE(S) — do not ship this deck`
  : '\nDECK OK — every batch inside every balance limit');
process.exit(failures ? 1 : 0);
