# The batch prompt

The master brief for writing a batch of cards. One batch per run, nine in
total, 100 cards each.

**Substitute `{N}` with the batch number throughout.** Everything below the
rule is the prompt; the header block above it is instructions about the
prompt.

Read this file, then read [cast.md](cast.md),
[content-bible.md](content-bible.md) and [flag-registry.md](flag-registry.md)
before writing anything.

> **Invoke a batch by pointing at this file, never by pasting a copy of it.**
> Batch 3 was started from a pasted copy that predated every amendment below,
> and the damage was not cosmetic: it reinstated the struck 70/30 walk-on
> split, and it dropped the entire **No directional bias** section, so the
> batch was written and reported before anyone checked it against
> `DeckBalance`. It failed four ways. Batch 2, written from the same stale
> copy, still fails two and has not been corrected.
>
> If the brief in front of you does not contain the phrase *no directional
> bias*, stop and read this file instead.
>
> **Precedence, added after batch 4.** Where an invocation and this file
> disagree, **this file wins**, and the disagreement goes in the report. Batch
> 4 arrived as a paste that reinstated the struck 70/30 split, dropped *No
> directional bias*, dropped housekeeping steps 2 and 3, and added a line of
> its own: *do not change any Dart file in this phase.* The batch correctly
> followed this file on the first three and the paste on the fourth, and the
> result was a third consecutive batch of cards sitting outside the deck.
>
> **A batch whose file is not in `deckPaths` is not a finished batch.** If an
> invocation forbids the wiring, that is a deferral, not a completion: say so
> as the first line of the report rather than the last, and do not describe the
> validator as green — it is green against a deck the cards are not in.

### Amendment log

| When | Change |
|---|---|
| After batch 1 | Struck the "70 cast / 30 walk-ons" split. The cast file's speaker budgets govern; unnamed people appear inside cast members' cards, never as speakers. Batch 1 deviated this way and the deviation was correct. |
| After batch 1 | Housekeeping now includes registering flags in `lib/flags.dart` and running the validator to zero *before* reporting, rather than reporting a blocked validator. |
| After batch 1 | Added the flag-overhang constraint: each batch reads more pre-existing flags than it creates. |
| After batch 1 | Added pre-existing-flags-read vs new-flags-created to the report-back. |
| After batch 1's correction pass | Added the **No directional bias** section under Effect sizes, and the per-meter net and magnitude-band checks to housekeeping. Batch 1 shipped with cash at −310 and cops at +233, which made four of the eight endings unreachable; `DeckBalance` now fails the build on it. |
| After batch 3 | Fixed the chain arithmetic on batches 3, 6 and 9. A six-card slow burn does not fit alongside five two-card chains and two three-card chains inside twenty. **Four two-card + two three-card + one slow burn = 20.** Do not re-solve this each time. |
| After batch 3 | Added **The meters, not the endings**. `endings.json` is eight paragraphs and is revisable until release prep; the deck is not written against it. |
| After batch 3 | Reconciled the `cops` convention in `endings.json`. The deck treats cops as heat — 0 is invisible, 100 is maximum exposure — and the two cops endings were written the other way round before any card existed. `THE INDICTMENT` moved to cops-full and cops-empty became `BENEATH NOTICE`. No card changed. |
| After batch 3 | Added the invocation warning above, after a pasted stale copy of this file cost a batch its balance pass. |
| After batch 4 | Added the **precedence** rule above. An audit found all nine amendments intact in this file — the drift was never the document, it was three consecutive invocations by paste. |
| After batch 4 | Added **The vice**, the sanctioned `"vice"` schema key, and the validator and `DeckBalance` rules behind them. A greedy oracle survived 979 runs in 1,000, which means skilled play was unpunished and the four meters were decoration. |
| After batch 4 | Added **Gate on first-order flags** and its report line, after 1,000 simulated runs showed 24 cards that never drew because each sat behind a flag that was itself a chain's tail. |
| After batch 4 | Added **The post-Aurelio cap**, so batches 5–9 continue cast.md's decision rather than improvising a replacement consigliere. |
| After batch 5 | Raised the vice shared magnitude from 8–12 to **15–20** (compound 20–25) after the sweep disproved the original guess, added the asymmetric-shape rule, and wrote up the *vices pile onto the same meters* failure mode so an author avoids it rather than a solver fixes it afterwards. |
| After batch 5 | Narrowed the undeclared-vice validator rule to *shares a meter **and** offers no opposing lever anywhere* — "takes something and decides nothing". The original ≥5/≥5 proxy rejected six good cards. |
| After batch 5 | Vice draw weight set to **44–48** — the last of the three levers, and the one the arithmetic pointed at. |
| After batch 5 | **Stopped tuning against the simulation.** The greedy oracle has told us everything it can: it found the real structural defects (no forcing pressure, directional bias, four unreachable endings) and those are fixed. It survives because it recomputes perfectly and no human does, so chasing the last of it tunes the game against a player who does not exist, at the expense of the one who does. **The remaining difficulty question is a human playtest on the web build, scheduled around batch 7.** Do not sweep, re-tune magnitudes, or raise the vice quota before that happens. |
| After batch 5 | Blood is now budgeted **at the chain level**. Batch 5 came in at 9 of 100 because all eight of its arcs were business; the flag-free cards were normal. |
| After batch 6 | **Chains are delivered, not drawn.** New sanctioned schema key `"chain": {"id", "beat"}`; a resolved beat pins its successor, one chain in flight at a time, a forced opener if none has opened by swipe five. Measured effect on a random run: **0 completed chains → 2.18**, and the six-beat burns went from unreachable to 59 completions in 1,000 runs. |
| After batch 6 | **Chain length capped at four beats.** Six beats is 16–21 swipes of a 28-swipe median run. Batch 9's slow burn is cancelled; batches 3 and 6's ship as recorded legacy exceptions. |
| After batch 6 | **The 1–4 band target comes down from 15–20% to 5–10%**, with the rule that a 1–4 delta is a secondary meter or a blood card and never a side's whole movement. Five batches ignored the old number and the last two came in at 4.2% and 6.9%; the reasoning is written up under *No directional bias*. The short version is that the file was asking for the garnish batch 3 diagnosed, the player cannot see a 3, and the vice now supplies the contrast light cards used to. |
| After batch 6 | [cast.md](cast.md) and [flag-registry.md](flag-registry.md) marked **APPROVED**, retroactive from batch 1. Six hundred cards had been written against a file whose banner said not to. |
| After batch 6 | Don Aldo's hidden money is **established backstory**, not one card's subtext — see the *reserved threads* note in [content-bible.md](content-bible.md). Batches 7–9 may use it; they may not re-discover it. |
| After batch 7 | **Exempted suppression variants and cards gated on a character's death or departure flag from the gating-depth metric**, on the same footing as chain follow-ups, with the exempt count reported separately so it stays visible. Batch 7 scored 7 of 25 and every one of the seven was forced by another rule in this file: four were variants covering the batch's own deaths, three were the post-Aurelio cap's mandatory `aurelio_dead` cards, which sit at depth 4 by construction. A metric that a second rule guarantees you will fail measures the document, not the batch. Reasoning is written up under *Gate on first-order flags* so batch 8 does not re-derive it. |
| After batch 4 | Housekeeping steps 2 and 3 are now **enforced by the test suite**, not by good intentions: `shipped batch deck` in [card_deck_test.dart](../test/card_deck_test.dart) validates the concatenated deck from `deckPaths`, so a written-but-unwired batch fails the build. It also makes permanent the three authoring rules that had lived in a throwaway script since batch 2 — silence flags, every required flag settable, every speaker in the cast. |
| After batch 9 | **Added [premise-index.md](premise-index.md), and it is now a required read before writing a card.** Nine batches checked flags, speakers, gates, weights, chains and balance, and not one ever checked what a card was *about* — so the same premise got reinvented every few batches and every test passed it. The index is one line per card naming its situation, grouped so near-duplicates sit together. It found five confirmed duplicate families, the worst being **four Giulia cards that are all a car at the end of the street and what Anna has started doing about it**. |
| After batch 9 | **A scale factor that makes a card's own line untrue is rejected, not accepted.** Batch 9's first balance pass closed every meter to zero by scaling cash lowers ×0.61, which put twenty of twenty-nine cash costs on exactly −5 and made both sides of `b9_032` — *one of those costs more* — cost the same. The fix was to write earning rather than shrink payments, and to bound scale factors to **[0.85, 1.35]** so no future pass can flatten a card again. |
| After batch 9 | **Gating a chain opener costs roughly an order of magnitude in reach, and the brief has no lever left for it.** Measured over the real 900: batch 9's one flag-free opener opens in 4.8% of runs, its seven gated openers in well under 1%, and `sally_dead` — the deck's last death — lands in 0.3%. Deck logic is not a batch's to change, opener weight is fixed at 13–14, and ungating would break the reserved-thread rule, so nothing was changed. **It is a question for the human playtest**, written up under *Threads left open by batch 9* in [content-bible.md](content-bible.md). |

---

## The game

The player is the boss of a mafia family. A character appears and says
something — a request, a threat, a problem, a piece of news. The player swipes
left or right to answer. Every choice moves four hidden meters: **family**
(your own crew's loyalty), **commission** (standing with the other families),
**cops** (heat and exposure), **cash**. Each starts at 50. Any meter hitting 0
or 100 ends the run and kills the boss, so both directions are dangerous and
the player is always steering toward the middle.

There is a fifth counter, **blood**, which is the player's actual family —
wife, son, brother. Blood only drains, never rises, and does nothing except
decide which son inherits when you die.

The player sees no numbers. They see icons dimming and a card of text.

### The meters, not the endings

Write against the four meters and what they mean, **never against the text in
`endings.json`.** Those eight paragraphs are the shortest, cheapest thing in
the project: they can be rewritten at any point up to release prep without
touching a single card, and they will be, once the deck exists and somebody
knows what it actually feels like to play.

So if a batch's cards imply a meaning the ending text contradicts — as batch 3
found for `cops`, where 300 cards treat the meter as heat and the ending had
been written as protection — **report it and keep writing the cards.** The
cards are the game. Do not bend a card to match a paragraph.

That means: **a card is a decision under pressure, not a quiz.** Both sides
must be defensible and both must cost. Never write a choice where one side is
obviously correct. The best cards are ones where the player winces either way.

**Each card must stand on its own.** The player has no memory aid, no log, no
way to scroll back. The text is one complete self-contained line of speech —
the speaker states the situation and the ask in the same breath, the way a
real person walks into a room and explains themselves. Two to three short
lines maximum, because that is what the layout holds. Never write a card that
assumes the player remembers an unflagged earlier card. Never write "so, about
that thing" unless a flag guarantees the thing happened.

## Structure — exact counts

A run lasts 40 to 60 swipes against a deck of 900, so a player sees a small
fraction of what you write. Standalone cards always deliver. Chains often do
not. Budget accordingly.

| Count | Kind |
|---:|---|
| 55 | **Standalone, flag-free.** The backbone. Always eligible, works in any run, no dependencies. **Write these first** — they are less fun to write than chains, and if you leave them till last they will show it. |
| 20 | **Flag-aware standalone.** A single card gated on `requires.flags`, reacting to something the player did earlier, resolving completely on its own card. No follow-up. The cheapest continuity in the game and the most reliable — favour it. |
| 20 | **Chained.** Five two-card chains, two three-card chains, one four-card chain. **Four beats is the maximum** — see *Chain length* below; batch 9 does not get a slow burn. |
| 5 | **Suppression variants.** An alternate version of a card that already exists in this batch or an earlier one, gated by `excludesFlags` so the normal version disappears when it no longer makes sense. If you killed the sheriff's cousin, his friendly shakedown card must not still be in the deck. |

### Chain length — capped at four beats after batch 6

**Batches 3 and 6 each wrote a six-beat slow burn. Batch 9 does not.** The
instruction to "replace the four-card chain with a five-or-six-card slow burn"
was written without ever being checked against how long a run is, and it does
not survive the check:

- A run is 40–60 swipes by the brief and a median of **28** in measurement.
- Chain beats are delivered with a gap of two or three ordinary cards between
  them, so a six-beat chain occupies **16 to 21 swipes** — over half a median
  run, during which no other chain can open.
- Under the pre-queue weighted draw it was worse: a six-beat burn had roughly a
  **1% chance of reaching its third beat**, which is why the cap exists at all.

So: **four beats maximum.** A four-beat chain is 10–13 swipes, which a median
run can carry alongside one or two others.

The two existing six-beat burns — `b3_076` *The two doors* and `b6_076`
*Lucia's boy* — **ship as they are.** A rare over-long storyline is a better
problem than a rewrite, and both are recorded as legacy exceptions in
[content-bible.md](content-bible.md) and named in the test that enforces the
cap. **Do not copy the shape.**

**The chained twenty is a hard total and so is the hundred.** With the cap in
place the standard layout — five two-card + two three-card + one four-card —
works for every remaining batch, including 9.

**"Flag-free" means silence-free too.** Every card spoken by a cast member
must carry that member's silence flags in `requires.excludesFlags` — cast.md
hard rule 2, not optional. So a flag-free standalone is a card with an empty
`requires.flags` and *nothing in `excludesFlags` but its speaker's silence
flags*. Anything beyond that is gated content and counts elsewhere.

### How a chain works

An opening card whose choice sets a flag, then follow-ups gated on that flag
with `once: true`, **and every card in the chain carries
`"chain": {"id": "<the opener's id>", "beat": n}`.** Beats run 1..n with no
gaps and the opener is beat 1.

**That key is what delivers the chain, not the weight.** When a beat resolves,
the engine pins its successor and deals it after two or three ordinary cards;
while a chain is in flight no other chain can open, and a beat contradicted in
the meantime is dropped rather than deferred. Keep the follow-up weights at
42–50 anyway — they are what the card is worth if it is ever drawn any other
way — but they are no longer load-bearing.

- The opener sets its chain flag on **both** sides. The branch is carried by
  the character flags set alongside it. This is what stops a chain
  dead-ending on the path the player did not take.
- Every follow-up must read correctly from **either** branch.
- Every chain must be survivable at any entry point — if the player dies
  mid-chain nothing dangles into a later run.
- Every follow-up must restate enough in its own line that a player who has
  forgotten the setup still understands what is being asked.

### Weights

| Kind | Weight |
|---|---|
| Flag-free standalone | 7–10 |
| Chain opener | 13–14 |
| Flag-gated standalone, suppression variant | 22–28 |
| Chain follow-up | 42–50 |
| **Vice** | **44–48**, gated or not. A vice at ordinary standalone weight is met about once every seventy swipes, which is not part of a forty-swipe game. Raising batch 5's eight from 10/26 to 44–48 took the greedy oracle from 942/1000 to 848/1000 and put 1.5 vices in an average random run instead of 0.5. |

## Cast

Read [cast.md](cast.md). These people are permanent and the player knows them
— the same uncle every time, the same wife, the same captain on the payroll.

**Follow the speaker budgets in cast.md.** The table at the bottom of that
file governs; check the batch against it before shipping. There is no
walk-on-speaker allowance.

**Unnamed people appear inside cast members' cards, never as speakers
themselves** — the shoe repairer on Starr Street, the man shot outside his
mother's house. Where a voice genuinely belongs to no one, use the reserve
strings (`THE STREET`, `THE CLUB`, `A SOLDIER`, `THE PAPERS`, `THE PHONE`),
which are budgeted at roughly six cards per hundred. A reserve voice is never
a person: if you find yourself giving one a name, it belongs to a cast member
instead.

Write cast members as continuous people. The uncle remembers being passed
over. The captain's price has gone up since the last batch. Where a
character's running-state flag is set, gate the cards that acknowledge it —
that is what makes them feel alive rather than randomly generated. If you are
deliberately evolving one, note it in cast.md so the next batch continues it
instead of reverting.

Have fun with them. The nephew should be funny right up until he is not. The
priest should get one line per batch that lands sideways. The captain taking
money should feel almost warm, which is the problem.

## Voice

Understated. These are people who talk around things. Threats are polite,
favours have hooks in them, nobody explains what everybody in the room already
knows. No movie quotes, no *capisce*, no cartoon accents.

## Effect sizes

Most swings **5 to 12**. Reserve **15 to 25** for rare, obviously heavy cards.
A choice usually helps one or two meters and hurts one or two.

Blood costs go on **maybe one card in four**, and only when the choice
genuinely spends your wife, son, or brother to buy something for the four
meters. Do not sprinkle blood for flavour — it means less every time you do.

**Budget it at the chain level, not by counting at the end.** Batch 5 came in
at 9 of 100 against a 18–19 norm, and the whole shortfall was in its chains:
batches 1–4 put 3–5 blood cards among their twenty chained cards, batch 5 put
none, because all eight of its arcs were business — a detective, a union, a
lottery bill, a haulage sale. The flag-free cards were normal. So: **at least
one or two chains per batch must spend the house**, decided when the chains are
chosen rather than discovered afterwards. Giulia carries half the deck's blood
on her own; a batch she is barely in is a batch that will come up short.

### No directional bias

**The deck must not lean.** Across a batch, every meter should be raised about
as often as it is lowered and by about as much. For every card that costs
money or raises heat there must be cards that do the reverse: a choice that
spends cash to cool the police off, one that accepts heat to take a score, one
that burns standing to get either.

This is the defect batch 1 shipped with. It fell into one template — *do the
thing: family up, cops up, cash down* — and its mirror, a hundred times. Cash
netted −310 and cops +233, so the meters only ever travelled one way, and four
of the eight endings became statistically unreachable: nobody ever died of an
empty cops meter, because nothing in the deck could empty it. A player cannot
steer toward the middle of a road that only runs downhill.

The trap is that each card looks fine alone. It is visible only in aggregate,
which is why it is a mechanical check and not a matter of judgement:

- **Every meter's net sum across the batch must be inside ±50.**
- **At least 60% of non-zero deltas must be in the 5–12 band**, aiming for
  ~80%, with **~5–10% in 1–4** and ~4–6% in 15–25.
- **No choice-side may leave all four meters unmoved.** A swipe that does
  nothing is not a decision.
- **No choice-side's largest movement may be in the 1–4 band unless that side
  costs blood.** See below.

#### The 1–4 band — revised after batch 6

The target here was 15–20% for five batches and the last two came in at 4.2%
and 6.9%, so it was decided rather than left to drift. **The low band is not a
loss of texture, and the target was superseded.** Three things changed under it:

1. **The file was arguing with itself.** Batch 3's correction named
   *small-delta garnish* as the first of the three causes of its balance
   failure — "nearly half the deltas were 3s and 4s" — and every batch since
   has written to that lesson. A brief cannot ask for 15–20% of a thing it
   also calls garnish.
2. **The player cannot see a 3.** There are no numbers on screen; a meter is an
   icon's opacity across a 0–100 range. A 3-point move is below the point at
   which a dimming icon reads as having changed, so a side whose *only*
   movement is 1–4 is, to the player, the inert side `DeckBalance` already
   fails — one step politer.
3. **The contrast argument now has a better mechanism.** The original reasoning
   was sound: an all-heavy deck flattens as surely as an all-light one. But
   before batch 5 the heavy band was 0.3–3.5% and meant nothing in particular.
   The vice put real weight in 15–25 and attached a *meaning* to it, so light
   cards are no longer what supplies contrast. Heavy against ordinary is the
   contrast now.

What 1–4 is still for, and it is worth keeping: **the second meter on a side
whose first meter is doing the work.** "This matters, and that barely does" is a
real shape. Batch 6 uses it that way — 21 of its 29 minor deltas sit beside a
5-or-more on the same side, and four of the remaining six are on sides whose
real cost is blood.

So: **5–10%, secondary or blood only.** `DeckBalance` prints the count of
garnish sides on every run so the number stays visible, and it does **not** fail
on it — batches 1–4 carry 8, 5, 4 and 6 blood-free garnish sides between them
and correcting shipped batches is a separate decision, not a silent one.

Two habits that cause the drift, worth avoiding from the first card:

1. **Opportunity cost is not an outlay.** Turning down a score does not cost
   cash — money you never had is not money you lost. Write the refusal as 0
   cash and put the loss in family or commission where it belongs.
2. **Don't let both sides push a meter the same way.** If both answers raise
   heat, the card is not a decision about heat, and the meter has nowhere to
   go but up.

`DeckBalance` in [deck_balance.dart](../lib/deck_balance.dart) computes all of
this; [deck_balance_test.dart](../test/deck_balance_test.dart) runs it per
batch and prints the figures every time.

## Flags

**Every meaningful flag should both add cards and remove cards.** If a batch
sets far more flags than it excludes on, it has written consequences that do
not suppress the world they contradict. Check this before finishing.

**Each batch must read more pre-existing flags than it creates new ones.**
Count flags this batch reads that earlier batches set, against flags this
batch introduces. The first number must exceed the second. There are currently
24 flags set and unread across the deck; that overhang shrinks from here
rather than growing. *Batch 1 was the seed and is exempt.*

### Gate on first-order flags

**Added after batch 4, from playtest data.** A flag's *depth* is how many gated
cards stand between it and an ordinary run: depth 1 means some ungated card
sets it, depth 3 means the player must complete two earlier gated cards first.

**Gate flag-aware cards on depth-1 flags.** A card behind a flag behind a chain
is a card nobody sees: 1,000 simulated runs against the 400-card deck never
drew 24 of them, and almost every one was gated on a flag that is itself a
chain's tail — `sally_retired`, `matty_pinched`, `concetta_sided_sally`.
The card is well written, correctly wired, validates clean, and is invisible.

- Chain **follow-ups** are exempt: a follow-up is *supposed* to sit behind its
  opener, that is what a chain is, and the raised weight is what carries it.
- **Suppression variants are exempt, and so is any card gated on a character's
  death or departure flag** — `*_dead`, `*_gone`, `adler_ran`. *Added after
  batch 7; see below for why.*
- **What the metric counts, therefore: the flag-aware standalones and the gated
  vices, minus any of those gated on a death or departure flag.** That is the
  set where the gate was the author's free choice, which is the only set worth
  scoring.
- **Target: near zero at depth ≥ 2.** Where a thread genuinely needs a late
  state, prefer a first-order consequence flag the player set themselves —
  `at_war`, `feds_active`, `dope_sanctioned`, `ranieri_watching`,
  `matty_killed_wrong` — over the terminus of somebody else's chain.
- **Report the exempt count separately**, as a number and not a shrug: *N at
  depth ≥ 2 of M counted, plus K exempt.* The exemption is a change to what is
  scored, not to what is looked at, and a batch whose exempt pile is quietly
  growing is worth noticing.
- Baseline to beat, counting *all* gated cards including follow-ups: batch 1
  had 12 of 37 at depth ≥ 2, batch 2 18 of 39, batch 3 25 of 43, batch 4 24 of
  41. The trend is the wrong way.

#### Why the exemption — added after batch 7

**Two rules in this file were asking for opposite things.** Batch 7 scored 7 of
25 against batch 6's 4 of 25, and not one of the seven was a choice:

1. **Four were suppression variants covering the batch's own departures.** A
   variant exists to replace a card once a state makes it nonsense, so its gate
   *is* that state, and it cannot be shallower than the state is. `matty_dead`
   is depth 6 because batch 6's burn is six beats long; there is no shallower
   gate for a card whose whole job is to fire when Matty is dead. Scoring that
   as a defect scores the death, not the card.
2. **Three were the post-Aurelio cards**, which **the post-Aurelio cap above
   requires** — three or four per batch, every batch from 5 to 9. `aurelio_dead`
   is the tail of batch 4's four-beat chain, so those cards are depth 4 by
   construction. The only way to score better was to disobey the cap.

A metric a second rule guarantees you will fail is measuring the document rather
than the batch, and it teaches the next batch to argue with the number instead
of using it. So the number now counts only gates the author picked freely.

**The exemption is not permission.** The defect this metric was built to find is
alive and unchanged: a flag-aware standalone parked behind somebody else's chain
tail — `sally_retired`, `matty_pinched`, `concetta_sided_sally` — is still a
well-written, correctly-wired, invisible card, and it still counts.

### The post-Aurelio cap

`aurelio_dead` got its first setter in batch 4, and [cast.md](cast.md) settles
what the family looks like afterwards: **nobody inherits the chair.** Batches
5–9 honour the budget written there — Aurelio keeps his 13 cards per hundred,
all excluding `aurelio_dead`, and the world without him is **three or four
`aurelio_dead`-gated cards per batch**, drawn from the Concetta, Sally, Adler
and reserve allocations. Not a second parallel deck.

Before building any chain, check the **reserved threads** section of
[content-bible.md](content-bible.md). A reserved thread is one a later batch is
committed to building on a flag that already exists. Do not re-seed one with a
fresh opening card — the two versions will contradict each other in the same
run.

## Housekeeping

This is the part that rots if you skip it.

1. Every new flag goes into [flag-registry.md](flag-registry.md) with a
   one-line description of what it means and which cards set and read it.
2. **Every new flag also goes into `GameFlags` in
   [flags.dart](../lib/flags.dart)** — new chain flags into `chainFlags` under
   a `// batch {N}` comment, anything else into the group it belongs to. This
   is bookkeeping, not gameplay code, and it is part of finishing the batch.
3. Add the batch's file to `CardRepository.deckPaths` in
   [card_repository.dart](../lib/card_repository.dart) — one line.
4. Update [cast.md](cast.md) with anything that changed for a cast member.
5. Append a summary of the batch to [content-bible.md](content-bible.md): the
   chains built, the threads deliberately left open, anything reserved for a
   later batch.
6. **Run the validator and the test suite, and fix everything they name.**
   Report a zero, not a blocker. This includes
   [deck_balance_test.dart](../test/deck_balance_test.dart), which fails the
   batch if any meter's net exceeds ±50 or the 5–12 band falls below 60%.
   Balance is corrected by re-pointing numbers, never by rewriting a line to
   suit an arithmetic target — if a card's fiction cannot carry the number,
   change a different card.

## Report back with

- Card count by structure category.
- The chains built and their lengths.
- Cards spoken per cast member against their budget.
- New flags added.
- Flags this batch reads that earlier batches set.
- **Count of pre-existing flags read versus new flags created.** The first
  must exceed the second.
- **How many gated cards sit at flag-depth ≥ 2**, of the set the metric counts —
  flag-aware standalones and gated vices, minus any gated on a death or
  departure flag. Target near zero; name any that remain and why they earn it.
  **Report the exempt count separately** — chain follow-ups, suppression
  variants, death-gated cards — as *N of M counted, plus K exempt*, so the
  exempt pile stays visible instead of vanishing.
- Any card you are unsure about.

## The vice

**Added after batch 4.** A greedy simulation survived 979 runs in 1,000 against
the 400-card deck. Not because sides are safe — at 50/50/50/50 every move is
away from the middle — but because **every card offers a side that pulls back
whichever meter has drifted.** The player is never denied the pull-back. Teeth
means denying it.

A **vice** is a card where, for every meter, the two sides never disagree in
sign, and at least one meter is pushed the same way by both sides by 8 or more
(and in practice by 15 or more — see the magnitudes row).
The player chooses which damage to take and never whether to take it. It is
declared in the card with `"vice": true` and the validator enforces both
halves: an undeclared card that shares a meter *and* offers no opposing meter
anywhere is a hard failure, and a declared vice that hands a lever back is too.

Sharing a meter is not by itself the fault, and the validator does **not** fail
a card merely for it. The defect is a card that *takes something and decides
nothing*: it shares a meter **and** offers no opposing meter anywhere, so the
player has no lever at all. Six of batch 2's thirteen are fine — a condolence
costs whether you go or send, and the decision lives on standing — and they
keep no label. (This supersedes the first draft of the rule, which failed any
undeclared same-direction push of 5 or more; that was a proxy, and it rejected
the six good cards along with the bad ones.)

| | |
|---|---|
| How many | **8 per 100 in batch 5**, and no more without asking. 3 flag-free, 5 gated. They come *out* of the other budgets — 55 → 52 flag-free, 20 → 15 flag-aware — not on top. |
| Where they sit | Gate the five on **depth-1 consequence flags** the player set themselves: `at_war`, `feds_active`, `dope_sanctioned`, `matty_killed_wrong`, `ranieri_watching`. That makes them arrive late *and* be earned, which is the same fix twice. |
| Magnitudes | Shared meter **15–20 on both sides**; compound vices **20–25**. Second meter 5–10. *This replaces the original 8–12, which was a guess and was wrong:* a sweep against the real deck showed an 8–12 shared push is absorbed by two or three ordinary cards, and raising it to 15–20 moved the greedy oracle's survival from 973/1000 to 942/1000 with no other change. A vice that can be walked off is an expensive card, not a vice. |
| Shape | Asymmetric, and alternate which side is which. One side takes the **bigger** share of the unavoidable push and nothing else; the other takes less of it and pays somewhere else instead. Which one the player wants depends on which meter is nearest to killing them — that is the decision. Two sides that differ only in the size of the same push are not a card. |
| Blood | **Never on both sides of a vice.** A card that takes blood whichever way you swipe is punishment, not a decision. |
| Not arbitrary | The text must name why the cost is unavoidable — the body exists, the subpoena exists. And both sides must still be defensible as *people*: a vice is "which of these two do you fail", never "lose 10 or lose 10". |
| Failure mode | **Vices pile onto the same meters, and you will not notice while writing.** A vice is made of costs, so every one you write reaches for family or cash, and eight of them land on top of each other — batch 5's first draft came in at family −68, cops +50, cash −69 and needed a search over the combinations to fix. Spread it *while writing*: decide each card's shared meter first, pair them off two per meter with one pushing each way, and only then choose which second meter each side pays in. Two of the eight should force a **gain** you cannot refuse — money already in the house, a crew closing ranks — because that is the only thing that balances the other six. |
| Balance | `DeckBalance` fails a batch whose vices contribute more than ±30 to any one meter. Ten vices all raising cops would add two hundred whatever the player did, which is the bias the check exists to stop arriving through its one open door. Pair them: for every card that makes heat unavoidable, one that makes cooling it unavoidable and expensive. |

**No swipe counter and no meter-band gating.** Escalation comes from the flags,
because the flags that accumulate mid-run are the player's own consequences.

## Do not

- Change the schema. **Two sanctioned exceptions**, and no more without the
  same conversation each earned:
  - `"vice"`, boolean, optional, defaulting false — added after batch 4. An id
    convention would have been worse, and nothing else can separate a
    deliberate vice from batch 2's accidents.
  - `"chain": {"id", "beat"}`, optional — added after batch 6. The
    opener-to-follow-up relation existed only in flag-registry.md's prose and
    in the `b{N}_076`–`b{N}_095` id convention, so the engine could not see it.
    **Inference was tried and rejected:** deriving it from *this card sets flag
    F on both sides* misfires on 18 of the 87 both-sides flags, because
    character and world flags are set on both sides too. `aurelio_dead` alone
    is required by five suppression variants, so an inferring queue delivered
    the whole post-Aurelio budget as a five-card cutscene the moment he died. A
    separate manifest file was the alternative and was rejected for the reason
    this project has been bitten by three times: a second file to keep in sync.
- Touch the layout, the deck logic, or the endings. If the endings contradict
  what the cards mean, say so in the report — do not edit either one to agree.
- Gate anything on blood.
- Invent a new permanent character. The sixteen are the sixteen.
- Reuse ids or flag names from earlier batches. Ids are prefixed `b{N}_`.
- Write more than 100 cards in one go even if you have momentum — the batch
  boundary is what keeps quality from sliding.
