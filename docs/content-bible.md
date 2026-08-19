# Content Bible

A running log of what each batch built and what it left open. Read the last
two entries before writing a new batch.

Sources of truth: [cast.md](cast.md) for who these people are,
[flag-registry.md](flag-registry.md) for what a flag means.

---

## Conventions settled in batch 1

Recorded because they were decisions, not defaults, and the next eight batches
should follow them rather than re-litigate them.

**"Flag-free" means silence-free too.** Every card spoken by a cast member
carries that member's silence flags in `requires.excludesFlags` — that is
cast.md hard rule 2 and it is not optional. So a "flag-free standalone" is a
card with an empty `requires.flags` and *nothing in `excludesFlags` but its
speaker's silence flags*. Anything beyond that is gated content and counts
against a different budget.

**Walk-ons are subjects, not speakers.** cast.md hard rule 3 forbids a name at
the top of a card that isn't one of the sixteen. Shopkeepers, strangers and
unfamiliar cops appear as the *content* of a reserve-voice card — `THE STREET`
carries the shoe repairer on Starr Street, `THE CLUB` carries the shooting of
Carlo Sanna. Reserve is budgeted at 6.7%, so roughly six per hundred cards,
and that ceiling is what protects the recognition effect.

**Chain flags carry the conversation, not the branch.** A chain opener sets its
chain flag on *both* sides; the branch is recorded in the character flags set
alongside it. This means a follow-up can never dead-end on the path the player
didn't take, and every follow-up's text is written to read correctly from
either branch. The chain-flag block in flag-registry.md lists them separately
for this reason.

**Weights.** Flag-free standalone 7–10. Chain openers 13–14. Flag-gated
standalone and suppression variants 22–28. Chain follow-ups 42–50 — high
enough to surface inside the same run against a deck heading for 900.

**Blood.** 19 of 100 cards. Only where the choice genuinely spends the wife,
the son, the sister or the mother. Never on a Rosa card.

**Two later sections belong with these and live at the end of the file, where a
new batch is already reading:** *Established backstory* — world facts a batch may
use and may not re-discover — and *Documentation audit*, whose speaker-drift
table is the one thing batches 7–9 have to aim at rather than find out about.

---

## Batch 1 — `assets/cards/batch_1.json`, ids `b1_001`–`b1_100`

**Composition.** 55 flag-free standalone · 20 flag-gated standalone ·
20 chained · 5 suppression variants.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **The wrong man** — `b1_076`→`b1_079` | Matty kills a kid on Knickerbocker for not paying a tax. Moe Wills arrives with a bill, because the kid was running numbers for *him* and was current. Sally forces a ruling: under the player's hand, or outside it. Giulia delivers the invoice — Lucia sat in her kitchen asking whether her son will be alive at Christmas. |
| 3 | **Eight years** — `b1_080`→`b1_082` | Angelo asks for the money that was held for him and wasn't. The crew decides a man who came home that clean must have made a deal. He finds the car outside his mother's building and asks to be accused to his face. |
| 3 | **The pension fund** — `b1_083`→`b1_085` | Fallon offers a legal loan out of the local's pension. The piers keep dying and he keeps needing more. It ends in a newspaper: books subpoenaed, a trucking company named in the third paragraph, nobody named in the fourth. |
| 2 | **The raise** — `b1_086`→`b1_087` | Kiernan won't say a number out loud. Paid, he does an unasked favour and bills for it in the same breath — now there's a sergeant too. |
| 2 | **The room upstairs** — `b1_088`→`b1_089` | Rosa offers the room in lieu of the vig. Giulia reports that Rosa crossed the street at the fish market. Take the place, or write it off. |
| 2 | **The question he won't ask** — `b1_090`→`b1_091` | Duke offers to ask the narcotics question out loud. Whichever way it lands, Sally wants to be the one who announces it. |
| 2 | **New money at this table** — `b1_092`→`b1_093` | Braca's opinion, twice, about the airport freight. Then a sit-down he can chair and be owed for, or unwell for. |
| 2 | **Aurelio is wrong** — `b1_094`→`b1_095` | The consigliere's counsel on Ranieri is thirty years out of date and completely sincere. Ranieri turns up on the step with a spring grand jury date and asks after the player's mother. |

### Suppression variants

Each pairs with a card whose `excludesFlags` was widened so the normal version
leaves the deck when it stops making sense.

| Variant | Replaces | Gate |
|---|---|---|
| `b1_096` Rosa behind a bakery counter, asking for one afternoon | `b1_088` the debt conversation | `rosa_place_taken` |
| `b1_097` Kiernan frightened instead of greedy | `b1_086` the raise | `ranieri_case_open` |
| `b1_098` Duke asking sideways instead of directly | `b1_090` the question | `dope_banned` |
| `b1_099` Matty disowned and still volunteering | `b1_076` the killing | `matty_disowned` |
| `b1_100` Fallon indicted, in the driveway, having given no name | `b1_083` the pension offer | `fallon_indicted` |

### Flags

**Eleven new**, all in flag-registry.md: ten chain flags
(`matty_wills_bill`, `matty_answered`, `angelo_home_asked`, `angelo_question`,
`fallon_pension_asked`, `fallon_desperate`, `rosa_asked`, `duke_spoke`,
`braca_freight`, `aurelio_frame_ranieri`) and one world flag, `rosa_room`.

**Both add and remove cards this batch:** `dope_sanctioned`, `dope_banned`,
`matty_killed_wrong`, `matty_disowned`, `rosa_place_taken`, `rosa_room`,
`ranieri_case_open`, `fallon_indicted`, `angelo_paid`, `wills_stopped_paying`.

### Reserved threads — claimed, do not re-seed

A reserved thread is an idea a later batch is **committed** to building, using
the flag that already exists. It is not a suggestion. If a batch finds itself
inventing an opening card for one of these, it has re-seeded a thread that was
already planted and the two versions will contradict each other in the same
run — check this list before writing any chain.

---

**`matty_made` — the boy gets straightened out for the killing he botched.**
**Reserved for batch 2. Three-card chain.** — **DELIVERED**, `b2_076`→`b2_078`.
Terminates in `matty_pinched` as this section asked. Closed; do not re-open.

`b1_063` is the only setter in the deck: Sally comes with four names for three
chairs, puts the player's nephew last, and the player can take Matty's name
over the uncle's three. It costs `sally_humiliated` and 11 blood, and today
**nothing reads the flag afterwards** — the player buys the most consequential
thing in the family's gift and the deck says nothing back.

What batch 2 must build:

- The chain opens on `matty_made` and must read correctly whether or not
  `matty_killed_wrong` is set — a player can reach the ceremony without the
  body, and the cards cannot assume the body.
- Where both *are* set, that is the sharp version: the family straightened out
  a man for work he did wrong, everyone in the room knows it, and the
  arithmetic every other waiting man now does is the subject.
- It should be able to end somewhere other than well. `matty_pinched` has no
  setter anywhere in the deck and is the obvious terminus for one branch.
- Sally is the second voice. He put Matty last and was overruled in front of
  people; he does not raise it again and does not need to.

Do not open this with a fresh "should the boy be made" card. That decision has
already been taken at `b1_063` and re-asking it is the failure mode this
section exists to prevent.

---

### Other threads left open

Set in batch 1 and read by nothing yet — available rather than reserved.
Batch 2 should pick some up rather than seed more. **Struck items were picked
up in batch 2; see that batch's own open-threads list for what is live now.**

- ~~`sally_faction`~~ — Sally counting names, reserved as the batch-3 slow
  burn. **DELIVERED**, `b3_076`→`b3_081`, six cards, terminating in
  `sally_retired` or `sally_moved` + `house_split` as this section asked.
  Closed; do not re-open.
- ~~`giulia_told` vs `giulia_lied_to`~~ — the honest branch has a reader now
  (`b2_056`).
- ~~`ranieri_offered`~~ — read at `b2_057`, and it is expensive: refusing to
  disown the man who did it is +14 cops.
- `braca_owes_you` — still reachable, still unspent. ~~`braca_owed_him`~~ is
  read at `b2_059` and set again at `b2_093`.
- ~~`nardi_used`~~ — read at `b2_060`. `nardi_debt_cleared` still dangles.
- ~~`wills_partner`~~ — set at `b2_094` and read at `b2_098`. `wills_dope`
  still dangles.
- `kiernan_price_up_2` — the second notch is **still** reachable and
  unanswered; batch 2 did not take it. The third refusal is now built
  (`b2_062` → `kiernan_cold`), so this one wants a reader, not a chain.

### Wiring — done after batch 1 shipped

Recorded because both were one-time transitions and the next eight batches
inherit the result rather than repeating it.

1. **All 96 flags registered** in `GameFlags.deckFlags`
   ([flags.dart](../lib/flags.dart)). `CardValidator` went from 249 issues to
   zero on `batch_1.json`; none of the 249 was a card fault. Registering a new
   batch's flags in `flags.dart` is now part of finishing that batch.
2. **The real deck is loaded.** `CardRepository.deckPaths` lists the batch
   files and `loadDeck` validates them concatenated, so a duplicate id across
   two batches fails rather than shipping. Add one line per batch.
   `core.json` is retired from the running deck and kept only as a test
   fixture — it holds placeholder filler and a pre-cast cast (a wife called
   Rosa, a `SAL`) that would contradict [cast.md](cast.md) if it shipped.

---

## Batch 2 — `assets/cards/batch_2.json`, ids `b2_001`–`b2_100`

**Composition.** 55 flag-free standalone (`b2_001`–`b2_055`) · 20 flag-gated
standalone (`b2_056`–`b2_075`) · 20 chained (`b2_076`–`b2_095`) ·
5 suppression variants (`b2_096`–`b2_100`).

Ids are laid out by category on purpose, the same as batch 1, so a category
count is a range check rather than a survey.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 3 | **The button** — `b2_076`→`b2_078` | The reserved `matty_made` thread. Sally: the boy has a vote now and men who waited eleven years are watching what he gets — a corner or a desk, but do it where they see. Matty, straightened out a fortnight, has had four men bring him things instead of the player and wants a medal for saying no; the fifth is Bobby Zito, who waited eleven years. Then a collect call from the Eight-Three: a car, two men he won't name, and a bag that isn't his. **Both sides set `matty_pinched`** — the arrest is the event, the choice is only whether the house pays. |
| 3 | **The ledger** — `b2_079`→`b2_081` | A man walks into Flushing Avenue with a paper wanting every book since 1961, and Adler signs for it because refusing to sign is also an answer. Aurelio, thirty years out of date and entirely sincere: paper is slow, they ask because they have nothing, and what they cannot survive is a frightened bookkeeper. Then Adler after six hours on Cadman Plaza, saying he is not made, took no oath, and has a house in Forest Hills. Ends in `adler_ran` or `feds_active`. |
| 4 | **A third of the money** — `b2_082`→`b2_085` | Duke has eaten four lunches with a man from Ozone Park and reports it before anyone else can. Sally names the real risk: a man like that doesn't leave over money, he leaves over being made to explain himself. Bushwick's envelope comes in light and the man who counted it twice tells nobody but a soldier. Duke asks for Bushwick to be its own thing, once, and shakes hands either way. |
| 2 | **The house on Long Island** — `b2_086`→`b2_087` | Giulia has been driving out to Massapequa on Tuesdays. Whichever way it lands, by Friday the club has turned it into *the boss is taking his money out*, and two capos have asked the same question the same careful way. |
| 2 | **A body for the sheet** — `b2_088`→`b2_089` | Kiernan wants a name for eleven burglaries on Menahan Street — one of yours who's going away anyway — and he'd be a captain in good standing again by Christmas. Then a new inspector who reads the arrest sheets himself, and: are we the same two men. |
| 2 | **Five months** — `b2_090`→`b2_091` | Sally on Mucci: five months in his mother's kitchen, no work, no envelope, and a lunch with a man nobody could place. Neither branch pays him, so the follow-up reads from both. Angelo asks once more and then stops asking. |
| 2 | **After me** — `b2_092`→`b2_093` | Braca is seventy-nine and there's a table being set. Then Aurelio: he's told three men he's putting his affairs in order and two of them aren't friends of ours, and a man who isn't sitting at a table is generally on it. |
| 2 | **The building on Halsey** — `b2_094`→`b2_095` | Forty apartments and a landlord who hasn't fixed a boiler since Eisenhower. Partnership, or a loan at your rate. Either way the building is his, the boiler works, and his people have started asking again why they pay a tax to men who moved to Long Island. |

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b2_096` Duke cordial, from outside, with arithmetic | `b2_082` the lunches | `duke_broke_off` |
| `b2_097` Adler with an envelope that came back sealed | `b2_088` the burglary pattern | `kiernan_cold` |
| `b2_098` the street, on who collects on Halsey now | `b2_094` the building | `wills_partner` |
| `b2_099` Aurelio in a dark office above the linen supply | `b2_079` the subpoena, and every Adler card | `adler_ran` |
| `b2_100` Angelo asking for his mother's operation | `b2_090` the suspicion | `angelo_flipped` |

### Flags

**Twelve new**, all chain flags, all in flag-registry.md: `matty_button`,
`matty_own_piece`, `ledger_day`, `ledger_answered`, `duke_lunches`,
`duke_held`, `duke_short`, `giulia_house`, `kiernan_owed_name`,
`angelo_watched`, `braca_after`, `wills_building`.

**No new world or character flags.** Batch 2 deliberately spends batch 1's
currency instead of printing more: it gives first setters to eleven flags that
had none — `matty_pinched`, `duke_broke_off`, `duke_proven_loyal`,
`adler_ran`, `adler_subpoenaed`, `angelo_flipped`, `aurelio_wrong_proven`,
`angelo_dead`, `concetta_silent`, `fallon_replaced`, `colla_refused_you` —
and first readers to several more. *(Corrected in batch 6's audit: this said
nine and listed eleven, and one of the eleven was `kiernan_cold`, which
`b1_060` had already set. `angelo_dead` is the first setter that was missing
from the list.)*

**Reads that batch 1 sets** (22): `angelo_suspected`, `at_war`,
`aurelio_frame_ranieri`, `braca_owed_him`, `colla_warned_you`,
`concetta_blessing`, `dope_banned`, `dope_sanctioned`, `duke_dope`,
`feds_active`, `giulia_shielded`, `giulia_told`, `kiernan_cold`,
`kiernan_refused`, `matty_made`, `nardi_used`, `ranieri_case_open`,
`ranieri_offered`, `rosa_room`, `sally_faction`, `wills_partner`,
`wills_stopped_paying`.

**Both add and remove cards this batch:** `duke_broke_off`, `kiernan_cold`,
`wills_partner`, `adler_ran`, `angelo_flipped`, `angelo_paid`,
`matty_pinched`, `matty_disowned`. Every suppression variant's gate is also
in the `excludesFlags` of the card it replaces — the pairing is the check.

### Convention added in batch 2

**A flag-free card that puts a second cast member physically in the room
carries that member's silence flags too.** Batch 1 excluded only the
*speaker's*, which lets Giulia report a visit from a dead uncle. Eight cards
here follow the stricter rule (`b2_007`, `b2_012`, `b2_014`, `b2_022`,
`b2_031`, `b2_036`, `b2_038`, `b2_068`). They still count as flag-free —
`requires.flags` is empty and the addition is a silence flag, not a gate.

**Known tension, unresolved:** `matty_pinched` is not a silence flag, so by
the letter of the rule a Matty card can still surface while he is in the
Tombs. Batch 2 excludes it on the gated and chained Matty cards but left the
five flag-free ones alone rather than diverge from batch 1 mid-deck. Batch 3
should decide this deck-wide — either promote `matty_pinched` to a silence
flag for `MATTY` in cast.md, or accept it.

### Outstanding defect — balance

**Batch 2 failed `DeckBalance`: cops net +114 and cash net −208**, both over
the ±50 limit, with the 5–12 band at 62.7%. Found during batch 3, **corrected
during batch 4** — figures in that entry.
Same cause as batch 3's (see that entry): the batch was written from a copy of
the prompt that predated the **No directional bias** section. It wants one
re-pointing pass, numbers only, no text.

### Threads left open by batch 2

- ~~**`sally_faction`**~~ — read at `b2_058` and **built in batch 3** as the
  six-card slow burn `b3_076`→`b3_081`. It opens on Adler noticing the envelope
  road rather than on a fresh "is your uncle moving" card, per this note.
- `duke_broke_off` — a capo running a third of the money outside the house.
  One reader (`b2_096`). It wants two or three more and it is the obvious
  route into `house_split` alongside Sally.
- `adler_ran` — one reader (`b2_099`). Where did the books go, and who is
  doing the arithmetic now.
- `matty_pinched` — two readers (`b2_066`, and the chain that sets it). A made
  man facing real time is the natural pressure toward `angelo_flipped`'s
  mirror: whether *Matty* talks.
- `braca_after` / `braca_sponsor` — the succession is raised and unresolved.
- `kiernan_price_up_2` — still reachable and still unanswered. Batch 1 flagged
  it, batch 2 did not take it. `kiernan_gone` has no setter anywhere.
- `giulia_left`, `sally_moved`, `sally_retired`, `wills_war`,
  `rosa_place_burned`, `nardi_talked`, `concetta_sided_sally`,
  `aurelio_failing`, `fallon_dead` and the remaining `*_dead` flags still have
  no setters. Nine batches is enough room; batches 3–5 should start spending
  them rather than saving them all for the end.

### Wiring — outstanding

Batch 2 was written under a no-Dart constraint, so two one-line edits are
pending and are **not** done:

1. The twelve new chain flags into `GameFlags.chainFlags`
   ([flags.dart](../lib/flags.dart)) — exact snippet is in
   [flag-registry.md](flag-registry.md) under *Pending changes*.
2. `assets/cards/batch_2.json` into `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

**Both landed during batch 4** — see that entry's *Wiring — CLEARED*. Until
they did, `batch_2.json` was not in the running deck and `flutter test` could
not see it. The cards were validated against a faithful port of
`CardValidator` run over `batch_1.json` + `batch_2.json` concatenated — zero
issues, including the deck-level duplicate-id and filler-card checks — plus
two rules the Dart validator does not yet enforce: cast.md hard rule 2
(silence flags on every speaker) and *every `requires.flags` entry is set by
some card in the deck*.

### Known layout constraint — batch 2

Measured across all 100 cards: no card overflows its text region at any phone
size. But on screens 667pt tall and shorter, the portrait square gives up
height on essentially every card — worst case `b1_076` on a 320x568 screen,
where the portrait renders at 118px against an intended 262px. Nothing is
clipped; `_Frame` puts the portrait in an `Expanded` that absorbs the
shortfall. Card length is not the cause and is already inside brief (median
187 characters, longest 223), so **do not shorten cards to chase this** — it
is a layout question, unresolved by choice.

---

## Batch 3 — `assets/cards/batch_3.json`, ids `b3_001`–`b3_100`

**Composition.** 55 flag-free standalone (`b3_001`–`b3_055`) · 20 flag-gated
standalone (`b3_056`–`b3_075`) · 20 chained (`b3_076`–`b3_095`) ·
5 suppression variants (`b3_096`–`b3_100`).

Ids laid out by category as in batches 1 and 2.

**One deliberate arithmetic change.** The brief's chained budget is twenty
cards laid out as five two-card chains, two three-card chains and one
four-card. Batch 3 replaces the four-card with a six-card slow burn, which does
not fit in twenty. Rather than write 102 cards, the batch drops one two-card
chain: **four two-card + two three-card + one six-card = 20.** Batches 6 and 9
inherit the same problem and should resolve it the same way.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 6 | **The two doors** — `b3_076`→`b3_081` | The reserved `sally_faction` slow burn. Adler notices the Canarsie envelope now comes to him from Sally's kitchen, correct to the dollar — nobody is stealing, somebody is teaching men a road. Sally asks for Canarsie out loud, in front of the table, and can be given it or have it taken out of his hands there. Aurelio names it: two doors, and a house with two doors is not a house. Concetta has been asked by Salvatore to say one sentence on Sunday and will say something either way. The crews physically separate — Ridgewood at the Knickerbocker, Canarsie at a place on Rockaway with a back room. Then the last table: Florida on Thursday (`sally_retired`, 15 blood) or `sally_moved` + `house_split`. |
| 3 | **The winter policy** — `b3_082`→`b3_084` | Adler lays out the arithmetic on Pinto's and proposes nothing, because he never proposes anything: carried at a loss two years, insured for eleven thousand over its worth, pre-war wiring. Rosa asks whether she should be frightened of the man who came to look at that wiring. A soldier reports that the man who does that kind of work leaves for Providence on Thursday. Ends in `rosa_place_burned` or a nine-thousand-dollar no. |
| 3 | **The window** — `b3_085`→`b3_087` | Four shots through the front of the house at three in the morning, into the room where nobody sleeps; Anna asked whether it was thunder. Aurelio: answer it and we are at war by Sunday, leave it and every man learns what can be done to us. Then Giulia has packed the children's things. First setters for `giulia_home_touched` and `giulia_left`. |
| 2 | **The third envelope** — `b3_088`→`b3_089` | Two envelopes go out now, and the twenty-nine-year-old sergeant has started telling Kiernan what he ought to do. Then the transfer to the Seven-Two: let him go (`kiernan_gone`) or spend fifteen keeping him somewhere everybody will wonder about. |
| 2 | **After Ettore** — `b3_090`→`b3_091` | Braca is eleven days in Doctors Hospital and his people are saying pneumonia. Then the man himself, asking for one sentence about his grandson's name. **Both sides set `braca_dead`.** |
| 2 | **Nineteen men** — `b3_092`→`b3_093` | Duke's people still drink in our club telling our people what a man earns over there, and two of ours have asked Sally whether they can go. Then Duke, from outside, offering to buy the airport freight outright. |
| 2 | **Steady hands** — `b3_094`→`b3_095` | Two men come to Nardi's office with a photograph of a shoulder he knows better than the face. Then the blind is down four days and the car is gone: send him out of Brooklyn (`nardi_gone`) or leave him (`nardi_talked`). |

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b3_096` a voice at the Eight-Three that doesn't know anybody | `b3_088` and every Kiernan card | `kiernan_gone` |
| `b3_097` Giulia from her sister's kitchen in Ozone Park | `b3_085` and the house-set Giulia cards | `giulia_left` |
| `b3_098` the hole in Grove Street, and who else is asking about insurance | `b3_082` and the restaurant-set Rosa cards | `rosa_place_burned` |
| `b3_099` Aurelio asking which of the two rooms to be honest in | `b3_076` and the ordinary Sally cards | `house_split` |
| `b3_100` Sally on the fifty-one-year-old in Braca's chair | `b3_090` and every Braca card | `braca_dead` |

### Flags

**Thirteen new**, all chain flags, all in flag-registry.md: `sally_count`,
`sally_asked_open`, `sally_two_doors`, `sally_house_edge`, `sally_last_table`,
`pinto_policy`, `pinto_winter`, `house_window`, `window_answered`,
`kiernan_third`, `braca_last`, `bushwick_after`, `nardi_asked`.

**No new world or character flags.** Batch 3 gives first setters to eleven
flags that had none anywhere in the deck: `sally_moved`, `sally_retired`,
`house_split`, `concetta_sided_sally`, `giulia_home_touched`, `giulia_left`,
`kiernan_gone`, `braca_dead`, `rosa_place_burned`, `nardi_talked` and
`nardi_gone` — plus `docks_taken`, which had sat in the registry since batch 1
with nothing in the deck reaching it.

**Reads that earlier batches set** (23): `adler_ran`, `aurelio_doubted`,
`aurelio_wrong_proven`, `books_open`, `braca_after`, `braca_owes_you`,
`colla_refused_you`, `colla_roof_paid`, `concetta_silent`, `dope_sanctioned`,
`duke_broke_off`, `fallon_replaced`, `fallon_squeezed`, `feds_active`,
`giulia_house`, `kiernan_price_up_2`, `matty_killed_wrong`, `matty_pinched`,
`nardi_debt_cleared`, `nardi_used`, `ranieri_watching`, `sally_humiliated`,
`wills_dope`. *(`kiernan_price_up_2` was missing from this list in batch 6's
audit — the count of 23 was right and the list had 22.)*

**Both add and remove cards this batch:** `house_split`, `sally_moved`,
`giulia_left`, `kiernan_gone`, `braca_dead`, `rosa_place_burned`,
`giulia_home_touched`, `docks_taken`, `fallon_replaced`, `matty_pinched`,
`duke_broke_off`, `angelo_flipped`, `kiernan_cold`, `rosa_place_taken`,
`adler_ran`, `nardi_gone`. Thirty-one distinct flags appear in an
`excludesFlags` somewhere in this batch against twenty-five set — the first
batch where suppression outweighs setting, which is what the *situational
silence* rule below is for.

### Convention added in batch 3

**Situational silence**, defined in [flag-registry.md](flag-registry.md). It
settles the deck-wide question batch 2 left open about `matty_pinched` without
promoting anything to a silence flag: a flag can contradict a *kind* of card
without removing a character from the deck. Street-set and club-set Matty cards
exclude `matty_pinched`; house-set Giulia cards exclude `giulia_left`; ordinary
Sally business excludes `sally_moved` and `house_split`; restaurant-set Rosa
cards exclude `rosa_place_taken` and `rosa_place_burned`. These still count as
flag-free — `requires.flags` is empty, and the addition suppresses a
contradiction rather than gating content.

### Cast coverage

Speakers per 100, against the per-batch budget doubled: `AURELIO` 13,
`UNCLE SALLY` 11, `GIULIA` 10, `MATTY` 9, `DUKE` 7, `ADLER` 6,
`CAPT. KIERNAN` 6, `DET. RANIERI` 5, `CONCETTA` 4, `ANGELO` 4, `FALLON` 4,
`DON BRACA` 4, `MOE WILLS` 3, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 2,
reserve 6. Identical to batches 1 and 2, so the running total across 300 cards
sits on the pro-rata budget rather than drifting.

**Walk-ons remain subjects, not speakers** — cast.md hard rule 3 and the
batch-1 convention. The shopkeeper, the stranger and the unfamiliar cop appear
inside reserve-voice and cast cards (`b3_055` the barber on Gates, `b3_096` the
voice at the Eight-Three, `b3_051` the health inspector, `b3_001` the daughter
in Syosset), never at the top of one.

### Blood

18 of 100 cards, in line with batches 1 and 2. Heaviest are `b3_087` (16, the
children going to Ozone Park), `b3_081` (15, the uncle sent to Florida) and
`b3_079` (13, asking your mother to spend her voice on you). No Rosa card costs
blood.

### Balance

Batch 3 was drafted from a stale copy of [content-prompt.md](content-prompt.md)
that predated the **No directional bias** section, so it was written without
the check and then failed it four ways: family +65, cops +145, cash −136, and
only 53.9% of deltas in the 5–12 band. Corrected in one re-pointing pass, no
text touched:

| | before | after |
|---|---:|---:|
| family net | +65 | −12 |
| commission net | +7 | +12 |
| cops net | +145 | +12 |
| cash net | −136 | +12 |
| 5–12 band | 53.9% | 78.1% |
| 1–4 band | 45.6% | 19.2% |
| 15–25 band | 0.3% | 2.7% |

Three things caused it, all worth avoiding from the first card of a batch:

1. **Small-delta garnish.** Nearly half the deltas were 3s and 4s, which is
   what pushes the ordinary band under its floor. A meter either moves or it
   does not.
2. **The cost template.** Almost every "do the thing" side raised cops and
   almost every one lowered cash, so those two meters could only travel one
   way.
3. **Nine cards moved one meter the same direction on both sides** — a card
   that raises heat whichever way you swipe is not a decision about heat.
   Fixed by making restraint cost family where the crew wanted something done
   (`b3_001`, `b3_020`, `b3_044`) and neutral where it has no stake
   (`b3_010`, `b3_051`, `b3_065`, `b3_071`).

`b3_046` was also re-pointed for a design reason rather than an arithmetic one:
taking Fallon's local gave family, commission and cash against a single cost,
which is the shape of an obviously-strong side. Seizing an ILA local is exactly
what Braca wants not to happen, so it now reads **commission −7** and the
quiet side gains standing instead.

**Batch 2 still fails this check** — cops +114, cash −208 — for the same reason.
*(It got the same pass during batch 4.)*

### Threads left open by batch 3

- **`house_split` is now reachable and has one reader** (`b3_099`). A family
  visibly in two halves is the largest unexplored state in the deck. Batch 4
  should give it three or four readers before it gives it a chain — it wants
  texture more than another arc.
- **`sally_retired` has one setter and no reader at all.** A man sent to Florida
  still calls, per cast.md, and nothing has called yet. The cheapest
  high-value pickup available to batch 4.
- **`concetta_sided_sally`** — set once, read nowhere.
- **`docks_taken`** — set at `b3_046`, read once at `b3_067`. A seized ILA local
  is a large and mostly unwritten object: nine hundred members, a welfare fund,
  federal filings, and a hall.
- **`nardi_talked`** — set, unread. A doctor who has talked is a much sharper
  object than one who might.
- **`braca_dead`** — the Commission now has a new man in the chair, fifty-one
  years old. He is deliberately unnamed and is **not** a seventeenth cast
  member; batch 4 should keep him off the top of a card.
- `giulia_left` has one reader (`b3_097`) and wants two or three more.
- Still with no setter anywhere: `wills_war`, `aurelio_failing`,
  `ranieri_family_touched`, `adler_skimming`, and every remaining `*_dead` flag
  other than `braca_dead`. Batch 3 deliberately did not kill a cast member the
  player is fond of. Batches 4 and 5 have room for exactly that.
- `aurelio_failing` was **not** set here on purpose. `b3_072` is Sally arguing
  that the consigliere is too old, and it sets `aurelio_doubted` instead,
  because Sally saying a man is finished is not the same as the man being
  finished. Whoever sets `aurelio_failing` should earn it.

### Wiring — outstanding

Batch 3 was written under the same no-Dart constraint as batch 2, so the pending
edits stacked. **Both were done during batch 4** — see that entry's
*Wiring — CLEARED*. As recorded at the time:

1. Batch 2's twelve chain flags **and** batch 3's thirteen into
   `GameFlags.chainFlags` ([flags.dart](../lib/flags.dart)) — both snippets are
   in [flag-registry.md](flag-registry.md) under *Pending changes*.
2. `assets/cards/batch_2.json` and `assets/cards/batch_3.json` into
   `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

Until both land, neither file is in the running deck. `flutter test` passes
104/104 against the deck as currently wired, unchanged by this batch. The cards
were validated against a faithful port of `CardValidator` run over all three
batch files concatenated — 300 cards, zero issues, including the deck-level
duplicate-id and filler-card checks — plus three rules the Dart validator does
not enforce: cast.md hard rule 2, *every `requires.flags` entry is set by some
card in the deck*, and *every speaker is one of the sixteen cast names or the
five reserve voices*.

### Known layout constraint — batch 3 (continued below by batch 4)

Batch 3 was drafted long — median 213 characters, longest 236 — and then
tightened in one pass to **median 196, longest 211**, inside the envelope
batches 1 and 2 were measured against. The batch-2 note stands: do not shorten
cards to chase the short-screen portrait problem. This trim was for a different
reason, which is that a card is two or three short lines of speech and a
236-character card is four.

---

## Batch 4 — `assets/cards/batch_4.json`, ids `b4_001`–`b4_100`

**Composition.** 55 flag-free standalone (`b4_001`–`b4_055`) · 20 flag-gated
standalone (`b4_056`–`b4_075`) · 20 chained (`b4_076`–`b4_095`) ·
5 suppression variants (`b4_096`–`b4_100`).

Ids laid out by category as in batches 1–3. Batch 4 is not a slow-burn batch, so
the chained twenty is the standard shape: **five two-card + two three-card + one
four-card.**

**The batch's job.** Batch 3 wrote that batches 4 and 5 had room to kill a cast
member the player is fond of, and that whoever set `aurelio_failing` should earn
it. Batch 4 does both, in the same chain, and spends four of the five remaining
never-set flags that were not `*_dead`.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **Two pages** — `b4_076`→`b4_079` | The consigliere finds the same question written twice in his own book, three weeks apart, in his own hand, with two different answers, and brings it to the player before a room can find it. Sally reports the ruling that sent the family to a man six years dead — and reports that two capos looked at *him*. Aurelio asks to be finished by the player at this table rather than by a room that has stopped listening; **both sides set `aurelio_failing`.** Then Wyckoff Heights, the priest twice, and one last chance to be of use: **both sides set `aurelio_dead`.** |
| 3 | **The Bed-Stuy line** — `b4_080`→`b4_082` | Two collectors come back without the bags, unhurt, and told to say why. Moe Wills didn't give the order and won't punish the man who did, because he is twenty-six and said out loud what the rest of them think. Then a man of ours with his jaw wired and a man of theirs who won't walk: `wills_war` + `at_war`, or a table and the end of the tax. |
| 3 | **Central Avenue** — `b4_083`→`b4_085` | Duke has had a bakery on his list since before either of them and has only just found out whose father sits in the back of it. Ranieri asks once, in the street, like a neighbour. Then the window goes out on a Sunday night, the old man sweeps the glass up himself before the shops open, and he telephones nobody. First setter for `ranieri_family_touched`. |
| 2 | **The spring election** — `b4_086`→`b4_087` | Nine hundred members, a welfare fund, and a Department of Labor observer who stays four days. Then four paragraphs on page nine that somebody at the Eastern District has cut out and kept. |
| 2 | **Eighty-one degrees** — `b4_088`→`b4_089` | The retired uncle telephones from Florida with a man from Cleveland beside him and a question he'd like to answer. Then Aurelio counting: four calls this month, three men told him, one did not. |
| 2 | **Eighteen months** — `b4_090`→`b4_091` | The nephew's lawyer telephones the consigliere before he telephones the nephew. Eighteen months instead of nine years, with a condition on it. Then the boy on a jail telephone, admitting he said he'd think about it because he wanted to hear the rest. |
| 2 | **Sunday's sentence** — `b4_092`→`b4_093` | Giulia has been asked twice, kindly, whether the family is all right, and has answered without knowing what the answer was. Then Concetta, who said what she said because his father would have. |
| 2 | **Four hundred a month** — `b4_094`→`b4_095` | Duke's counted figure and the figure that reaches Flushing Avenue differ by four hundred dollars, three months running. Then the bookkeeper, a daughter at Barnard, and a loan to himself entered on the page in his own hand. **Both sides set `adler_skimming`.** |

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b4_096` Concetta: nobody left who tells you no | `b4_076` and every Aurelio card | `aurelio_dead` |
| `b4_097` the street, on a line where nobody writes numbers | `b4_048`, `b4_071`, `b4_080` and the ordinary Wills cards | `wills_war` |
| `b4_098` Ranieri with a file and a date, still polite | `b4_036`, `b4_037`, `b4_067`, `b4_083` and every neighbourly Ranieri card | `ranieri_family_touched` |
| `b4_099` Giulia: the boy has asked to come back to Brooklyn | the house-set Giulia cards `b4_013`–`b4_018`, `b4_061`, `b4_062` | `giulia_left` |
| `b4_100` Kiernan on a four-page statement he has read and can't take | `b4_053`, `b4_054` and the ordinary Nardi cards | `nardi_talked` |

### Flags

**Twelve new**, all chain flags, all in flag-registry.md: `aurelio_two_pages`,
`aurelio_second_chair`, `aurelio_last_counsel`, `wills_bags`, `wills_answer`,
`ranieri_bakery`, `bakery_asked`, `hall_spring`, `sally_florida_call`,
`matty_offer`, `concetta_sunday_word`, `adler_short_page`.

**No new world or character flags.** Batch 4 gives first setters to five flags
that had none anywhere in the deck: `aurelio_failing`, `aurelio_dead`,
`wills_war`, `ranieri_family_touched` and `adler_skimming`.

**Reads that earlier batches set** (21): `angelo_paid`, `at_war`,
`braca_sponsor`, `concetta_sided_sally`, `docks_taken`, `dope_banned`,
`duke_proven_loyal`, `duke_warned`, `fallon_pension_touched`, `giulia_left`,
`giulia_lied_to`, `house_split`, `kiernan_price_up`, `matty_made`,
`matty_pinched`, `nardi_gone`, `nardi_talked`, `ranieri_watching`,
`rosa_forgiven`, `sally_backed`, `sally_retired`.

**Overhang: 21 pre-existing flags read against 12 new flags created.** Eight of
the twenty-one had never been read by any card in the deck before this batch —
`sally_backed` (22 setters, 0 readers), `duke_warned` (6), `braca_sponsor` (4),
`duke_proven_loyal`, `concetta_sided_sally`, `sally_retired`, `nardi_gone`,
`nardi_talked`. *(Said six, listed eight; corrected in batch 6's audit.)*

**Both add and remove cards this batch:** `aurelio_dead`, `aurelio_failing`,
`wills_war`, `ranieri_family_touched`, `nardi_talked`, `nardi_gone`,
`giulia_left`, `house_split`, `matty_pinched`, `matty_disowned`,
`sally_moved`, `sally_retired`, `duke_broke_off`, `adler_ran`,
`angelo_flipped`, `kiernan_cold`, `kiernan_gone`, `rosa_place_taken`,
`rosa_place_burned`, `fallon_replaced`, `braca_dead`, `docks_taken`.
Thirty-one distinct flags appear in an `excludesFlags` somewhere in this batch.

### Cast coverage

Speakers per 100, on the per-batch budget doubled and identical to batches 1–3:
`AURELIO` 13, `UNCLE SALLY` 11, `GIULIA` 10, `MATTY` 9, `DUKE` 7, `ADLER` 6,
`CAPT. KIERNAN` 6, `DET. RANIERI` 5, `CONCETTA` 4, `ANGELO` 4, `FALLON` 4,
`DON BRACA` 4, `MOE WILLS` 3, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 2,
reserve 6. The running total across 400 cards sits on the pro-rata budget.

**Walk-ons remain subjects, not speakers.** The jury-panel debtor, the bank
manager on Myrtle, the Staten Island lieutenant, the eleven-year-old with the
coats and the old man sweeping his own glass all appear inside cast and reserve
cards, never at the top of one. The fifty-one-year-old in Braca's chair is
mentioned only through `braca_dead`-gated cards and is still not a cast member.

### Blood

18 of 100 cards, in line with batches 1–3. Heaviest are `b4_099` (14, the son
asking to come back to Brooklyn), `b4_015` and `b4_091` (12, the boy's clipping
and the boy in the Tombs), `b4_065` and `b4_093` (11).

### Balance

Written against the **No directional bias** section from the first card this
time, then corrected in two re-pointing passes, numbers only, no text touched:

| | first draft | shipped |
|---|---:|---:|
| family net | +20 | +7 |
| commission net | +41 | +10 |
| cops net | +47 | +23 |
| cash net | −105 | +14 |
| 5–12 band | 88.9% | 81.9% |
| 1–4 band | 10.7% | 14.5% |
| 15–25 band | 0.3% | 3.5% |
| inert sides | 0 | 0 |

The cash failure had one cause, and it is habit 1 in the brief: **opportunity
cost written as an outlay.** Fourteen cards charged the player cash for money
they were declining to take — forgiving a debt never collected, not taxing a
bakery, not going back for the bags. Those are 0 cash and a cost in family or
commission. Two sides also pushed a meter the same way on both branches
(`b4_070` family, `b4_082` cash) and were re-pointed.

### Threads left open by batch 4

- **`aurelio_dead` has one reader** (`b4_096`) and is excluded on fourteen cards.
  A family running without a consigliere is the largest new state in the deck
  and batch 5 should give it three or four readers before it gives it a chain —
  who sits in that chair, and who the player asks at two in the morning.
- **`aurelio_failing` has one reader** (`b4_074`). A living consigliere whose
  counsel is slower and no less certain is the *more* interesting of the two
  branches and is currently the thinner one.
- **`adler_skimming` is set and unread.** A bookkeeper the family has caught,
  either forgiven or made to repay, is a much sharper object than one who might.
- **`wills_war` has one reader** (`b4_097`), and `at_war` now has a second
  setter that is specifically north of the parkway rather than another family.
- **`ranieri_family_touched` has one reader** (`b4_098`). Per cast.md it is
  catastrophic and irreversible; it should cost more than one card.
- `sally_florida_call` can hand `sally_faction` to a retired man. If a later
  batch wants Sally back in Brooklyn, that is the door, and it should not be
  re-seeded with a fresh "the uncle is restless" card.
- Still with no setter anywhere: `ranieri_dead`, `matty_dead`, `sally_dead`,
  `duke_dead`, `concetta_dead`, `fallon_dead`, `wills_dead`, `adler_dead`,
  `rosa_gone`, `colla_gone`. Batch 4 killed the consigliere; batch 5 has room
  for one more, and `ranieri_dead` is explicitly close to run-ending per
  flag-registry.md, so it wants a chain and not a card.
- `braca_owes_you`, `braca_owed_him` and `commission_snubbed` remain thin.

### Wiring — CLEARED

Batch 4 was drafted under the same no-Dart constraint as batches 2 and 3, which
had stacked the debt three deep. It was cleared immediately afterwards, in the
same session, and **the batch is not finished until this is done — there is no
such thing as a green validator against a deck the cards are not in.**

1. **Done.** Batch 2's twelve chain flags, batch 3's thirteen and batch 4's
   twelve are in `GameFlags.chainFlags` ([flags.dart](../lib/flags.dart)),
   each under its own `// batch N` comment.
2. **Done.** `batch_2.json`, `batch_3.json` and `batch_4.json` are in
   `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

**What that exposed, and why it is the important part of this entry.** For three
batches the suite was green while 300 of 400 cards were outside the deck it
checked, and the extra rules were enforced only by a throwaway script that died
with the conversation that wrote it. Both halves of that are now fixed in
[card_deck_test.dart](../test/card_deck_test.dart), in a new
`shipped batch deck` group that is five tests and no ceremony:

- every path in `deckPaths` exists on disk;
- the **concatenated** deck validates and its ids are unique across batches —
  the check a per-file loop waves through;
- every `requires.flags` entry is set by some card in the deck;
- every speaker is one of the sixteen or one of the five reserve voices;
- **cast.md hard rule 2** — nobody speaks after they are silenced.

The last three were the port's rules. They are permanent now, so batch 5 does
not re-derive them, and a batch file that is written but not wired fails the
build instead of passing it.

`flutter test`: **112/112**, over the real 400 cards.

### Batch 2's balance, corrected

Also cleared in the same pass, because adding `batch_2.json` to `deckPaths`
turned its known defect into a failing build — which is exactly what should
have happened three batches ago.

| | before | after |
|---|---:|---:|
| family net | +50 | +8 |
| commission net | −5 | −1 |
| cops net | +111 | −1 |
| cash net | −211 | −2 |
| 5–12 band | 62.7% | 78.7% |
| 1–4 band | 35.2% | 20.3% |
| 15–25 band | 0.8% | 1.0% |

Numbers only: no text, label, flag, weight, blood value **or sign** changed, and
the script asserted all of that before writing. Three rules, all of them the
ones batch 3's own correction used — garnish below 5 promoted to 5 unless the
whole card is small-scale, one scale factor per meter per direction to bring
each net to zero, and *heavy stays heavy* so the batch keeps its five 15+
swings. 279 of 600 deltas moved. Spot-checked against the fiction afterwards:
buying the house on Long Island is still the batch's heaviest single cost.

**Residual, not fixed:** batch 2 has 13 places where both sides of a card push
the same meter the same way — a card that is not a decision about that meter.
`DeckBalance` does not test for it, the re-pointing pass preserves signs so it
could not fix it, and fixing it means re-authoring intent rather than
arithmetic. Batch 5 should not inherit the habit; batch 4 has two, both caught
and corrected before shipping.

### What playing it actually showed

1,000 simulated runs per policy against the real 400-card deck, plus the built
web app driven by hand. Recorded because none of it is visible in the batch
files, and because the numbers move as batches 5–9 land.

- **All eight endings are reachable and none dominates.** Under random play:
  `BENEATH NOTICE` 232, `THE PAPERWORK` 204, `THE STATUE` 163, `BAD PAYDAY` 125,
  `THE INDICTMENT` 117, `THE VOTE` 94, `SANCTIONED` 35, `THE ERRAND BOY` 30.
  This is the payoff for the balance work: batch 1 shipped with four of them
  statistically unreachable.
- **Run length is short of target.** Random play dies at a median of 34 swipes
  against a 40–60 brief. Random is a floor rather than the target, so this is
  about right — but it is the number to watch as the deck grows.
- **A player who always takes the safer side never dies.** A greedy
  steer-for-the-middle policy survived 979 runs in 1,000 to a 500-swipe cap.
  The deck currently contains no *forcing* pressure — nothing that makes both
  sides genuinely bad — so perfect play is immortal and simply drains blood to
  zero. That is a deck-wide design gap, not a batch-4 defect, and it is the
  most interesting thing the playtest found.
- **24 cards were never drawn in 1,000 random runs.** Almost all of them are
  chain tails and cards gated on flags that only another chain's tail can set:
  `b4_088`–`b4_093` (Florida, the Tombs offer, Sunday's sentence) sit behind
  `sally_retired`, `matty_pinched` and `concetta_sided_sally`, each of which is
  itself the end of a batch-2 or batch-3 chain. **Lesson for batch 5: gate on
  first-order flags.** A card behind a flag behind a chain is a card nobody
  sees.
- The app boots on the 400-card deck, renders, and swipes advance it — checked
  in a real browser, not a widget test. Zero console errors. Desktop Windows
  cannot be built on this machine (`flutter run -d windows` needs Developer
  Mode for symlink support), so the web target is the one to use for this.

### Known layout constraint — batch 4

Median text length 200 characters, longest 220, inside the envelope batches 1–3
were measured against. The batch-2 note stands: the short-screen portrait
problem is a layout question, and cards are not to be shortened to chase it.

---

## Batch 5 — `assets/cards/batch_5.json`, ids `b5_001`–`b5_100`

**Composition.** 52 flag-free standalone · **3 flag-free vices** · 15 flag-gated
standalone · **5 gated vices** · 20 chained · 5 suppression variants.

The vices come **out of** the other budgets rather than on top of them, which is
why the flag-free count drops 55 → 52 and the flag-aware 20 → 15.

### The vice, first outing

Eight cards declaring `"vice": true`. A vice is a card where no meter moves in
opposite directions on the two sides and at least one is pushed the same way by
both by 8 or more: the player picks which damage to take and never whether. The
full rule is in [content-prompt.md](content-prompt.md); the validator and
`DeckBalance` enforce both halves.

| Card | Shared, unavoidable | The choice |
|---|---|---|
| `b5_053` a body in a basement of ours since Friday | cops +8/+8 | move him and pay for it, or leave him and pay in standing |
| `b5_054` Sabella arrested; no version costs nothing | cash −9/−8 | a lawyer now, or an envelope to his wife for four years |
| `b5_055` a year's tribute paid up front, already in the house | cash +15/+12 | through the books and visible, or in a wall and resented |
| `b5_071` `at_war` — four men on cots, wives telephoning | family −8/−8 | lose the men who stayed, or the men who want to go home |
| `b5_072` `dope_sanctioned` — two families want a taste | commission −9/−8 | pay Braca's people, or pay the Provenzanos |
| `b5_073` `matty_killed_wrong` — the dead boy's brother has found out | family +9/+8 | buy him off, or let him talk to a newspaper |
| `b5_074` `ranieri_watching` — the folder is in a drawer until August | cops −12/−11 | pay whatever the key costs, or hand over a man |
| `b5_075` `adler_subpoenaed` — they will find the vending returns | cash −9/−8 | correct them in your own hand, or be a liar |

Five sit behind depth-1 consequence flags the player set themselves, so they
arrive late in a run and read as a bill rather than a mugging.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **Sunday, after the ten o'clock** — `b5_076`→`b5_079` | Gated on `ranieri_watching`. A made man says out loud at our own table what ought to be done about a detective who cannot be bought. Ranieri turns down Bay Ridge and says so himself. Sally puts the Commission's one unbent rule to the house. Then a soldier, with the detective's Sunday walk to his father's bakery, asking once and never again. First setter for `ranieri_dead` — 20 cops and −18 commission, the heaviest single side in five batches. |
| 3 | **A turn on the pier** — `b5_080`→`b5_082` | Fallon's heart, told to nobody else. What happens to nine hundred votes and a welfare fund if he goes. Then four paragraphs and a widow asking whether you will carry him. **Both sides set `fallon_dead`.** |
| 3 | **The state sells numbers** — `b5_083`→`b5_085` | A bill in Albany for a legal numbers game with a printed ticket and a tax on it. Moe Wills' people ask why they pay a street tax on a thing sold over a counter with a receipt. Then Sally, on a family that could be a charity by Christmas. |
| 2 | **The valuation** — `b5_086`→`b5_087` | A haulage outfit wants the trucking company outright; either way somebody in Maspeth now holds a written valuation with routes and tonnages on it, and showed it to a bank. |
| 2 | **The ten o'clock mass** — `b5_088`→`b5_089` | A made man's funeral at the mass where the school children sing. Men from three families come to the uncle afterwards rather than to the player. |
| 2 | **A young man with a notebook** — `b5_090`→`b5_091` | He works the avenue for a week, then knocks on the player's own door and asks Giulia what her husband does for a living. |
| 2 | **The terminal** — `b5_092`→`b5_093` | A new air freight contract, on the line between what is the player's and what has been Braca's since before his father. |
| 2 | **How a man starts** — `b5_094`→`b5_095` | Dinello's boy asks Angelo the question; nine days later Matty watches him stand outside the club in the rain in the same jacket, and remembers doing it himself. |

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b5_096` Kiernan, useless now, every cop in the city with a photograph on the wall | every Ranieri card, and Kiernan's ordinary favours | `ranieri_dead` |
| `b5_097` the pier under a president who never worked a hook | every Fallon card | `fallon_dead` |
| `b5_098` Matty asked what he would *like* to be carrying | the ordinary Matty errand cards | `dope_sanctioned` |
| `b5_099` Angelo naming where he will be on Thursday, and not asking | his ordinary asking cards | `angelo_suspected` |
| `b5_100` the empty chair at the end of the table | `b5_076` and the consigliere's ordinary business | `aurelio_dead` |

### Flags

**Twelve new**, all chain flags. First setters for `ranieri_dead` and
`fallon_dead`. **Nineteen pre-existing flags read against twelve created.**

### Gating depth

**6 of 25** gated standalones and variants sit at flag-depth ≥ 2, against batch
4's 24 of 41. All six are deliberate: four are the post-Aurelio cards, which
exist to cover a state rather than to be seen often, and two are variants gated
on this batch's own deaths, which cannot be shallower than the death is.
Everything else is depth 1.

### Cast coverage

`AURELIO` 13, `UNCLE SALLY` 11, `GIULIA` 10, `MATTY` 9, `DUKE` 7, `ADLER` 6,
`CAPT. KIERNAN` 6, `DET. RANIERI` 5, `ANGELO` 4, `FALLON` 4, `DON BRACA` 4,
`CONCETTA` 3, `MOE WILLS` 3, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 2,
reserve 7. Concetta is one under and reserve one over, both inside the ±40%
tolerance.

**Blood: 9 of 100, which is low** — batches 1–4 ran 18–19. Diagnosed rather
than guessed at: the vices did **not** crowd it out. Flag-free blood held at
7/52 against the usual 9/55, and the entire shortfall is in the chains, where
batches 1–4 carried 3–5 blood cards and batch 5 carried **none** — all eight of
its arcs are business, and Giulia, who carries 37 of the 74 blood cards in
batches 1–4, is barely in them. The fix is in the master prompt: budget blood at
the chain level, when the chains are chosen.

### Balance

Failed on first assembly and was corrected in one pass, numbers only:

| | first draft | shipped |
|---|---:|---:|
| family net | −25 | 0 |
| commission net | −13 | 0 |
| cops net | +117 | +1 |
| cash net | −292 | −1 |
| vice net, worst meter | −69 | −29 |

Two separate faults. The ordinary cards drifted the way batch 2's did — 43
cash-raising sides against 85 lowering ones — and took the same separable scale.
**The vices leaned much harder**, and that is worth recording because it will
recur: a vice is made of costs, so eight of them pile onto whichever meters the
author reached for. The fix is not scaling but *assignment* — which second meter
each side pays in — and it needed a search over the combinations to land inside
±30 while keeping every vice's two sides paying in different places.

### The second pass: vices raised into the heavy band

Approved after the first acceptance test and applied to all eight, numbers only
— the fiction on those cards was written for an unavoidable cost and still is.
Shared pushes went from 8–12 to **15–20**, and the shape changed with them:
each vice is now **asymmetric**, one side taking the bigger share of the
unavoidable push and nothing else, the other taking less of it and paying
somewhere else. Which side a player wants depends on which meter is nearest to
killing them. Four have the bare side on the left and four on the right, so
there is no "always swipe left".

Result, against the identical simulation:

| | 8–12 shared | 15–20 shared |
|---|---:|---:|
| greedy oracle survives to the cap | 973 / 1000 | **942 / 1000** |
| greedy median length when it *does* die | 217 | **328** |
| random floor, median run | 33 | **31** |
| vices met per greedy run | 7.16 | 7.07 |

Exactly what the sweep predicted for a doubling of magnitude, and the floor
barely moved — 31 against the 25 mark below which ordinary swings were to come
down. **So no ordinary-swing pass is needed yet**, which is the outcome that
saves a 500-card edit.

### The third pass: draw weight

The last lever, and the one the arithmetic pointed at. Eight vices at 10 and 26
were met about seven times in a five-hundred-swipe run — once every seventy
swipes, which is not part of a forty-swipe game. Raised to **44–48**, weights
only:

| | 8–12, weight 10/26 | 15–20, weight 10/26 | 15–20, **weight 44–48** |
|---|---:|---:|---:|
| **greedy oracle survives to cap** | 973 / 1000 | 942 / 1000 | **848 / 1000** |
| **random floor, median run** | 33 | 31 | **30** |
| greedy p10 run length | 500 | 500 | **349** |
| vices met, random run | 0.47 | 0.47 | **1.51** |
| vices met, greedy run | 7.16 | 7.07 | **20.15** |

The floor moved one swipe. An average random run now meets one or two
unavoidable costs instead of half of one, and a fifth of greedy runs no longer
reach the cap at all.

### Tuning against the simulation stops here

Recorded as a decision, not a pause. The greedy oracle has given up everything
it can. It found the structural defects — no forcing pressure, directional bias,
four endings that could not be reached — and those are fixed and enforced by
tests. What is left is 848/1000, and that number exists because the oracle
recomputes the optimal side on every card and no human being does.

Chasing it further tunes the game against a player who does not exist, and the
cost of that lands on the player who does. **The remaining difficulty question
is not answerable by simulation.** It needs somebody playing the web build who
cannot see the numbers, and that is scheduled around batch 7. Until then: no
sweeps, no re-tuned magnitudes, no larger vice quota.

Worth saying plainly: the greedy oracle recomputes the optimal side on every
card and no human plays like that. It is the right stress test precisely because
it cannot be beaten by content, only by structure — but "the oracle survives" is
not the same as "the game is easy".

### What the first acceptance test said — the honest answer

The point of the vice was to make skilled play mortal. **It has not worked yet.**

| | batch 4 (400 cards) | batch 5, vices at 8–12 |
|---|---:|---:|
| greedy oracle survives to the 500-swipe cap | 979 / 1000 | 973 / 1000 |
| random floor, median run | 34 | 33 |

Eight vices in five hundred cards is 1.6% of the deck, and a greedy run meets
about seven of them across five hundred swipes. A sweep over vice strength and
draw weight, run in memory against the real deck, shows where the cliff is:

| shared magnitude | draw weight | greedy survives | median death |
|---|---|---:|---:|
| as shipped | as shipped | 294/300 | 130 |
| as shipped | ×8 | 282/300 | 404 |
| ×1.5 | ×8 | 232/300 | 231 |
| ×2 | ×8 | 118/300 | 239 |
| ×3 | ×4 | 23/300 | 115 |
| ×3 | ×8 | **0/300** | **63** |

The finding is not that there are too few vices. It is that **an eight-to-twelve
shared push is absorbed by two or three ordinary cards.** The oracle at ×8 draw
weight meets thirty-four vices in a run and still survives 94% of the time,
because every ordinary card between them hands the pull-back back. Strength
moves the needle far harder than frequency: at ×2 magnitude survival falls to
39%, at ×3 it goes to nothing.

So the guidance in *The vice* — "relentless, not explosive" — is the wrong
instinct, and the numbers say so. A vice wants to sit in the **heavy band, 15–20
on the shared meter**, not 8–12. That is a change to a standing rule and to
eight shipped cards, so it is the first thing to settle before batch 6.

The other half is the random floor: median 33 swipes against a 40–60 target.
Heavier vices push that figure *down*, so the two move against each other, and
the ordinary cards' swings probably want to come down as the vices' go up.

### Threads left open by batch 5

- ~~**The vice wants a second pass at magnitude**~~ — **done**: 15–20 shared,
  then draw weight 44–48. 973 → 942 → **848**. All three levers are spent and
  simulation tuning is closed; the next word on difficulty comes from a human
  playtest around batch 7.
- `ranieri_dead` has one reader (`b5_096`). Per flag-registry.md it should be
  close to run-ending, and one card is not that.
- `fallon_dead` has one reader. `fallon_indicted` and `fallon_squeezed` are thin.
- `adler_skimming` is **still set and unread** — batch 4 left it, batch 5 did not
  pick it up.
- `aurelio_failing` has one reader, and the post-Aurelio world now has four
  cards, which is the cap.
- Still with no setter anywhere: ~~`matty_dead`~~, `sally_dead`, `duke_dead`,
  `concetta_dead`, `wills_dead`, `adler_dead`, ~~`rosa_gone`~~, ~~`colla_gone`~~.
  *(Struck three were spent in batch 6.)*

---

## Batch 6 — `assets/cards/batch_6.json`, ids `b6_001`–`b6_100`

**Composition.** 52 flag-free standalone (`b6_001`–`b6_052`) · **3 flag-free
vices** (`b6_053`–`b6_055`) · 15 flag-gated standalone (`b6_056`–`b6_070`) ·
**5 gated vices** (`b6_071`–`b6_075`) · 20 chained (`b6_076`–`b6_095`) ·
5 suppression variants (`b6_096`–`b6_100`).

The shape batch 5 settled: the eight vices come **out of** the other budgets,
not on top, which is why flag-free is 52 and flag-aware 15. Eight and no more —
the quota is frozen until the human playtest around batch 7.

Batch 6 is a slow-burn batch, so the chained twenty is the layout batch 3
settled and told 6 and 9 not to re-derive: **four two-card + two three-card +
one six-card = 20.**

**The batch's job.** Batch 5 left `matty_dead`, `rosa_gone` and `colla_gone`
with no setter anywhere, and `adler_skimming` set and unread for a second batch
running. Batch 6 spends all four, and puts the slow burn on the one the deck has
been building toward since `b1_076`.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 6 | **Lucia's boy** — `b6_076`→`b6_081` | Three kids from Ridgewood stand outside the club saying *Matty Ricci's people* out loud to strangers, and one takes a beating off a doorman and gives no name. They bring money to the club in a paper bag, off a lot on Onderdonk that isn't anybody's, and everybody sees the bag. A Provenzano capo asks at a wake, very politely, who authorised them — using the nephew's name and then the player's, in that order, memorising it. Lucia sits in Giulia's kitchen and asks the question she will not ask the player, in the voice you use for the weather, because she has practised it. Concetta has been told what the other family wants, in her own kitchen, which is what they think of the player this week. Then the last card, which offers no third answer: `matty_dead` and 18 blood, or `at_war` and a house that keeps him. **He never does anything worse than want to be somebody**, and that is why the burn sits here rather than on another killing. |
| 3 | **Three chairs** — `b6_082`→`b6_084` | Duke has carried three names for four years and would like to say them out loud. The list is not a list yet and nine men already know they are not on it; Bobby Zito has stopped coming in. Then Sunday, and the uncle has a list in his pocket that the player does not have to take. Sets `books_open` either way — `sally_backed`, or `sally_humiliated` + `angelo_paid`. |
| 3 | **The laundry contract** — `b6_085`→`b6_087` | Two hospitals in Queens, real money, on paper, and an auditor who visits twice a year and looks at everything. Duke asks where the Friday money is counted if the company stops being the room it is counted in. Then Aurelio, who has come round to thinking it is both the safest thing the family owns and the first place they will look. Ends in `adler_legit_front` + `feds_active`, or a front and nothing more. |
| 2 | **Bay Shore** — `b6_088`→`b6_089` | Rosa's sister has a room over a diner that wants a cook, and Rosa is not asking to be let off anything — she is asking whether a person is allowed to go. **Both sides of `b6_089` set `rosa_gone`**: she goes either way, and the choice is the debt and whether anything is sent after her. |
| 2 | **The letter** — `b6_090`→`b6_091` | The diocese asks, after nineteen years, whether Father Colla is content in this parish. Then Rockville Centre in September: a bigger church, a newer boiler, and not one name he will know. |
| 2 | **What you do all day** — `b6_092`→`b6_093` | Paolo asks his mother what his father does — not what he is, what he does — and waits with his hands in his lap. Then he tells his teacher his father is in linen, in front of the class, and he has practised it. |
| 2 | **Uptown** — `b6_094`→`b6_095` | Moe Wills has an offer the Commission has a rule about, does not need permission, and is telling the player first so it does not arrive by Thursday from somebody else. Then Sally, holding the answer he will have to give when they ask him. |

### The vices

Eight, at the magnitudes and weights batch 5 settled: shared meter 15–20 on both
sides, second meter 5–10, draw weight 44–48, asymmetric, and the bare side
alternating left and right four and four.

| Card | Shared, unavoidable | The choice |
|---|---|---|
| `b6_053` the payroll tax is due and the money went into Halsey in March | cash −18/−15 | pay the government, or pay it out of the crews' end |
| `b6_054` your father's box came out from behind the boiler | cash +15/+18 | through the company and slower, or into the street and visible |
| `b6_055` a company car opened on Cooper Avenue with a man in the boot | cops +18/+15 | let it run its course, or pay for a slow file |
| `b6_071` `at_war` — nothing is earning and the book is shut | family −15/−18 | pay them while they sit, or let them sit |
| `b6_072` `docks_taken` — nine hundred men signed the book on Monday | family +18/+15 | our people take the places, or spread them and carry the winter |
| `b6_073` `giulia_home_touched` — a police car at the end of the street | cops −15/−18 | shut the house to the crew, or let them sit there |
| `b6_074` `dope_banned` — sold from a doorway on a street you tax | commission −17/−15 | not our street to clean, or pay to have it pushed off |
| `b6_075` `braca_insulted` — the table settled it your way, unasked | commission +16/+15 | give them the man and close it, or say nothing and take the win |

Paired two per meter, one pushing each way, exactly as the failure-mode row of
the brief asks — and **two of the eight force a gain you cannot refuse**
(`b6_054`, `b6_072`), which is what makes the other six affordable. Vice nets
came in at family −21, commission −9, cops +7, cash −25, all inside ±30.

**One finding worth keeping for batch 7.** A dominance check flagged the two
gain-vices as having a strictly better side — bigger gain, no second cost. That
reading is wrong in this game, and the reason generalises: **every meter kills
at both ends**, so a bigger forced *gain* is not unambiguously better than a
smaller one. Taking less of the push and paying elsewhere is the shape the brief
prescribes, and it holds for gains exactly as it does for losses.

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b6_096` Concetta: Lucia telephones and does not say your name | `b6_076` and every Matty card | `matty_dead` |
| `b6_097` the street, on brown paper and who is asking about the room upstairs | `b6_019`, `b6_050`, `b6_088` and the restaurant-set Rosa cards | `rosa_gone` |
| `b6_098` Concetta on the new one, who says the Mass facing the people | `b6_018`, `b6_090` and every Colla card | `colla_gone` |
| `b6_099` Sally on two young men with money they cannot explain | the ordinary powder-question cards | `dope_sanctioned` |
| `b6_100` Kiernan declining to pretend it is his father's arrangement | `b6_008`, `b6_021`, `b6_038` and the ordinary Kiernan favours | `kiernan_price_up` |

### Flags

**Thirteen new**, all chain flags, all in flag-registry.md: `ridgewood_boys`,
`ridgewood_bag`, `ridgewood_named`, `lucia_asked`, `matty_ruling`, `chair_list`,
`chair_vote`, `linen_offer`, `linen_signed`, `rosa_leaving`, `colla_letter`,
`paolo_asked`, `wills_connection`.

**No new world or character flags.** Batch 6 gives first setters to three flags
that had none anywhere in the deck — `matty_dead`, `rosa_gone`, `colla_gone` —
and a first reader to `adler_skimming`, which batches 4 and 5 both left set and
unread.

**Reads that earlier batches set** (21): `adler_skimming`, `angelo_suspected`,
`at_war`, `aurelio_overruled`, `books_open`, `braca_insulted`, `braca_owes_you`,
`commission_snubbed`, `concetta_blessing`, `docks_taken`, `dope_banned`,
`dope_sanctioned`, `duke_warned`, `giulia_home_touched`, `kiernan_price_up`,
`kiernan_refused`, `matty_covered`, `nardi_used`, `ranieri_offered`,
`sally_backed`, `sally_humiliated`.

**Overhang: 21 pre-existing flags read against 13 new flags created.**
`commission_snubbed` had one setter and no reader in five batches; it now has a
reader (`b6_060`) and a second setter (`b6_080` right).

**Both add and remove cards this batch:** `matty_dead`, `rosa_gone`,
`colla_gone`, `dope_sanctioned`, `dope_banned`, `kiernan_price_up`,
`kiernan_cold`, `sally_moved`, `giulia_left`, `duke_broke_off`, `matty_pinched`,
`matty_disowned`, `angelo_flipped`, `adler_ran`, `wills_war`,
`ranieri_family_touched`, `rosa_place_taken`, `rosa_place_burned`,
`fallon_replaced`, `nardi_talked`. Twenty-nine distinct flags appear in an
`excludesFlags` somewhere in this batch against sixteen set.

### Gating depth

**4 of 25** gated standalones and variants sit at flag-depth ≥ 2, against batch
5's 6 of 25 and batch 4's 24 of 41. Chain follow-ups excluded, as the rule says.
All four are named and earned:

- `b6_096` (`matty_dead`, depth 6), `b6_097` (`rosa_gone`, depth 2) and
  `b6_098` (`colla_gone`, depth 2) are this batch's own three departures. A
  variant covering a death cannot be shallower than the death.
- `b6_064` (`adler_skimming`, depth 2) is deliberate and overdue: the flag has
  been set and unread since batch 4, and the only place to read it is the depth
  its setter sits at. That is 2, not 5 — `b4_094` is an ungated opener.

Every other gated card in the batch sits on a depth-1 flag the player set
themselves.

### Cast coverage

`AURELIO` 13, `UNCLE SALLY` 11, `GIULIA` 10, `MATTY` 9, `DUKE` 8, `ADLER` 6,
`CAPT. KIERNAN` 6, `DET. RANIERI` 5, `ANGELO` 5, `CONCETTA` 4, `DON BRACA` 3,
`FALLON` 3, `MOE WILLS` 3, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 2, reserve 6.
Duke and Angelo one over, Braca and Fallon one under, all inside the ±40%
tolerance; the running total across 600 cards stays on the pro-rata budget.

**Walk-ons remain subjects, not speakers.** The three Ridgewood kids, the
Provenzano capo, Bobby Zito, Petey Nastasi's boy, Sabatino who held Matty at his
christening, the boy who has sold eleven newspapers in three weeks, and the
thirty-four-year-old priest all appear inside cast and reserve cards, never at
the top of one.

### Blood

19 of 100, back in line with batches 1–4 after batch 5's 9, and **budgeted at
the chain level as the brief now requires rather than counted at the end.** Six
of the nineteen are in the chains: `b6_081` (18, whose hand it is), `b6_093`
(16, the boy at the club on Sunday), `b6_079` (14, Lucia's question), `b6_092`
(9), `b6_080` (5). `b6_096` carries 12. No Rosa card costs blood.

### Balance

Written against **No directional bias** from the first card, then corrected in
one re-pointing pass, numbers only — no text, label, flag, weight, blood value
or sign changed, and the script asserted all of that before it wrote:

| | first draft | shipped |
|---|---:|---:|
| family net | +52 | 0 |
| commission net | −3 | 0 |
| cops net | +42 | 0 |
| cash net | −245 | 0 |
| 5–12 band | 88.1% | 87.6% |
| 1–4 band | 6.6% | 6.9% |
| 15–25 band | 4.3% | 5.5% |
| 13–14 gap | 4 | 0 |
| inert sides | 0 | 0 |
| vice net, worst meter | −33 | −25 |

The cash failure was habit 1 again, and in bulk: **twenty-two sides charged the
player cash for money he was declining to take** — leaving a widow her corner,
not collecting a week's vig, enforcing the ban, giving a man his corner back,
writing off a debt never collected, refusing a share of something. Those are 0
cash and the loss belongs in family or commission. Correcting them by hand moved
cash by +109 before any scaling; one factor per meter per direction did the rest
(cash raises ×1.28, lowers ×0.68; family raises ×1.19, lowers ×1.32). Band
membership was preserved by the scaler — 1–4 stays 1–4, 5–12 stays 5–12, heavy
stays heavy — and nothing was left in the deliberate 13–14 gap.

Two structural notes for batch 7, cheap to avoid and expensive to fix:

1. **Write the money-in sides as you go.** The batch still has 32 cash-raising
   sides against 46 lowering ones, because a card about a decision tends to get
   written as a card about a cost. The deck needs cards where money simply
   arrives.
2. The 1–4 band sits at 6.9% against the brief's ~15–20% aim. Not a failure —
   the only enforced floor is 60% in 5–12, and batch 5 shipped 4.2% — but three
   batches running have come in low and it is worth deciding deliberately rather
   than drifting.

### Wiring — done, in the same pass

1. **Done.** The thirteen chain flags are in `GameFlags.chainFlags`
   ([flags.dart](../lib/flags.dart)) under a `// batch 6` comment.
2. **Done.** `assets/cards/batch_6.json` is in `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

`flutter test`: **114/114**, over the real 600 cards, including
`shipped batch deck` (concatenated validation, ids unique across batches, every
required flag settable, every speaker cast or reserve, cast.md hard rule 2) and
`deck_balance_test` per batch.

### Known layout constraint — batch 6

Drafted long — median 224 characters, longest 247 — and tightened in one pass to
**median 199, longest 215**, inside the envelope batches 1–5 were measured
against. Same reason batch 3 gave: a card is two or three short lines of speech
and a 240-character card is four. The batch-2 note still stands — the
short-screen portrait problem is a layout question and cards are not shortened
to chase it.

### Threads left open by batch 6

- **`matty_dead` has one reader** (`b6_096`) and is excluded on fifty-two cards.
  The nephew is the most-carried character after the consigliere and the uncle;
  a house that killed him — or a house at war because it would not — wants three
  or four readers before it wants an arc. **`at_war` now has a setter whose
  cause is a family member**, which is new.
- **`rosa_gone` and `colla_gone` have one reader each.** The neighbourhood
  emptying out is the setting's own subject and is currently two cards.
- `adler_skimming` is finally read (`b6_064`) and can be forgiven or repaid;
  neither branch has a reader.
- `books_open` has four setters and three readers. A making ceremony the player
  actually controls is still mostly unwritten.
- `wills_dope` has two setters and one reader. `wills_connection` is the door if
  batch 7 wants the Commission to find out — **do not re-seed it with a fresh
  "Moe Wills has a connection" card.**
- `linen_signed` and `adler_legit_front` are the quiet end of the safety fault
  line and are now concrete. A family with a real company, a bank and an auditor
  is a state nothing yet reacts to.
- Still with no setter anywhere: `sally_dead`, `duke_dead`, `concetta_dead`,
  `wills_dead`, `adler_dead`. `sally_dead` is the largest remaining — seventy-one
  cards already exclude it — which makes it the obvious **batch-9 slow burn**
  rather than a batch-7 chain.
- **The human playtest is due around batch 7**, per batch 5's decision to stop
  tuning against the simulation. Nothing in batch 6 changed a magnitude, a draw
  weight or the vice quota, so what gets played is the deck batch 5 settled plus
  a hundred cards.

---

## Batch 7 — `assets/cards/batch_7.json`, ids `b7_001`–`b7_100`

**Composition.** 51 flag-free standalone · **3 flag-free vices**
(`b7_053`–`b7_055`) · 16 flag-gated standalone · **5 gated vices**
(`b7_071`–`b7_075`) · 20 chained (`b7_076`–`b7_095`) · 5 suppression variants
(`b7_096`–`b7_100`).

**One card sits outside its id range**, and it is the only batch in seven where
a category count is not a pure range check. `b7_026` was written and numbered as
a flag-free standalone and was gated on `aldo_box` afterwards, on a cold re-read
— see *The card that moved* below. So the flag-free block is `b7_001`–`b7_052`
less `b7_026`, and the flag-aware set is `b7_056`–`b7_070` plus `b7_026`. The
hundred is intact and the direction of the swap is the one the brief already
favours: flag-aware is "the cheapest continuity in the game and the most
reliable."

Batch 7 is the first batch under the four-beat cap, so the chained twenty is the
standard layout and nothing had to be re-solved: **five two-card + two
three-card + one four-card = 20.**

**The batch's job.** Batch 6 left `concetta_dead`, `adler_dead`, `duke_dead`,
`wills_dead` and `sally_dead` with no setter anywhere, and reserved `sally_dead`
for batch 9. It also left Don Aldo's money established and unspent, `books_open`
with four setters and a making ceremony nobody controls, and a family with a
real company, a bank and an auditor that nothing reacted to. Batch 7 spends the
first two deaths and all three of those states.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **Behind the boiler** — `b7_076`→`b7_079` | Don Aldo's money, given to the people it lands on. Sally heard about the box from somebody who is not the family and would like to know why nobody telephoned the man who was his brother and his underboss for nineteen years. Adler, who has done this family's arithmetic for twenty-two years and never saw a dollar of it on a page: if it goes into the company now it has to have come from somewhere, and he writes down where. Giulia sat with the old woman while she counted it twice and got two different numbers, and was asked not to say that she cried — and will not be the second person keeping it. Then Concetta: *he did not tell me either.* **Nothing is re-discovered** and there is no second box. |
| 3 | **The auditor** — `b7_080`→`b7_082` | Gated on `adler_legit_front`. The hospital contract's auditor asks in writing about nine thousand dollars paid to a haulage company with one truck and no telephone. Aurelio explains what immunity actually means — not safety, but that a man cannot refuse to answer. Then Duke, saying out loud that he knows what time Leon's car starts, and asking to be told the other thing. First setter for `adler_dead`; the other branch is `feds_active` and a bookkeeper who talks. |
| 3 | **Uptown** — `b7_083`→`b7_085` | Gated on `wills_connection`, which batch 6 named as the door and told batch 7 not to re-seed. Braca has been asked about a man in Bed-Stuy with an arrangement the table has a rule about, and nobody has said the player's name yet. Sally has to sit at that table in three weeks and would like to be given something he can say twice. Then Moe Wills, asking once what it is the player wants. |
| 2 | **Himrod Street** — `b7_086`→`b7_087` | Two of Duke's men have been into Giulia's father's pharmacy twice this month asking for a weekly figure. He is seventy-four, he gave them eleven dollars, and he did not tell his daughter — the girl behind the counter did. Then Duke: they are two of his, they did not know whose father it was, and whatever happens to them happens in front of everybody or it does not happen. |
| 2 | **The watch** — `b7_088`→`b7_089` | Concetta gave your father's watch to a boy who carried her shopping, and would like you not to look at her like that — she has started giving things away and she knows that she has. Then a morning when she does not get up. **Both sides of `b7_089` set `concetta_dead`**: the choice is only whether the player is standing in that door when forty people arrive. |
| 2 | **The books** — `b7_090`→`b7_091` | Gated on `books_open` — the ceremony the player actually controls, which five batches had left unwritten. Three chairs, a Thursday, and a room somebody has to lend us. Then Angelo, who was not one of the three names and has said nothing about it, asking to be in the room where people can see him. `angelo_paid` or `angelo_suspected`. |
| 2 | **A line of credit** — `b7_092`→`b7_093` | A bank on Myrtle will lend the linen company forty thousand against a personal guarantee: the player's name, signature and address on a document in a filing cabinet. Then Duke, asking where the Friday money gets counted if the company is a real company now. |
| 2 | **The block** — `b7_094`→`b7_095` | The building the Knickerbocker club sits in has been sold to a man from Forest Hills who has written to every tenant about a supermarket. The letter is polite. Then Sally: your father took that lease in 1949, and whatever happens, the men are going to be standing somewhere on Sunday. |

### The vices

Eight, at the magnitudes and weights batch 5 settled and batch 6 confirmed:
shared meter 15–20 on both sides, second meter 5–10, draw weight 44–48,
asymmetric, and the bare side alternating left and right four and four.

| Card | Shared, unavoidable | The choice |
|---|---|---|
| `b7_053` two of ours put a third in hospital over a girl | family −18/−15 | the one who swung goes down, or both crews sit for a month |
| `b7_054` three columns and a photograph of the doorway | cops +15/+18 | move everything off that street tonight, or let them print |
| `b7_055` nineteen years of debt paid in a shopping bag in front of forty people | cash +18/+15 | take it where he put it, or put it through the company |
| `b7_071` `feds_active` — the lawyers want the retainer in front | cash −15/−18 | spread it across the crews' lawyers, or pay the firm that knows us |
| `b7_072` `at_war` — nobody has gone home in nine days and nobody has asked to | family +16/+15 | let them stay where they are, or send them home in twos |
| `b7_073` `ranieri_watching` — the file goes in a drawer either way | cops −15/−18 | he names his price, or nobody ever saw it |
| `b7_074` `dope_sanctioned` — two families have asked Braca separately | commission −17/−15 | he says nothing at all, or he speaks and says it is ours |
| `b7_075` `matty_killed_wrong` — the Provenzanos have decided to be gracious | commission +15/+16 | take it and send something back, or take it and say thank you |

Paired two per meter, one pushing each way, and **two of the eight force a gain
you cannot refuse** (`b7_055`, `b7_072`). Vice nets came in at family −17,
commission −8, cops +15, cash −25, all inside ±30.

`b7_073` is the clearest case of batch 6's finding that a forced *gain* is not a
strictly better side: the bare side drops cops by 18 and costs nothing, and cops
empty is `BENEATH NOTICE`.

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b7_096` Giulia with her mother-in-law's keys in her bag | `b7_088` and every Concetta card | `concetta_dead` |
| `b7_097` Duke on a man in Rego Park who used to keep the Provenzanos' books | `b7_037`, `b7_038`, `b7_060` and every Adler card | `adler_dead` |
| `b7_098` Sally on three Ridgewood kids who have nobody now | `b7_019`, `b7_027` and the ordinary nephew cards | `matty_dead` |
| `b7_099` Giulia on a priest who wants all of them at the Wednesday classes | `b7_047`, `b7_065` and every Colla card | `colla_gone` |
| `b7_100` Moe Wills asking whether the rule is his rule as well | `b7_064` and the ordinary powder cards | `dope_banned` |

### Flags

**Twelve new**, all chain flags, all in flag-registry.md: `aldo_box`,
`box_counted`, `box_word`, `laundry_audit`, `audit_answer`,
`braca_asks_uptown`, `uptown_ruling`, `himrod_shop`, `concetta_giving`,
`ceremony_day`, `bank_line`, `club_lease`.

**No new world or character flags.** Batch 7 gives first setters to the two
flags it spends — `concetta_dead` and `adler_dead` — and a second and third
reader to several batch-6 states.

**Reads that earlier batches set** (22): `adler_legit_front`,
`adler_subpoenaed`, `angelo_suspected`, `at_war`, `aurelio_dead`, `books_open`,
`colla_gone`, `colla_roof_paid`, `dope_banned`, `dope_sanctioned`,
`duke_warned`, `fallon_pension_touched`, `feds_active`, `giulia_home_touched`,
`giulia_told`, `kiernan_price_up`, `matty_covered`, `matty_dead`,
`matty_killed_wrong`, `ranieri_watching`, `wills_connection`, `wills_partner`.

**Overhang: 22 pre-existing flags read against 12 new flags created.**

**Both add and remove cards this batch:** `concetta_dead`, `adler_dead`,
`aurelio_dead`, `matty_dead`, `colla_gone`, `dope_banned`, `dope_sanctioned`,
`adler_ran`, `wills_war`, `giulia_left`, `sally_moved`, `house_split`,
`matty_pinched`, `matty_disowned`, `duke_broke_off`, `angelo_flipped`,
`kiernan_cold`, `ranieri_family_touched`, `rosa_place_taken`,
`rosa_place_burned`, `fallon_replaced`. Twenty-eight distinct flags appear in an
`excludesFlags` somewhere in this batch against forty set.

### Gating depth

**0 at depth ≥ 2 of 18 counted, plus 8 exempt.** The metric was amended after
this batch — see the amendment log and *Gate on first-order flags* in
[content-prompt.md](content-prompt.md) — so batch 7 is the first batch reported
under the new definition and the old figure is kept here beside it.

| | |
|---|---:|
| gated non-follow-up cards | 26 |
| exempt: suppression variants | 5 |
| exempt: gated on a death or departure flag | 3 |
| **counted** | **18** |
| **counted, at depth ≥ 2** | **0** |
| *(memo)* exempt cards that are themselves at depth ≥ 2 | 7 |
| *(memo)* the same batch under the old rule | 7 of 25 |

The eight exempt cards, named so the pile stays visible:

- `b7_096` (`concetta_dead`, depth 2), `b7_097` (`adler_dead`, depth 4),
  `b7_098` (`matty_dead`, depth 6), `b7_099` (`colla_gone`, depth 2) and
  `b7_100` (`dope_banned`, depth 1) — the five suppression variants. Four of the
  five cover a departure, and a variant cannot be shallower than the state that
  makes it necessary.
- `b7_056`, `b7_063` and `b7_070` — the **post-Aurelio cards**, at depth 4
  because `aurelio_dead` is the tail of batch 4's four-beat chain. The
  *post-Aurelio cap* requires three or four of these every batch, so the only
  way to score better under the old rule was to disobey a different one.

**Every card the metric counts is at depth 1**, on a flag the player set
themselves — including `b7_026`, gated on `aldo_box`, which is set on both sides
of the ungated opener `b7_076`.

**One honest note on the arithmetic.** The amendment was proposed with a target
of *4 of 22*, which is what comes out if only the three post-Aurelio cards are
exempted. Exempting the suppression variants as well — which is what the rule
says, and what the variants-cannot-be-shallower reasoning supports — removes the
other four too, because all four of batch 7's remaining depth-≥2 cards were
variants. Hence 0 of 18 rather than 4 of 22. **A zero on a metric's first
outing is a reason to keep reading the exempt column**, which is why the memo
rows above exist and why the brief now requires them.

### Cast coverage

`GIULIA` 15, `AURELIO` 12, `UNCLE SALLY` 9, `DUKE` 8, `ADLER` 7, `MATTY` 6,
`CONCETTA` 6, `DET. RANIERI` 5, `CAPT. KIERNAN` 4, `FALLON` 4, `DON BRACA` 4,
`MOE WILLS` 4, `ANGELO` 3, `ROSA` 2, `FATHER COLLA` 2, `DR. NARDI` 0,
reserve 9. **Exactly the allocation table above**, which is what closes the
speaker drift the batch-6 audit found — including Nardi at zero, since writing
him again is what would make his +20% overhang permanent.

**Walk-ons remain subjects, not speakers.** Bobby Zito, Nunzio's widow, the
boy at the Eight-Three who counts the envelope in front of you, Sister Angela,
the Grasso boy, the girl behind the counter on Himrod, the boiler man who is
Ranieri's cousin's son, and the man from Forest Hills with the supermarket all
appear inside cast and reserve cards, never at the top of one.

### Blood

19 of 100, budgeted at the chain level as the brief requires. **Seven of the
nineteen are in the chains**, across three of the eight arcs — `b7_089` (16, the
morning she does not get up), `b7_078` and `b7_086` (12, the counting and the
pharmacy), `b7_079` (8), `b7_087` (8), `b7_088` (8), `b7_076` (6). Giulia speaks
eleven of the nineteen and Concetta four, which is the cast fact batch 5's
shortfall established: a batch she is barely in comes up short, and this is a
batch she carries. No Rosa card costs blood.

One blood value was removed rather than re-pointed: `b7_065` charged blood for
declining to put your father's name on a parish plaque, and blood is the wife,
the son and the brother. A dead man is not a blood cost.

### Balance

Written against **No directional bias** from the first card, then corrected in
two passes, numbers only — no text, label, flag, weight, blood value or sign
changed:

| | first draft | after hand pass | shipped |
|---|---:|---:|---:|
| family net | +21 | +5 | +3 |
| commission net | −45 | −47 | 0 |
| cops net | +34 | +48 | −1 |
| cash net | −272 | −104 | −2 |
| 5–12 band | 92.2% | 89.2% | 89.2% |
| 1–4 band | 4.0% | 6.0% | 6.0% |
| 15–25 band | 3.8% | 4.8% | 4.8% |
| 13–14 gap | 0 | 0 | 0 |
| inert sides | 0 | 0 | 0 |
| garnish sides | 0 | 0 | 0 |
| vice net, worst meter | −25 | −25 | −25 |

**Cash was habit 1 for the third batch running, and it is worth naming the exact
shape it takes**, because "opportunity cost is not an outlay" has not been
enough on its own. Twenty sides charged cash for something that costs nobody
anything: *find out who he is*, *bring in another table*, *sit with him*, *take
the boy home*, *do it his way*, *tell them it is finished*. These are not even
declined income — they are favours and errands, and the author reaches for cash
because cash is the meter that feels like effort. **A favour costs family or
commission. It does not cost money unless money leaves the house.** Those twenty
went to 0 and the loss moved to family or commission, which is +111 of the
+270 by itself.

The other half was the mirror the brief already asks for and batch 6 wrote down:
**money-in sides, written deliberately.** Eleven were added where the fiction
already had money arriving — the widow the Provenzanos are now paying, the
envelope that stops going out, the route sold to a man from Astoria, the welfare
fund opened, the nephew's piece of a load. Batch 7 still ships 36 cash-raising
sides against 49 lowering ones, so the pull is structural rather than careless
and batch 8 should expect it.

The second pass was one scale factor per meter per direction, band membership
and sign preserved, vices excluded because their magnitudes are prescribed:
family raises ×0.94 / lowers ×1.06, commission raises ×1.10, cops raises ×0.92,
cash raises ×1.10 / lowers ×0.78.

**The 1–4 band was written to the new 5–10% target rather than corrected into
it.** All 33 minor deltas are second meters sitting beside a 5-or-more on the
same side, and `DeckBalance` reports **zero garnish sides** — the first batch to
do that.

### Wiring — done, in the same pass

1. **Done.** The twelve chain flags are in `GameFlags.chainFlags`
   ([flags.dart](../lib/flags.dart)) under a `// batch 7` comment.
2. **Done.** `assets/cards/batch_7.json` is in `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

`flutter test`: **128/128**, over the real 700 cards, including
`shipped batch deck` (concatenated validation, ids unique across batches, every
required flag settable, every speaker cast or reserve, cast.md hard rule 2, the
four-beat chain cap, gates set on both sides) and `deck_balance_test` per batch.

### The card that moved — `b7_026`

Written flag-free, shipped gated on `aldo_box` after a cold re-read. Recorded
because the test it failed is one every batch can fail and none of the automated
checks can see.

> **DET. RANIERI** — *Your mother's boiler man is my cousin's boy, and he told me
> what came out from behind it, because he tells everybody everything. I am not
> asking you about it. I am telling you that he does that.*

Read by somebody who has met the father's money — either `b6_054` or this
batch's own chain — it is one of the best cards in the batch: the leak, arriving
from outside the family, from the one man who cannot be paid, who is pointedly
not asking. Read by somebody who has not, it is a detective mentioning that a
workman is a gossip, and **neither side of the choice has any weight, because
the player cannot know whether what came out matters.** Paying off a stranger
over an unspecified object is not a decision under pressure.

The giveaway is grammatical and worth learning to spot: *"what came out from
behind it"* is a definite reference to an event the card never states. That is
the *so, about that thing* shape the brief forbids, wearing a disguise — it does
not name a prior card, so it reads as self-contained, and it is not. **A card is
self-contained when its stakes are on the card, not merely when its sentences
parse.**

Gated on `aldo_box`, which is set on both sides of `b7_076`, so it is depth 1
and arrives in any run where the chain has opened at all. Nothing else changed —
same text, same effects, weight 9 → 24 and `once` false → true to match its new
category.

### Known layout constraint — batch 7

Median text length 202 characters, longest 217, inside the envelope batches 1–6
were measured against. The batch-2 note still stands: the short-screen portrait
problem is a layout question and cards are not shortened to chase it.

### Threads left open by batch 7

- **`concetta_dead` has one reader** (`b7_096`) and is excluded on thirteen
  cards in this batch alone. The mother was the deck's most under-served voice until this batch and
  is now the second permanent absence after the consigliere; a house with
  neither is a state worth two or three readers before it is worth an arc.
- **`adler_dead` has one reader** (`b7_097`). Who does the arithmetic, and what
  happens to twenty-two years of books, is unwritten. `adler_ran` has had the
  same question open since batch 2 and the two states can share readers.
- **Don Aldo's money is spent as a thread and closed as a discovery.** Sally,
  Adler, Giulia and Concetta have each had it now. Batches 8 and 9 may refer to
  it freely and **may not find any more of it** — see *Established backstory*.
- `books_open` finally has a ceremony (`b7_090`→`b7_091`). What a newly made man
  does in the weeks after is still thin; `matty_made` was the only version of
  that and the nephew may be dead.
- `bank_line` and `adler_legit_front` now put a bank, an auditor and a signed
  personal guarantee in the world. **Nothing yet reads a signature.**
- `braca_owes_you` and `commission_snubbed` each pick up a setter here and stay
  thin.
- Still with no setter anywhere: `sally_dead`, `duke_dead`, `wills_dead`.
  `sally_dead` remains the **batch-9 slow burn** batch 6 reserved it as —
  seventy-one cards already exclude it — which leaves `duke_dead` and
  `wills_dead` for batch 8, and Duke is the one the deck has been arguing with
  since card one.
- **The human playtest is still due.** Batch 7 changed no magnitude, no draw
  weight and no vice quota, exactly as batch 5's decision requires, so what
  gets played is the deck batch 5 settled plus two hundred cards. Nothing in
  this batch should be tuned against a simulation before that happens.

---

## Batch 8 — `assets/cards/batch_8.json`, ids `b8_001`–`b8_100`

**Composition.** 52 flag-free standalone (`b8_001`–`b8_052`) · **3 flag-free
vices** (`b8_053`–`b8_055`) · 15 flag-gated standalone (`b8_056`–`b8_070`) ·
**5 gated vices** (`b8_071`–`b8_075`) · 20 chained (`b8_076`–`b8_095`) · 5
suppression variants (`b8_096`–`b8_100`).

Every category is a pure range check this time — nothing moved between blocks
after writing, unlike batch 7's `b7_026`. The chained twenty is the standard
layout under the four-beat cap: **five two-card + two three-card + one
four-card = 20.**

**The batch's job.** Batch 7 left `duke_dead` and `wills_dead` with no setter
anywhere and reserved `sally_dead` for batch 9. It also left a bank, an auditor
and a signed personal guarantee in the world with **nothing reading a
signature**, a ceremony (`books_open`) with nothing about what a new man does
afterwards, a padlocked club building (`club_lease`), and `concetta_dead` and
`adler_ran`/`adler_dead` each with a single reader. Batch 8 spends both
remaining deaths and all four of those states.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **The number** — `b8_076`→`b8_079` | Duke, and the argument the deck has been having since card one. He has worked out the family's whole number himself and says so rather than have it reported; three of his men are at a Provenzano christening and he is not; Adler can make every crew's figure agree with something except this one, and it is not short, it is too large. The last card offers no third answer and Duke names it himself. First setter for `duke_dead`, which also reaches `house_split` from depth 4 rather than 7. |
| 3 | **Uptown, after** — `b8_080`→`b8_082` | Gated on `wills_connection`, which batch 6 opened and batch 7 named as the door and told batch 8 not to re-seed. Braca gives an opinion twice and no order at all. Moe Wills, who has already been told what was said at a table he has never sat at, asks one question and says he will take the answer. Then two men out of Ozone Park who have sat on Fulton Street for three days. First setter for `wills_dead`. |
| 3 | **Jersey** — `b8_083`→`b8_085` | The chain that spends the house. Giulia's sister's husband has a linen route in Union: the summer, then the school year, then he does not come back. Then a soldier whose own boy has heard about it and who never sent his anywhere. Then Paolo, eleven, who has told his mother he does not want to go and his teacher that he does, and has already worked out that there is a right answer for each of them. |
| 2 | **The guarantee** — `b8_086`→`b8_087` | Gated on `bank_line`. **The first card in the deck to read a signature.** The bank wants the guarantee renewed with a notarised statement of what the player personally owns; then a man from the bank's compliance calls at the precinct, and Kiernan mentions that this is twice now he has looked into something this year. |
| 2 | **The new men** — `b8_088`→`b8_089` | Gated on `books_open`. Angelo waited a month before asking what he is now, and two people have used the player's name on him since. Then Sally: every new man has gone to Bushwick because Bushwick is where the earning is, and your father spread them and it cost him money. |
| 2 | **Sunday on the pavement** — `b8_090`→`b8_091` | Gated on `club_lease`. A chain and a padlock on the Knickerbocker Avenue door and forty men outside by ten o'clock. Then Father Colla, who is *not* offering the hall under the school, and who would like the player to know he knows what he would be doing if he were. |
| 2 | **The envelope on the shelf** — `b8_092`→`b8_093` | Dr. Nardi's whole budget, and the test his entry has been waiting for. A man on the kitchen table who will live, what came out of him in an envelope on a shelf, and a doctor asking for the debt to be gone and never to be telephoned again. `nardi_debt_cleared` gets a reader at last. |
| 2 | **Named as a witness** — `b8_094`→`b8_095` | Gated on `feds_active`. Aurelio on why *witness* is the worse of the two words. Then two men in a car outside since Tuesday, and one of them handing Giulia an envelope with her own name on it in front of the children. |

### The vices

Eight, at the magnitudes and weights batch 5 settled and batches 6 and 7
confirmed: shared meter 15–20 both sides, second meter 5–10, draw weight 45–48,
asymmetric, bare side alternating four and four.

| Card | Shared, unavoidable | The choice |
|---|---|---|
| `b8_053` a man of ours in a car with his own crew's money still on him | family −18/−15 | the eleven sit in that room until somebody says it, or we bury him and ask nobody |
| `b8_054` eleven people watched it and there are eleven statements | cops +18/+15 | not one of ours says a word, or find the eleven and sit with them |
| `b8_055` the welfare fund is eleven thousand over and must move | cash +18/+15 | it comes to us clean, or it goes through the local's own books |
| `b8_071` `at_war` — eleven men paid to sit in a room, and Friday comes | cash −18/−15 | paid in full, or half now and the rest when it is finished |
| `b8_072` `feds_active` — four years of ledgers go, and so does everything else | cops −18/−15 | it burns, or it sits in a house in Forest Hills |
| `b8_073` `dope_sanctioned` — the house has decided you are on its side | family +18/+15 | let them, or tell them out loud that it is temporary |
| `b8_074` `giulia_home_touched` — everybody knows, and that nothing happened | commission −18/−15 | let it go on being old news, or answer it now, late |
| `b8_075` `matty_killed_wrong` — the mother has been paid for a year, by Wills | commission +18/+15 | let them go on thinking it, or pay him back in front of them |

Paired two per meter, one pushing each way, and **two of the eight force a gain
you cannot refuse** (`b8_055`, `b8_073`). `b8_072` is the third gain-shaped one
and is the same argument as batch 7's `b7_073`: a forced drop in cops is not a
strictly better side, because cops empty is `BENEATH NOTICE`. Vice nets came in
at family −16, commission −15, cops +16, cash −17, all inside ±30.

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b8_096` Adler on eleven men who counted it themselves and got eleven figures | `b8_027`, `b8_030`, `b8_076` and every Duke card | `duke_dead` |
| `b8_097` the week nobody north of the parkway wrote a number | `b8_043`, `b8_044` and the ordinary Bed-Stuy cards | `wills_dead` |
| `b8_098` Sally on his brother's wife's house and the anniversary Mass | `b8_024`, `b8_011` and every Concetta card | `concetta_dead` |
| `b8_099` the bank on Myrtle, holding, for the man who keeps the books | `b8_086`, `b8_049` and every Adler card | `adler_dead` |
| `b8_100` a corpsman from Korea in Maspeth who wants two hundred beforehand | `b8_051`, `b8_092` and every Nardi card | `nardi_gone` |

**`b8_100` was re-pointed at its source rather than re-gated.** It shipped
gated on `nardi_gone`, which had exactly one setter — the end of batch 3's
two-card chain — putting it at depth 3, behind a state almost no run reaches.
The card was correct and invisible, which is the defect the gating metric exists
to find, and a variant's gate cannot be shallower than the state that makes it
necessary. So the state was made reachable instead: **`b8_092` left now sets
`nardi_gone` as well**, which its own label already said out loud — *THE DEBT IS
GONE AND SO IS HE*. `nardi_gone` moves from depth 3 to **depth 1** on an ungated
chain opener, `b8_100` and batch 4's `b4_075` both come within reach, and the
doctor ends up with two ways out rather than one: his nerve fails, or the player
lets him go. Nothing else changed — same text, same gate, same category.

### Flags

**Twelve new**, all chain flags, all in flag-registry.md: `bushwick_number`,
`bushwick_hands`, `bushwick_answer`, `uptown_verdict`, `wills_told`,
`paolo_jersey`, `jersey_counted`, `guarantee_asked`, `new_men_month`,
`club_shut`, `nardi_finished`, `grand_jury`.

**No new world or character flags.** Batch 8 gives first setters to the two
flags it spends — `duke_dead` and `wills_dead` — which had none anywhere.

**Reads that earlier batches set, through `requires.flags`** (18):
`adler_dead`, `adler_ran`, `at_war`, `aurelio_dead`, `bank_line`, `books_open`,
`club_lease`, `concetta_dead`, `docks_taken`, `dope_sanctioned`, `feds_active`,
`giulia_home_touched`, `kiernan_price_up`, `matty_killed_wrong`, `nardi_gone`,
`ranieri_watching`, `wills_connection`, `wills_partner`. Counting
`excludesFlags` as well the figure is **38**.

**Overhang: 18 pre-existing flags read against 12 new flags created.** The
deck-wide count of flags set and never read anywhere is **0**, where the brief's
standing figure was 24; batch 8 does not add to it.

**Both add and remove cards this batch:** twenty-nine distinct flags appear in an
`excludesFlags` somewhere in the batch against thirty-nine set.

**One registry rule was found broken, and settled rather than routed around a
second time.** `dope_sanctioned` and `dope_banned` are declared mutually
exclusive — no card may set one without excluding the other — and `b6_036` and
`b6_063` had broken it since batch 6. The consequence was live: `b1_090` left
sets `dope_sanctioned`, `b6_036` left could then set `dope_banned` in the same
run, and all sixteen reader cards go eligible at once against a deck that draws
at random.

**The rule was kept and the two cards corrected.** `b1_090` — the card that opens
the thread — already implemented it exactly, so batch 6 had drifted from a working
model rather than found a broken one. Both cards now carry the two flags in
`excludesFlags`. Gating only: no text, effect, weight or flag-set changed, batch
6's balance figures are identical, and nothing is stranded — `b6_063`'s own gate
keeps five routes that leave the ruling untouched. Full reasoning, including why
striking the rule was rejected, is in [flag-registry.md](flag-registry.md).

**`b8_079` remains the one deliberate exception and sets neither flag.**
Excluding `dope_banned` on that beat would have dropped the fourth card of the
batch's spine, and the deck's only route to `duke_dead`, for every player who had
already banned. The ratchet principle wants a reversal to be a *new* flag, and
minting one post-hoc with no readers is worse, so the sanction is carried by
`duke_dope`, set on both sides of `b8_078`.

### Gating depth

**0 at depth ≥ 2 of 19 counted, plus 23 exempt.**

| | |
|---|---:|
| gated cards, all kinds | 42 |
| exempt: chain follow-ups | 12 |
| exempt: suppression variants | 5 |
| exempt: gated on a death or departure flag | 6 |
| **counted** | **19** |
| **counted, at depth ≥ 2** | **0** |
| *(memo)* exempt cards themselves at depth ≥ 2 | 19 |

The counted nineteen are the fifteen flag-aware standalones and five gated vices,
less the six gated on a death or departure flag, **plus the five gated chain
openers** — `b8_080`, `b8_086`, `b8_088`, `b8_090`, `b8_094`. The brief's named
set is the first fourteen; the openers are included here because an opener's gate
is as freely chosen as a standalone's, and all five are depth 1 anyway, so the
figure is 0 either way.

**The exempt pile grew and it is worth saying why.** On batch 7's own
accounting — variants and death-gated cards only, follow-ups not counted — batch
7 had 8 and batch 8 has 11. The whole difference is three extra death-gated
standalones, and they are the readers batch 7's open-threads list asked for:
`b8_059` and `b8_060` are the second and third readers for `concetta_dead`, and
`b8_061` is the first thing `adler_ran` has had since batch 2. A card gated on a
death cannot be shallower than the death is.

The six death-gated standalones: `b8_056`, `b8_057`, `b8_058` (`aurelio_dead`,
depth 4 — the **post-Aurelio cap's** three, from the Concetta, Sally and Adler
allocations exactly as cast.md requires), `b8_059`, `b8_060` (`concetta_dead`,
depth 2), `b8_061` (`adler_ran`, depth 3).

### Cast coverage

`AURELIO` 13, `GIULIA` 12, `UNCLE SALLY` 10, `DUKE` 8, `MATTY` 8, `ADLER` 6,
`CONCETTA` 6, `CAPT. KIERNAN` 5, `DET. RANIERI` 5, `FALLON` 4, `DON BRACA` 4,
`MOE WILLS` 4, `ANGELO` 3, `ROSA` 2, `FATHER COLLA` 2, `DR. NARDI` 2,
reserve 6.

**The audit was re-run rather than trusted**, as the batch-7 allocation table
asked. Batch 7 hit its table exactly, so the batch-8 column is the remaining
budget halved. At 800 cards every speaker is inside **±2.5%** of pro-rata except
`DR. NARDI` at +5.0%, and all three of the batch-6 audit's drift cases are
closed: `CONCETTA` −6.8% → **−1.6%**, `MOE WILLS` −5.7% → **−2.5%**, `GIULIA`
−8.5% → **−1.0%**.

**Batch 9's allocation, which is now simply what is left**, and it sums to 100:
`AURELIO` 12, `GIULIA` 12, `UNCLE SALLY` 10, `MATTY` 8, `DUKE` 6, `ADLER` 6,
`CAPT. KIERNAN` 5, `DET. RANIERI` 5, `CONCETTA` 5, `ANGELO` 4, `FALLON` 4,
`DON BRACA` 4, `MOE WILLS` 4, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 1,
reserve 8. Every figure is inside cast.md's ±40% per-batch tolerance, and every
cumulative total lands exactly on budget at 900. `DR. NARDI` at 1 is not a
rounding artefact — he is the one speaker still outside ±2.5% at 800, at +5.0%,
and one card lands him exactly on 15.

#### Batch 9's chain blood — a constraint, not a target

**Two of batch 9's eight arcs must spend the house, and they are chosen before
any card is written.** This is binding, and it is written here because two
batches running have failed it in the same way while passing the deck-wide blood
count: batch 7 put seven blood cards in the chains and batch 8 four, both against
a nineteen-card total, because the arcs a batch wants to build are business —
a capo, a numbers man, an auditor, a bank, a union.

Why the number goes up rather than holding:

1. **One arc in eight is not enough and batch 8 proves it.** Batch 8 did what the
   brief asks — Jersey was chosen as the house-spending chain before the writing
   started — and still came in at four of nineteen, because a single arc can only
   carry three or four blood cards before it stops being a decision and becomes a
   theme. The fix is a second arc, not a heavier one.
2. **Batch 9 is the last batch.** Every other shortfall in this project has been
   correctable by the next batch. This one is not. Whatever blood is not in
   batch 9's chains is blood the deck never has in its arcs, and the arcs are
   where a run's most effortful writing lives.
3. **The material is already there and it is the right material.** `sally_dead`
   is batch 9's reserved burn and it is the player's uncle — his father's
   brother, the man who was passed over. That arc cannot be written as business.
   It is one of the two by construction, which means batch 9 has to find only
   one more.

Practically: **decide both arcs at the same time as the eight chain subjects**,
before a line of text exists, and expect `GIULIA` — 12 cards, and the carrier of
roughly half the deck's blood on her own — to speak in both. A batch she is
barely in is a batch that will come up short, and at batch 9 there is nothing
after it to correct the number.

#### Batch 9 closes books; it does not open them

**The flag-overhang rule has been read too narrowly for eight batches.** Every
batch since 1 has checked that it reads more pre-existing flags than it creates,
and every batch has passed, and the deck-wide count of flags *set and never read
at all* is 0. That test is satisfied and it was never the whole problem. The
real one is the `sally_backed` shape the batch-4 entry named and nothing has
systematically chased since: **twenty-two cards across three batches set it and
nothing had ever noticed.** A flag with one reader and nine setters is a
consequence the player earns nine ways and meets once.

Here is the whole list as it stands at 800 cards — non-chain, non-silence flags
set by five or more cards and read by two or fewer through `requires.flags`.
**Batch 9's flag-aware fifteen and its gated vices should come off this table
rather than out of anything new:**

| Flag | Cards that set it | `requires` readers |
|---|---:|---:|
| `angelo_paid` | 13 | 2 |
| `adler_legit_front` | 12 | 2 |
| `giulia_shielded` | 11 | 1 |
| `duke_dope` | 11 | 2 |
| `concetta_silent` | 9 | 1 |
| `aurelio_doubted` | 8 | 1 |
| `colla_warned_you` | 8 | 2 |
| `wills_stopped_paying` | 7 | 1 |
| `colla_roof_paid` | 7 | 2 |
| `concetta_blessing` | 7 | 2 |
| `giulia_lied_to` | 7 | 2 |
| `braca_owes_you` | 6 | 2 |
| `braca_owed_him` | 5 | 1 |
| `sally_faction` | 5 | 1 |

Four notes on reading it:

1. **`giulia_shielded` at 11 and 1 is the worst thing on the table**, not
   `duke_dope`. Eleven cards record the player keeping blood away from the house
   at a real cost, and one card ever mentions it. That is the deck's single
   largest unacknowledged act of decency, and Giulia has 12 cards in batch 9.
2. **`duke_dope` is the same defect as `sally_backed` and earns its own
   existence.** It predates batch 8 by seven batches and says the thing the
   ruling flags cannot — *this capo is in it whether or not the house has
   ruled* — which is Duke's whole character. It needs two or three readers, not
   an arc; it is depth 1, so a flag-aware standalone reaches it in any run.
3. **`angelo_paid` and `wills_stopped_paying` are the two that also suppress**
   (4 and 1 `excludesFlags` readers), so they are doing half a job rather than
   none. Everything else on the table is pure accumulation.
4. **`sally_faction` at 5 and 1 sits directly under the reserved batch-9 burn.**
   `sally_dead` is that arc, the uncle counting names is what leads to it, and
   the flag is already there — so batch 9 gets this one nearly free, and per the
   *reserved threads* rule it must build on the flag that exists rather than
   seed a fresh one.

**What this means for the twelve new chain flags batch 9 will create.** They are
unavoidable — a chain needs them — but they are the last twelve this deck ever
gets, and every one is set once and read once by construction. Nothing else new
should be minted. If batch 9 finds itself wanting a new world or character flag,
the answer is on the table above.

**Walk-ons remain subjects, not speakers.** The Grasso woman, the boy who
sweeps the club, the man from the Labor Department, the lieutenant writing plate
numbers, the fella in Maspeth who was a corpsman in Korea, the two women who
stopped the priest, and the bank's compliance man all appear inside cast and
reserve cards, never at the top of one.

### Blood

19 of 100, budgeted at the chain level. **Four of the nineteen are in the
chains** and all four are in two of the eight arcs — `b8_083`, `b8_084`,
`b8_085` (Jersey) and `b8_095` (the envelope handed over in front of the
children). That is fewer chain-blood cards than batch 7's seven, and it is the
consequence of the batch's two headline arcs being a capo and a numbers man:
both are business, and the brief's answer to that is to decide the house-spending
chains up front, which is what Jersey is. Giulia speaks ten of the nineteen and
Concetta four. **No Rosa card costs blood**, per her entry.

### Balance

Written against **No directional bias** from the first card, then corrected in
two passes, numbers only — no text, label, flag, weight, blood value or sign
changed:

| | first draft | after hand pass | shipped |
|---|---:|---:|---:|
| family net | −5 | −8 | **−6** |
| commission net | +37 | +7 | **−2** |
| cops net | +101 | +47 | **−1** |
| cash net | −131 | −47 | **+1** |
| 5–12 band | 92.6% | 92.3% | 89.0% |
| 1–4 band | 3.9% | 4.0% | 7.3% |
| 15–25 band | 3.5% | 3.7% | 3.7% |
| 13–14 gap | 0 | 0 | 0 |
| inert sides | 0 | 0 | 0 |
| garnish sides | 0 | 0 | 0 |
| vice net, worst meter | −17 | −17 | −17 |

**Batch 7 predicted the cash pull and it arrived on schedule**, at −131 with 43
cash-raising sides against 59 lowering. Seventeen sides were charging cash for
something that is not an outlay, and the list is almost word for word batch 7's:
*go to the sit-down*, *move the driver*, *put him out*, *find out what he wants*,
*sit with every new man*, *go on doing it*, *ask him to his face*. **A ruling, a
visit, an instruction and an errand are not payments.** Those went to 0 and the
loss moved to family or commission. Eight cops-raising sides went the same way,
for the mirror reason — heat was attached to sides where the fiction does not put
anybody outdoors. That hand pass alone is +84 cash and −48 cops. Shipped, cash
raises 43 against 45 lowering, which is the first batch where the two are level.

The second pass was one scale factor per meter per direction, band membership and
sign preserved, vices excluded because their magnitudes are prescribed: family
raises ×1.06 / lowers ×0.94, commission raises ×0.92 / lowers ×0.96, cops raises
×0.90 / lowers ×0.96, cash raises ×1.18 / lowers ×0.96.

**The 1–4 band was placed, not scaled into.** The scale pass left it at 4.0%,
under the 5–10% the brief asks for, so eighteen deltas were dropped from 5 to 4 —
paired one up against one down per meter so no net moved, and only on sides that
already carried a 7 or more on another meter. Every one is therefore a second
meter beside a first that is doing the work, `DeckBalance` reports **zero garnish
sides**, and the band lands at 7.3%.

### Wiring — done, in the same pass

1. **Done.** The twelve chain flags are in `GameFlags.chainFlags`
   ([flags.dart](../lib/flags.dart)) under a `// batch 8` comment.
2. **Done.** `assets/cards/batch_8.json` is in `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

`flutter test`: **129/129**, over the real 800 cards, including
`shipped batch deck` and `deck_balance_test` per batch.

### Known layout constraint — batch 8

Median text length 201 characters, longest 219, inside the envelope batches 1–7
were measured against. The batch-2 note still stands: cards are not shortened to
chase the short-screen portrait problem.

### Threads left open by batch 8

- **`sally_dead` is the only flag in the registry with no setter that a batch
  still owes**, and it remains the **batch-9 slow burn** batch 6 reserved it as.
  Seventy-odd cards already exclude it. Note the arithmetic: batch 9 is capped at
  four beats like every batch since 7, so the reservation is for an arc, not for
  a six-card burn.
- **`duke_dead` and `wills_dead` each have one reader** (`b8_096`, `b8_097`) and
  are excluded on many cards. Bushwick without a capo, and the Bed-Stuy line with
  nobody to negotiate with, are both states worth two or three readers in batch 9
  rather than an arc.
- **`house_split` now has a shallow route.** `b8_079` reaches it at depth 4 where
  it was depth 7, so its four existing readers are reachable in far more runs
  than they were. Nothing more is needed; this is the fix, not the start of one.
- **A signature is now read once** (`b8_086`→`b8_087`) and `guarantee_asked` has
  a single reader. What a personally guaranteed loan does to a man who cannot
  explain his income is still mostly unwritten.
- `nardi_debt_cleared` finally has a setter with a card behind it. `nardi_talked`
  and `nardi_gone` keep their batch-3 setters and stay thin.
- `braca_owes_you` picks up two more setters here and is still spent by almost
  nothing — it is worth more unspent than spent, per the registry, but at some
  point somebody has to call it in.
- **`duke_dope` is badly under-read**, and batch 8 is the batch that noticed.
  Eleven cards set it across six batches against **two** readers (`b2_061`,
  `b5_065`). It is not a workaround and it is not new — it predates batch 8 by
  seven batches and it means something the ruling flags cannot say, namely *this
  capo is in it whether or not the house has ruled*, which is the whole of Duke's
  character. But a flag set eleven times and read twice is a consequence the deck
  does not react to. It is depth 1 and needs readers, not an arc. **It is one of
  fourteen in the same condition** — the full table is under *Batch 9 closes
  books* above, and `giulia_shielded` at eleven setters and one reader is worse.
- **The human playtest is still due.** Batch 8 changed no magnitude, no draw
  weight and no vice quota, exactly as batch 5's decision requires. What gets
  played is the deck batch 5 settled plus three hundred cards.

---

## Batch 9 — `assets/cards/batch_9.json`, ids `b9_001`–`b9_100`

**Composition.** 52 flag-free standalone (`b9_001`–`b9_052`) · **3 flag-free
vices** (`b9_053`–`b9_055`) · 15 flag-gated standalone (`b9_056`–`b9_070`) ·
**5 gated vices** (`b9_071`–`b9_075`) · 20 chained (`b9_076`–`b9_095`) · 5
suppression variants (`b9_096`–`b9_100`). Every category is a pure range check;
nothing moved between blocks after writing. The chained twenty is the standard
layout under the four-beat cap: **five two-card + two three-card + one
four-card = 20.** **Batch 9 does not get a slow burn**, per the cap.

**The batch's job.** Batch 8 left `sally_dead` as the only flag in the registry
with no setter anywhere, reserved it as batch 9's arc, and left a fourteen-row
table of flags the deck sets and never reads — `giulia_shielded` at eleven
setters and one reader the worst of them. It also asked for readers rather than
arcs for `duke_dead`, `wills_dead` and `duke_dope`. Batch 9 spends the last
death and takes its flag-aware fifteen and its gated vices off that table.

### Chains

| Cards | Name | Arc |
|---|---|---|
| 4 | **The last table** — `b9_076`→`b9_079` | Gated on `sally_faction`, the flag the reservation named, read rather than re-seeded. The uncle comes and *asks*, which he has never done: men are calling themselves his, he did not ask one of them, and he cannot make them stop. Then a soldier who was asked which way he would go and did not answer, and wants it known that they asked four of them. Then Carmela in Giulia's kitchen, asking whether her husband will be at his own table at Christmas the way you check a train time. The last card is Sally, and **both sides set `sally_dead`** — the men have decided, and neither he nor the player can call it off. First and only setter for `sally_dead`. Blood arc one. |
| 3 | **What it cost** — `b9_080`→`b9_082` | Gated on `giulia_shielded`, the eleven-setter, one-reader flag batch 8 named as the deck's largest unacknowledged decency. She has counted the nights he washed his hands before touching anybody; she is not asking him to stop, she is asking to be allowed to say she knows. Ends on the thing her entry has wanted since batch one, said in a sentence for the first time: one of the two children out of the borough before September, and the player picks which. Blood arc two. |
| 3 | **The statement** — `b9_083`→`b9_085` | Gated on `adler_legit_front`. The quiet end of the safety fault line, finished: a real company files a real return, a return is signed by a person, and whoever signs is telling the government in his own hand what this company is. Sally, who notes the player's father never signed anything in his life and was not being careful — he simply never had to. Then Ranieri, who read the filing in a public office on a Tuesday and learned something about the family without asking anybody a question. |
| 2 | **What he is owed** — `b9_086`→`b9_087` | Gated on `angelo_paid` (13 setters, 2 readers). Nine years without a word, and he asks out loud, in front of people, to be considered for a crew. Sally backs whatever the player says and wants it written that he said so first. |
| 2 | **The favour** — `b9_088`→`b9_089` | Gated on `braca_owes_you`, which the registry calls worth more unspent than spent and which nothing had ever called in. He asks to have it named while he is still able to settle it, and says nothing is an insult. Aurelio prices it: by Sunday it will be a thing he did for a young man who needed help. |
| 2 | **The last local** — `b9_090`→`b9_091` | Gated on `fallon_squeezed`. Eleven hundred men from three thousand, and the International wants to merge the local into Newark. Then Duke: forty of those men are ours, he can use nine of them, and the rest will be on Knickerbocker Avenue at eleven in the morning. |
| 2 | **The boy at the door** — `b9_092`→`b9_093` | The batch's one flag-free opener, and its third blood chain. Matty's mother has offered him a room in Ridgewood and a job at a printer's, and asked him in front of his aunt so he could not say no easy. Then Lucia telephoning Giulia before she telephones the player, which she has never done. |
| 2 | **The winter** — `b9_094`→`b9_095` | Gated on `colla_warned_you`. Rosa Pinto has moved from the ten o'clock to the eight, where nobody speaks to anybody. She has not stopped paying and will not; she has stopped being able to look at the people she owes it to over a plate of food. **No blood**, per her entry. |

### The vices

Eight, at the magnitudes and weights batch 5 settled: shared meter 15–20 both
sides, second meter 5–10, draw weight 45–48, asymmetric, **bare side alternating
four and four**.

| Card | Shared, unavoidable | The choice |
|---|---|---|
| `b9_053` a man of ours spent a month in a bar saying what he does for a living | family −18/−15 | he is put out and everybody told why, or he stays and everybody watches him stay |
| `b9_054` a boy of seventeen shot at a school gate four doors from a place you own | cops +18/+15 | nobody of ours goes near it, or we help them find who did it |
| `b9_055` a dead man's brother has brought eleven thousand to a table in a paper bag | cash +18/+15 | it all comes to us, or half stays with him and he remembers it |
| `b9_071` `at_war` — nineteen men sleeping at the club who have no need to be there | family +18/+15 | let them all stay, or send the ones not needed home with something |
| `b9_072` `feds_active` — the street is the quietest it has been in nine years | cops −18/−15 | everything stops, or the numbers go on and nothing else does |
| `b9_073` `ranieri_watching` — a detective in the captain's own squad he cannot touch | cash −18/−15 | pay him to be somewhere else entirely, or pay less and let him stay close |
| `b9_074` `braca_sponsor` — the table has picked you to arbitrate and you cannot do it invisibly | commission +18/+15 | an answer they both dislike, or settle it out of our own pocket |
| `b9_075` `docks_taken` — the local's filing is signed by whoever is running it | commission −18/−15 | put your own name on it, or find a name nobody has heard of |

Paired two per meter, one pushing each way, and **two of the eight force a gain
you cannot refuse** (`b9_055`, `b9_071`). `b9_072` is the third gain-shaped one
and is the same argument as `b7_073` and `b8_072`: a forced drop in cops is not
a strictly better side, because cops empty is `BENEATH NOTICE`. Vice nets came
in at family −7, commission −8, cops +14, cash −16, all inside ±30.

### Suppression variants

| Variant | Replaces | Gate |
|---|---|---|
| `b9_096` Concetta on two stones she cannot say anything at | `b9_015`–`b9_018` and every Sally card | `sally_dead` |
| `b9_097` Canarsie standing about at the club with nobody to hand it to | `b9_017`, `b9_087` and the Saturday-ruling cards | `sally_dead` |
| `b9_098` Bushwick's three men, none of whom has said the word capo out loud | `b9_025`–`b9_027` and every Duke card | `duke_dead` |
| `b9_099` four men north of the parkway who each think they inherit a conversation | `b9_043`, `b9_044` and every Wills card | `wills_dead` |
| `b9_100` Lucia telephoning on Sundays, and a name neither woman says | `b9_092`, `b9_093` and every Matty card | `matty_dead` |

`b9_098` and `b9_099` are the second and third readers batch 8's open-threads
list asked for on `duke_dead` and `wills_dead`.

### Flags

**Twelve new**, all chain flags, all in flag-registry.md and in
`GameFlags.chainFlags`: `sally_told_them`, `sally_door_asked`, `sally_thursday`,
`house_kept`, `house_named`, `linen_return`, `return_signed`,
`angelo_asked_chair`, `braca_called`, `local_wound_up`, `matty_asked_out`,
`pinto_asked_winter`.

**No new world or character flags.** Batch 9 gives the first setter to
`sally_dead`, which had none anywhere and was the last such flag in the deck.

**Reads that earlier batches set, through `requires.flags`** (24):
`adler_legit_front`, `angelo_paid`, `at_war`, `aurelio_dead`, `aurelio_doubted`,
`braca_owes_you`, `braca_sponsor`, `colla_roof_paid`, `colla_warned_you`,
`concetta_silent`, `docks_taken`, `duke_dead`, `duke_dope`, `fallon_squeezed`,
`feds_active`, `giulia_lied_to`, `giulia_shielded`, `kiernan_price_up`,
`matty_dead`, `matty_killed_wrong`, `ranieri_watching`, `sally_faction`,
`wills_dead`, `wills_stopped_paying`. Counting `excludesFlags` as well the
figure is **49**.

**Overhang: 24 pre-existing flags read against 12 new flags created.**

**Both add and remove cards this batch:** thirty distinct flags appear in an
`excludesFlags` somewhere in the batch against thirty-six set.

**`sally_faction` was moved from depth 2 to depth 1, deliberately.** The
reservation required the arc to be built on the flag that already existed, and
that flag's five setters were all themselves gated, so the opener would have sat
at depth 2 — the exact defect the gating metric exists to find, on the batch's
spine. `b9_015` and `b9_017` are ungated Sally cards whose right and left sides
respectively set it, which is what the flag already means: the crews routing
through his kitchen *is* the count starting. This is the `b8_100` fix applied
before the fact rather than after — **make the state reachable, do not re-gate
the card.** Measured effect under random play against the real 900:
`sally_faction` goes from 6.4% of runs to **10.6%**.

### Gating depth

**0 at depth ≥ 2 of 24 counted, plus 20 exempt.**

| | |
|---|---:|
| gated cards, all kinds | 44 |
| exempt: chain follow-ups | 12 |
| exempt: suppression variants | 5 |
| exempt: gated on a death or departure flag | 3 |
| **counted** | **24** |
| **counted, at depth ≥ 2** | **0** |

The counted twenty-four are the twelve flag-aware standalones that are not
death-gated, the five gated vices, and the seven gated chain openers — included
on batch 8's reasoning that an opener's gate is as freely chosen as a
standalone's. Every one is depth 1.

**The exempt pile shrank.** On batch 8's own accounting — variants and
death-gated standalones only — batch 8 had 11 and batch 9 has 8. The three
death-gated standalones are `b9_056`, `b9_057`, `b9_058`, all `aurelio_dead` at
depth 4, and they are the **post-Aurelio cap's** three, from the Concetta, Sally
and Adler allocations exactly as cast.md requires.

### Cast coverage

`AURELIO` 12, `GIULIA` 12, `UNCLE SALLY` 10, `MATTY` 8, `DUKE` 6, `ADLER` 6,
`CAPT. KIERNAN` 5, `DET. RANIERI` 5, `CONCETTA` 5, `ANGELO` 4, `FALLON` 4,
`DON BRACA` 4, `MOE WILLS` 4, `ROSA` 3, `FATHER COLLA` 3, `DR. NARDI` 1,
reserve 8.

**This is batch 8's computed allocation hit exactly, all seventeen figures**, so
every speaker lands precisely on its 900-card budget with zero cumulative drift.
`DR. NARDI` at 1 closes the last outstanding case, from +5.0% at 800 to 0.0%.

### Blood

19 of 100, budgeted at the chain level and decided before any card was written.
**Seven of the nineteen are in the chains**, across the three arcs chosen up
front to spend the house: `b9_078`, `b9_079` (the last table), `b9_080`,
`b9_081`, `b9_082` (what it cost) and `b9_092`, `b9_093` (the boy at the door).
Three arcs, against batch 8's four cards in a single arc and batch 7's seven.
That clears the constraint batch 8 set for this batch. Giulia speaks ten of the
nineteen, Concetta and Matty three each, Sally two. **No Rosa card costs
blood**, per her entry.

**Two of Giulia’s twelve were rewritten after the batch was otherwise done**,
and the reason is worth keeping. She had twelve cards and every one of them cost
blood, which meant there was no scene in the deck where being married to this man
is simply a fact rather than a bill. `b9_011` is now an evening and a telephone
off the hook — the decision is whether the boss is reachable, and it costs no
blood at all. `b9_013` is now her *asking* rather than paying: four years of
Sunday meetings in the room her children eat in, and a request for a room that is
not that one (it keeps the `giulia_shielded` setter, which is exactly what the
ask means). The two blood costs moved to cards that had earned them and did not
carry them — `b9_016` right, humiliating the player’s father’s brother in front
of men, and `b9_023` left, leaving the player’s sister’s house under watch — so
the batch still ships 19. **Ten of twelve hurts more than twelve of twelve.**

`b9_079` is one of the deck's few both-sides blood cards, and deliberately: the
uncle dies whichever way the player swipes, and the choice is only whether he is
guarded or left his own Thursday.

### Balance

Written against **No directional bias** from the first card, then corrected in
three passes, numbers only — no text, label, flag, weight, blood value or sign
changed:

| | first draft | after hand pass | after earning pass | shipped |
|---|---:|---:|---:|---:|
| family net | +19 | +14 | +14 | **0** |
| commission net | +61 | +35 | +35 | **0** |
| cops net | +69 | +80 | +80 | **−2** |
| cash net | −134 | −67 | −25 | **0** |
| 5–12 band | 95.8% | 95.8% | 91.2% | 87.8% |
| 1–4 band | 0.2% | 0.3% | 3.7% | 7.1% |
| 15–25 band | 4.0% | 4.0% | 5.1% | 5.1% |
| 13–14 gap | 0 | 0 | 0 | 0 |
| inert sides | 0 | 0 | 0 | 0 |
| garnish sides | 0 | 0 | 0 | 0 |
| vice net, worst meter | −16 | −16 | −16 | −16 |

**The cash pull arrived again, at −134**, and the diagnosis was word for word
batch 7's and batch 8's: thirteen sides were charging cash for something that is
not an outlay — *put somebody on the school*, *find out whose car*, *tell him he
did well*, *take the hour*, *ask her what she needs*, *four men on that kitchen*.
**A ruling, a visit, an instruction and an errand are not payments.** Those went
to 0 and the loss moved to family, commission or cops. That pass alone is +67
cash.

**The second pass is the one worth recording, because the first attempt at it
was wrong.** A single scale factor per meter per direction closed every net to
zero, but it did so by scaling cash lowers by **0.61** — and at that factor
twenty of the twenty-nine cash costs landed on exactly −5. Buying a building,
paying the Kiernan ratchet and sending flowers to a parish all cost the same, and
on `b9_032` — *I can have it be a robbery, or a robbery in the Seven-Five; one of
those costs more* — **both sides came out at −5, which is the card's own line
contradicted by its numbers.** The brief says balance is corrected by re-pointing
numbers and never by making a card's fiction untrue, so the factor was rejected
rather than accepted.

The real defect it was papering over is that **batch 9's fiction spends far more
than it earns** — a batch of deaths, obligations and endings has few earners in
it. So fifteen sides where money genuinely arrives and the card was silent about
it, or was understating a lump sum, were written up instead: a new man with a
truck, four no-shows actually working, the house rake off a man losing badly, a
collection resumed, a hospital contract that doubles what the company shows.
Three single-arrival lump sums were promoted into the heavy band, where the
15–25 share had room — eleven months of arrears collected at once, a route sold
for more than it earns, eleven thousand out of a welfare fund. Scale factors were
then bounded to **[0.85, 1.35]** so no card could be flattened again, and every
meter still closes to exactly zero: family raises ×0.93, commission raises ×0.93
/ lowers ×1.19, cops raises ×1.07 / lowers ×1.25, cash raises ×1.04 / lowers
×0.92. `b9_032` ships at −8 against −4, with cops −11 against +7.

**The 1–4 band was placed, not scaled into**, as batch 8 did: pairs matched
within a meter *and* within a magnitude so each pair's two changes cancel
exactly, and only ever on a side already carrying a 7-or-more on another meter or
whose real cost is blood. `DeckBalance` reports **zero garnish sides** and the
band lands at 7.1%.

### Wiring — done, in the same pass

1. **Done.** The twelve chain flags are in `GameFlags.chainFlags`
   ([flags.dart](../lib/flags.dart)) under a `// batch 9` comment.
2. **Done.** `assets/cards/batch_9.json` is in `CardRepository.deckPaths`
   ([card_repository.dart](../lib/card_repository.dart)).

`flutter test`: **130/130**, over the complete 900 cards, including
`shipped batch deck` and `deck_balance_test` per batch.

### Known layout constraint — batch 9

Median text length 206 characters, longest 219, inside the envelope batches 1–8
were measured against. Fourteen cards were over it on the first draft and were
trimmed; the batch-2 note still stands and no card was shortened to chase the
short-screen portrait problem.

### The finding batch 9 leaves behind — late deaths barely land

Measured over the real 900 with a throwaway harness driving the real
`GameState`, 2,000 random runs:

| | share of runs |
|---|---:|
| `giulia_shielded` reached | 22.1% |
| `sally_faction` reached | 10.6% |
| `matty_asked_out` — the batch's one **flag-free** opener | 4.8% |
| `duke_dead` (batch 8) | 1.8% |
| `sally_dead` (batch 9) | **0.3%** |
| `wills_dead` (batch 8) | 0.1% |

**Once a gated chain opens it completes** — `sally_told_them` and `sally_dead`
are both 0.3%, so the queue does its job perfectly. The bottleneck is entirely
the opener being *drawn* in the window where its gate is satisfied, and it has
got worse as the deck grew: an opener at weight 13–14 now competes against 900
cards instead of 400.

The comparison that makes it concrete is inside this batch. `b9_092`, the one
flag-free opener, opens in **4.8%** of runs. The seven gated openers average well
under 1%. Gating an opener costs roughly an order of magnitude in reach.

**Nothing was changed for it, on purpose.** The three available levers are all
closed: deck logic is not this batch's to touch, opener weight is fixed at 13–14
by the brief (the Sally opener sits at 14, the top of its band), and ungating the
arc would have broken the reserved-thread rule that says build on the flag that
exists. `sally_faction` was made depth 1 instead, which is the one move the rules
did allow, and it bought 6.4% → 10.6% on the gate.

**This is a question for the human playtest, not for another sweep** — batch 5's
decision stands and no magnitude, draw weight or vice quota was touched. But it
should be stated plainly: **the deck's most effortful late writing — three named
deaths across batches 8 and 9 — is reached by fewer than two runs in a hundred.**
Whoever picks this up after the playtest should decide whether the late arcs want
a delivery rule of their own rather than a gate.

### Threads left open by batch 9

The deck is complete at 900 cards. What remains is not writing.

- **Every flag in the registry now has a setter**, and the deck-wide count of
  flags set and never read is 0. Two flags — `angelo_dead` and `sally_moved` —
  are read only through `excludesFlags`, which is the job they exist to do.
- **`GameFlags.runFlags` and `deckFlags` can now be folded together.**
  [flags.dart](../lib/flags.dart) says so in its own header: the two sets are
  separate only because `runFlags` carries a test contract that every one of them
  be settable by some card, and that could not hold until all nine batches
  existed. It holds now.
- **The under-read table has six rows left**, down from fourteen at 800, and
  none is worse than 2 readers: `concetta_silent` 9/2, `sally_faction` 8/2,
  `aurelio_doubted` 8/2, `concetta_blessing` 7/2, `wills_stopped_paying` 7/2,
  `braca_owed_him` 5/1. `braca_owed_him` is the only one still on a single
  reader.
- **The playtest is built and not yet run.** The session is written up in
  [playtest.md](playtest.md): four runs, three of them unguided, the cast
  question between one and two, the blood question asked without naming it, the
  trace read only after they have talked, and a seeded burn run last and scored
  separately. Two hooks were added for it in
  [playtest.dart](../lib/playtest.dart) — a silent per-swipe trace that prints
  to the browser console and never to the screen, and an RNG seed — both off
  unless a URL parameter turns them on, both covered by
  [playtest_test.dart](../test/playtest_test.dart). **Seed 100** is the burn
  seed: of 4,000 searched by [burnseed.dart](../test/burnseed.dart) it is the
  only one where `b6_076` opens under all 27 play policies tried, completing
  under 24, so the last run does not depend on how the participant plays.
- **The human playtest is now unblocked and is the next thing that happens.**
  What gets played is the deck batch 5 settled plus four hundred cards. The two
  questions it owes an answer to are the standing one — *was there anything you
  were running out of?* — and the new one above, whether a late arc that lands in
  one run in three hundred is worth what it cost to write.
- **`endings.json` is still eight paragraphs written before any card existed**,
  and per *The meters, not the endings* it is revisable up to release prep. It
  should now be rewritten by somebody who has played the finished deck.

---

---

## The commission travel pass — after batch 9

**Two of the eight endings were gated behind a meter that barely moved.** Over
2,000 random runs against the full 900, `SANCTIONED` fired in 1.9% of runs and
`THE ERRAND BOY` in 1.4%, while the top three endings took 74% between them.
This is the same class of defect as the chain-reach problem: content that exists
and cannot be reached.

### The diagnosis, which ruled out both obvious causes

| hypothesis | test | result |
|---|---|---|
| commission is assigned **timidly** on cards that use it | mean \|Δ\| when it moves | **6.03**, against family's 5.98 — not timid |
| the **content** rarely concerns the other families, so it is never relevant | of the 102 cards whose text concerns standing, how many move commission | **86%** already do — not neglected |

Thirteen of the fourteen apparent exceptions were a regex misfiring on *this
city*, *the table* (Giulia's dinner table) and *Ozone Park* (her sister's
address). Where the content is there, the numbers were already there.

**The real cause is a third thing: only 102 of 900 cards concern the other
families at all.** The deck is overwhelmingly about the family's interior — the
house, the children, the police, the money — and that is a legitimate authorial
choice across nine batches, not a defect. The speaker table shows it cleanly:
`DON BRACA` moves commission on 100% of his cards and `MOE WILLS` on 83%, while
`ADLER` is 16%, `CAPT. KIERNAN` 18%, `ROSA` 16% and `DR. NARDI` 7%. Those are
the domestic and procedural voices, and forcing standing onto the bookkeeper and
the restaurant owner would have been writing fiction to hit an arithmetic
target — which the brief forbids.

**One real timidity did show up**, and it was in the low band: commission
carried **19%** of its deltas in 1–4, nearly double any other meter (family 11%,
cops 9%, cash 12%).

### The fix, and why magnitude rather than coverage

Random-walk displacement scales **linearly with step size and only with the
square root of the count**. So lifting the mean from 6.0 to ~9 buys the same
travel as doubling the number of commission-moving sides, without touching a
line of fiction. Numbers only:

- every non-vice commission delta scaled ×1.5 and clamped into **5–12**, which
  also promotes the 1–4 timidity out of the invisible band;
- **vices untouched** — their magnitudes are prescribed;
- any card where scaling would have tripped the validator's undeclared-vice rule
  is skipped (zero cases arose);
- a correction pass then nudged single deltas by 1, inside 5–12, until every
  batch's commission net sits at **≤ ±10**.

Result: **733 sides unchanged, mean \|Δ\| 6.03 → 8.79.** No text, label, flag,
gate, weight or blood value changed, and no other meter was touched.

### What it bought, measured the same way

2,000 runs, random play, full 900:

| ending | before | after |
|---|---:|---:|
| `THE INDICTMENT` | 28.0% | 26.5% |
| `THE VOTE` | 24.6% | 21.6% |
| `THE PAPERWORK` | 21.4% | 19.4% |
| `BAD PAYDAY` | 8.8% | 8.5% |
| **`SANCTIONED`** | **1.9%** | **7.1%** |
| **`THE ERRAND BOY`** | **1.4%** | **6.3%** |
| `BENEATH NOTICE` | 8.3% | 5.8% |
| `THE STATUE` | 5.6% | 4.8% |

Top-three concentration **74% → 67.5%**, and the two commission endings move
from statistical curiosities into the same band as the other minor endings.
Measured by [endingfreq.dart](../test/endingfreq.dart), which drives the real
`GameState` and is kept as an instrument.

### The endings rewritten — after batch 9

**Median run under random play is 23 swipes.** The endings were written before
any card existed and narrated a reign of decades: `BENEATH NOTICE` opened on
*three years without an arrest* and `THE INDICTMENT` on *you ran hot for years*,
both delivered after a couple of dozen cards. All eight were rewritten to a
season rather than a decade, keeping the titles, the meanings and the
quote-ending style — every one still closes on its hard line (*the vote is
unanimous and it does not take long*; *forty-one names, and yours on the first
page*).

One incidental correction: `THE INDICTMENT` named **RICO**, which was not law
until October 1970 and sat awkwardly against cast.md's 1963–72 window and its
rule that no card states a date. It now says *they*.

### One process note worth keeping

The scaling script wrote its files inside the scaling loop *and* threw before
the correction pass, and a follow-up diagnostic run then scaled the
already-scaled deck a second time — commission reached a mean of 11.4 and batch
3 a net of +102, outside the ±50 limit. It was recovered from
`build/unit_test_assets`, which `flutter test` refreshes and which therefore held
the once-scaled deck with all the Aurelio and item-2 content work intact;
`build/web` was checked first and rejected as stale. **A numbers pass should
write once, at the end, after every correction — never inside the loop that
computes it.**


---

---

## The guard, and items 3, 5 and 6 — after batch 9

### `tools/verify_deck.js` — the balance check as its own step

The commission pass proved that **a deck can be structurally perfect and
numerically ruined, and a stale green will hide it**: `flutter test` reported
140/140 shortly before a second accidental write pushed batch 3's commission net
to +102. The suite was never wrong; it was run at the wrong moment.

So the balance rules now also live in a standalone, zero-dependency script that
reads the files **on disk**, runs in under a second, and exits non-zero on any
violation. It deliberately re-implements the `DeckBalance` rules rather than
importing them, so the Dart and the script check each other.

**Run it as its own step after any numbers pass, before `flutter test`.** It was
tested against a deliberately corrupted copy of batch 3 — the exact corruption
that got through — and failed it with `commission net +72, over ±50`, exit 1.

### The anachronism sweep

Prompted by the `RICO` catch in `THE INDICTMENT` (the statute is October 1970,
inside the 1963–72 window but only just, and the deck states no dates). Twenty-two
suspect terms were swept across all 900 cards and the eight endings: **RICO was
the only hit.** `DEA`, `witness protection`, `Amtrak`, `plea bargain`, `911`,
`Miranda`, `computer`, `fax`, `wiseguy` and the rest are all absent. The only
other match was *supermarket*, which is correct for the period and is used in
two cards precisely because a chain displacing local business is the era.

**One doc/deck drift found and corrected.** cast.md said *no card ever states a
year, a date, or a named news event*. **Twenty-six cards state a year** — from
`b1_059` onward, so the practice is as old as the deck — and every one is a past
year between 1946 and 1964, used as backstory. That cannot make two cards
contradict each other, which is what the rule exists to prevent. The rule now
reads *no card states the **present** year*, which is what the deck has always
done and what Aurelio's thirty-year frame depends on.

### Item 3 — Duke

The last voice problem, and the same defect as Aurelio at lower severity. A blind
read identified him only because there was a number in the sentence: **10 of 65
cards (15%) carried any structural move, while 38% contained a figure.**

**His cast entry was the gap.** It named the outcome — *never says no; says sure,
boss, and then does it his way* — without the mechanism that produces it. The
mechanism is **pre-emptive disclosure**: he tells you a thing before you can find
it out, and says out loud what he is *not* asking for, so the framing is his.
*Nobody's asking you to bless anything.* *I'm telling you I worked it out rather
than have somebody tell you I did.* It is how a man in a permanently weak
position takes control of a conversation he cannot win.

That separates him from the other two transactional voices, and the three now sit
on a single axis: **Duke reasons from a transaction already in motion, Adler from
a document that exists now, Moe Wills from a boundary between two houses.** The
rule is in cast.md so it cannot regress.

**24 cards rewritten, text only**, taking the move from 15% to 49% by a
deliberately conservative detector — six further cards were judged to carry it
already and left alone.

### Item 6 — batch 1's mechanical defects

Batch 1 predates every rule the project later wrote and was the only batch
outside three of them. The brief deferred the decision to correct a shipped batch
("a separate decision, not a silent one"); it has now been taken. Numbers only:

| | before | after |
|---|---:|---:|
| deltas in the deliberate 13–14 gap | 8 | **0** |
| blood-free garnish sides | 8 | **0** |
| 1–4 band | 18.8% | **12.1%** |
| 5–12 band | 73.9% | **82.1%** |

The eight gap deltas were all cash and were snapped to 12; garnish sides had
their largest delta promoted to 5; the 1–4 band was brought down in matched
pairs, same meter and same magnitude, so no net moved. It lands at 12.1% rather
than the brief's 10% because the pairing ran out of *anchored* candidates — what
remains is a genuine secondary beside a 5-or-more. **`b1_086` was not touched**:
the one-branch chain is a named legacy exception in the test suite.

The gap is now empty across all nine batches, so `verify_deck.js` carries no
exemption and any delta landing there is a failure.

### Item 5 — the tics

**"eleven" went from 73 cards to 34.** It was the deck's default specific number
and it compounded late (b7 14, b8 11). Cards where the number is load-bearing
were skipped — `b8_053`'s *one of eleven people and all eleven are in that room*
is the card, not a tic — as were cards quoted verbatim in this file, so the
documentation could not go stale.

**The pass then broke eleven cards and had to be partly reverted, which is worth
recording.** A mechanical swap of a cardinal is not safe in four contexts: a time
of day (*eleven in the morning* became *nineteen in the morning*), a sentence
start (*Eleven hundred* became lowercase *nineteen hundred*), a named sum, and —
worst — **a child's age**. `b8_013` made Paolo sixteen, contradicting `b8_085`
and `b4_099`, and **no test in this project would ever have caught it**. All
eleven were restored from the pre-session baseline in `build/web/assets` and are
now on a keep-list.

**"SAY NOTHING" went from seven labels to two.** Six of the seven were
`DET. RANIERI` cards where silence genuinely is the player's move against a
policeman who cannot be bought, which is consistency rather than sloppiness — but
meeting it twice in a 23-swipe run reads as repetition. Five are now other kinds
of silence; the canonical one stays, and `b4_051` keeps it because there it is
the *priest* being told to stay quiet.

**The remaining 64 reused labels are accepted rather than fixed.** `PUT HIM ON`
×5 and `NOT THIS YEAR` ×5 name genuinely identical actions on unrelated cards,
and a deck of 1,800 choice-sides drawn from a small vocabulary of decisions will
repeat a four-word imperative. Label reuse is a much weaker signal than premise
duplication, and forcing variation would produce worse labels, not better cards.


---

## Established backstory — the world's settled facts

Facts about the world that exist outside any one card, that batches 7–9 may
**use** and may not **re-discover**. A card that finds one of these out for the
first time contradicts a card that already knows it, and the deck draws at
random, so both will happen in the same run.

### Don Aldo kept money from the family

**Established in batch 6 at `b6_054`, and deliberately, not as one card's
subtext.** When the old boiler came out of the father's house, the men who
removed it found what he had kept behind it. Concetta counted it and put it on
her kitchen table.

What that fixes:

- **He kept it from everyone**, including Sally, who was his brother and his
  underboss, and including Adler, who has done the family's arithmetic for
  twenty-two years and never saw a dollar of it on a page.
- **It was his own money**, not the street's and not stolen. He did not take it.
  He simply did not tell anybody it existed.
- **Nobody knew until the boiler came out.** There is no earlier card that knew,
  and no later card may claim there was.

Why it is worth having. The whole deck runs on *your father did it this way* —
Sally says it, Concetta says it, Aurelio said it for four batches, and Braca
said it warmly for an hour at a time. Until now that refrain has been
load-bearing and unexamined. This makes the father a man who also kept a private
answer to a question the family thought was settled, and it does it **without
retconning anything**: no shipped card calls him scrupulous, and none has to
change.

**What batches 7–9 may do with it.** Give it to the people it lands on. Sally
finding out his brother had a box he was never told about is a Sally card and
a good one. Adler finding out there was money that never touched a ledger is an
Adler card. Concetta already knows what it says about her marriage and has said
nothing, which is exactly her register. `concetta_dead` still has no setter, and
this is one of the few things only she can carry.

**DELIVERED in batch 7**, `b7_076`→`b7_079`, and to all four of the people named
above in that order. `concetta_dead` got its setter in the same batch
(`b7_088`→`b7_089`) but deliberately *not* in this chain — the mother dying of
the box would be melodrama, and she dies of being eighty. **The discovery is
now closed.** Batches 8 and 9 may refer to the money as a settled fact and may
not find any more of it, per the paragraph below.

**What they may not do.** No second box, no hidden fortune, no map, no chain
that goes looking. It is a fact about a dead man, not a treasure hunt, and the
moment a batch makes it a quest it stops being about the father and starts being
about money.

---

## Documentation audit — run during batch 6, covers batches 1–6

Six hundred cards against four documents. Cheap now, expensive at batch 9, so it
was done at the halfway-plus mark. Method was a script over the six batch files
and the three docs plus [flags.dart](../lib/flags.dart), checking the things
prose drifts on and a test suite does not look at.

### Clean

- **Every flag any card uses is in [flag-registry.md](flag-registry.md) *and* in
  `GameFlags`**, in both directions. No doc-only flags, no code-only flags.
- **The registry's own counts reconcile** — 9 world + 77 character + 72 chain =
  158 active, and the chain tables list exactly 72 rows.
- **No document references a card id that does not exist.** Every `bN_0NN` in
  cast.md, the bible and the registry resolves.
- **Every batch has all three of its doc sections** — cast.md continuity,
  a bible entry, a registry chain-flag table.
- **Every chain flag is set on both sides of exactly one card**, which is the
  batch-1 convention that stops a chain dead-ending on the branch not taken. 72
  for 72.
- **Every composition and blood figure a batch entry claims matches the file.**
  Blood: 19, 19, 18, 18, 9, 19.

### Corrected

Four prose errors, all of the same kind — a count written from memory rather
than from the deck. Each is fixed in place with a bracketed note saying what it
said before, because a silent correction to a historical entry is worse than the
error.

| Where | Said | True |
|---|---|---|
| Batch 2 entry, first setters | "nine flags", listed eleven | **eleven** — and `kiernan_cold` was not one of them; `angelo_dead` was the one missing |
| Batch 3 entry, reads-that-earlier-batches-set | count 23, list of 22 | `kiernan_price_up_2` was missing from the list; **23 is right** |
| Batch 4 entry, never-read-before | "Six of the twenty-one", listed eight | **eight** |
| cast.md, batch 2 | "`kiernan_cold` gets its only setter at `b2_062`" | four setters — `b1_060` was first, then `b2_062`, `b5_096`, `b6_066`. One reader. |

The batch-5 cast.md section was the fifth finding and was already reconstructed
during batch 6 and labelled as such.

### Speaker drift — the one thing batches 7–9 must actually act on

cast.md's check 2 allows local divergence and forbids cumulative: the running
total must stay inside **±10%** of pro-rata. At 600 cards, two are outside it
and one is exactly on the line.

| Speaker | At 600 | Pro-rata | Drift | Needed per 100 in batches 7–9 | Per-batch budget |
|---|---:|---:|---:|---:|---:|
| `DR. NARDI` | 12 | 10.0 | **+20.0%** | 1 | 1.7 |
| `CONCETTA` | 23 | 26.7 | **−13.8%** | 5.7 | 4.4 |
| `MOE WILLS` | 18 | 20.0 | −10.0% | 4 | 3.3 |
| `GIULIA` | 61 | 66.7 | −8.5% | 13 | 11.1 |

All four remedies sit inside the ±40% per-batch tolerance, so no batch has to
distort itself; they just have to be aimed at rather than discovered at batch 9,
when there is no room left to correct. Concetta is the one to watch — she is
also the character the post-Aurelio world and the father's-money thread both
lean on, so the fix and the material point the same way. Nardi simply appears in
one batch of the three and not the others.

Everything else is inside ±10% and needs nothing.

### Batch 7's speaker allocation — aim at this, do not re-derive it

Computed during batch 6 from the drift above. Every figure is inside cast.md's
±40% per-batch tolerance, and the whole column lands every cumulative total
inside ±10% at 700 cards. **It sums to 100.**

| Speaker | Batch 7 | Per-100 budget | Drift at 700 |
|---|---:|---:|---:|
| `AURELIO` | 12 | 12.8 | +0.6% |
| `GIULIA` | **15** | 11.1 | −2.3% |
| `UNCLE SALLY` | 9 | 10.6 | +1.5% |
| `DUKE` | 8 | 7.2 | +0.9% |
| `ADLER` | 7 | 6.1 | +0.5% |
| `MATTY` | 6 | 8.3 | +1.2% |
| `CONCETTA` | **6** | 4.4 | −6.8% |
| `DET. RANIERI` | 5 | 5.0 | 0.0% |
| `CAPT. KIERNAN` | 4 | 5.6 | +2.9% |
| `FALLON` | 4 | 3.9 | −0.8% |
| `DON BRACA` | 4 | 3.9 | −0.8% |
| `MOE WILLS` | **4** | 3.3 | −5.7% |
| `ANGELO` | 3 | 3.9 | +2.9% |
| `ROSA` | 2 | 2.8 | +2.9% |
| `FATHER COLLA` | 2 | 2.8 | +2.9% |
| `DR. NARDI` | **0** | 1.7 | +2.9% |
| *reserve* | 9 | 6.7 | −1.4% |

Four of these are corrections rather than budget, and are bolded:

- **`GIULIA` 15 and `CONCETTA` 6 are both at their ±40% ceiling.** They cannot
  be corrected faster than this, which is the point of doing it now: Concetta
  still ends batch 7 at −6.8%, and only finishes inside tolerance if batches 8
  and 9 also run her at 5–6. She is the deck's most under-served voice and the
  one the post-Aurelio redistribution, the father's-money thread and
  `concetta_dead` all need.
- **`MOE WILLS` 4** is also at his ceiling and also needs 8 and 9 to hold it.
- **`DR. NARDI` 0.** He is the only speaker *over* budget (+20% at 600) and
  cast.md rule 1 explicitly allows him zero in a batch; rule 3 lets him go two
  batches dark and he spoke twice in batch 6. Writing him again in batch 7 is
  what makes the overhang permanent.

Batch 8 should re-run the audit script rather than trusting this table, because
batch 7 will not hit it exactly.

---

## Chain delivery — rebuilt after batch 6

### The defect

A follow-up at draw weight 45 competed against 364 cards eligible at swipe one,
total weight 3602. Measured against the real 600:

| | |
|---|---:|
| a given flag-free standalone appears in a 35-swipe run | 8.4% |
| a given **chain opener** appears | 11.9% |
| a six-beat burn reaching its **third** beat | ~1% |
| a six-beat burn **finishing** | ~0.1% |

**The most effortful writing in the deck was unreachable.** Not rare —
unreachable. That is not a delivery problem, it is wasted writing, and it was
found by arithmetic rather than by playing, which is why it survived six
batches.

### Why not weight

Weight expresses *more likely*. An opener is a promise, and a promise needs
*next*. Raising follow-ups to 90 would still leave them competing against 364
cards, and it would distort every other figure in the deck to buy a fraction of
what was needed. `GameState.recentWindow`'s own comment already says it: in a
deck near the window size, recency and not weight decides most draws.

### The mechanism

`"chain": {"id": "<opener's id>", "beat": n}` on every beat, and in
[game_state.dart](../lib/game_state.dart):

1. A resolved beat **pins its successor**, which is then dealt after a gap of
   **two or three ordinary cards**, drawn per beat so the rhythm cannot be
   learned.
2. **One chain in flight.** While a beat is pending, no other chain's opener is
   drawable. Without this the measured 5.6 openers per run would make every
   third card a beat and starve the flag-free backbone.
3. **A follow-up only ever arrives through the queue** — it is out of the
   ordinary pool entirely. It was unreachable before its opener anyway, so this
   costs nothing and stops a beat arriving out of pace or being spent early.
4. **Eligibility is re-checked at delivery.** `requires.flags` cannot stop being
   satisfied — nothing clears a flag — but `excludesFlags` can newly become
   true, and a contradicted beat is **dropped, not deferred**: firing it later
   only makes it more wrong. Drops are counted, not swallowed, because a chain
   dying silently is the failure that took four batches to notice last time.
5. **A forced opener** if no chain has opened by swipe five. The queue fixes
   completion; this fixes reach. Without it most runs still contained no chain.

Everything is run-scoped and cleared by `restart()`.

### Why the key, and not inference

Inference was tried first and is unsafe. The only signal in the data is *this
card sets flag F on both sides*, and that **misfires on 18 of 87 both-sides
flags**, because character and world flags are deliberately set on both sides
too — *the dying is the event, the choice is only what you do about it.*

- `aurelio_dead` is required by five suppression variants. An inferring queue
  delivers the entire post-Aurelio budget as a five-card cutscene the moment the
  consigliere dies.
- `books_open` feeds four gated standalones, `feds_active` three.
- **Eleven flags are read by more than one card**, so "the successor" is not
  even singular in the data.

A separate manifest file was the other option and lost on the project's own
history: a second file to keep in sync is exactly what went wrong three times
already.

### What it measured

1,000 runs per policy against the real 600 cards, driven through the **real**
`GameState` by [test/simulate.dart](../test/simulate.dart) so the harness cannot
drift from what ships. *Before* is the same code with the `chain` keys stripped,
which reproduces the old draw exactly.

| Random floor (the honest one) | before | after |
|---|---:|---:|
| median run length | 27 | 28 |
| p10 / p90 length | 12 / 58 | 13 / 60 |
| **chains opened per run** | 0 | **2.64** |
| **chains completed per run** | 0 | **2.18** |
| chain beats as a share of cards seen | 0% | **19.3%** |
| six-beat burns completed, per 1,000 runs | ~1 | **59** |
| beats dropped as contradicted, per run | — | 0.048 |
| vices met per run | 2.37 | 2.24 |
| blood at death (mean) | 78.0 | 75.5 |

Completed chains by length across 1,000 random runs: **2-beat ×1246, 3-beat
×689, 4-beat ×190, 6-beat ×59.**

| Greedy oracle | before | after |
|---|---:|---:|
| survives to the 500-swipe cap | 953 / 1000 | 919 / 1000 |
| chains completed per run | 0 | 20.7 |
| beats dropped per run | — | 3.27 |

*(The oracle here is a fresh implementation, so 953 is not comparable to the 848
batch 5 recorded. Only before-versus-after within this harness is meaningful.)*

### The three things that were to be flagged, checked

- **No ending went unreachable.** All eight are reached under random play, both
  before and after.
- **No cause of death passes 25% under random play.** `cops.full` was the one to
  watch and it *improved*, 25.1% → 23.6%. Under the greedy oracle `cash.empty`
  is 44% and `cops.full` 28% — but the oracle dies 81 times in 1,000, so that is
  81 deaths' worth of spread, and both figures were higher before the change.
  Not a regression.
- **Chain beats are 19.3% of a median run**, against the one-third ceiling. The
  flag-free backbone still carries four cards in five.

### Two findings that came out of the work

- **`b1_086` sets its gate on one branch only.** Refuse Kiernan and "The raise"
  dead-ends — the follow-up can never arrive. It predates the *opener sets its
  chain flag on both sides* convention. It ships as a named legacy exception;
  the test now fails any new chain that does this.
- ~~**Only two of the three heirs are reachable.**~~ **Wrong, and corrected
  below in *Blood and succession*.** All three fired; the measuring instrument
  keyed the heir on its *name*, and the loved son and the hated son are the same
  boy — both are `NICKY` — so two of the three outcomes were being silently
  merged into one row. The real split at the shipped thresholds was 80.5% /
  17.0% / 2.5%, which is a badly skewed mechanic rather than a dead one. The
  harness now keys on `HeirKind`.

### Legacy exceptions — do not copy these shapes

| Chain | What | Why it ships as-is |
|---|---|---|
| `b3_076` *The two doors* | six beats | 16–21 swipes of a 28-swipe median run. A rare over-long storyline beats a rewrite. |
| `b6_076` *Lucia's boy* | six beats | as above |
| `b1_086` *The raise* | gate set on one side only | batch 1 predates the convention; the left branch simply ends |

All three are named in `card_deck_test.dart` so the rules they break are still
enforced for everything else.

---

## Blood and succession — re-derived after batch 6

Blood's only consumer is the heir. If the thresholds do not split the
population, most of what blood does is invisible, and at the shipped 60/20 they
did not: **80.5% loved son, 17.0% stranger, 2.5% hated son** across 1,000 random
runs. Measured by [test/blood.dart](../test/blood.dart).

**The old constants reasoned from the placeholder deck.** Their comment said
"ten of twenty-three cards can cost blood" — that was `core.json`, at a blood
rate of 43%. The real 600 carry blood on 102 cards, 17%, so the thresholds were
calibrated against a deck four times bloodier than the one that ships.

### First: does blood record how you played, or how long you lasted?

Asked before touching the constants, because thresholds cannot fix the second.
**It records how you played.** Three lines of evidence:

| | |
|---|---:|
| cards with blood on **one side only** — avoidable by choosing | **94** |
| cards with blood on **both sides** — unavoidable | 8 |
| cards with no blood at all | 498 |

Blood lost **per swipe**, by policy, at essentially identical median run length
(28 / 28 / 27):

| policy | median length | mean blood at death | blood lost per swipe |
|---|---:|---:|---:|
| restraint (always takes the cheaper side) | 28 | 96.6 | **0.103** |
| random | 28 | 75.5 | 0.741 |
| spendthrift (always takes the costlier side) | 27 | 58.1 | **1.311** |

A **12.7× spread** between restraint and spendthrift with run length held
constant. And under random play, run length explains **r² = 0.449** of the
variance in blood lost — under half. Within a single narrow band of run lengths
the spread stays wide: runs of 26–32 swipes end anywhere from 59 to 94 blood at
the tenth and ninetieth percentiles.

So the heir rewards restraint, not dying early, and thresholds are the right
instrument.

**One honest caveat.** At the extreme, length does take over: the greedy oracle
loses only 0.206 blood per swipe but plays 500 of them, and ends at a mean of
15.7. A father who reigns that long leaves the hated son almost regardless — 95%
of the oracle's deaths. That reads as correct rather than broken (a very long
reign has spent the family), and it applies to a policy that survives 92% of its
runs, so no human meets it.

### The distribution the thresholds had to split

Blood at death, random play, 1,000 runs, by decile:

```
  0   47   60   69   75   81   84   91   92   100   100
```

Note the top two deciles: **a fifth of runs end with blood untouched.**

### The new constants

**`lovedThreshold` 60 → 88. `strangerThreshold` 20 → 70.**

| | lovedSon | stranger | hatedSon |
|---|---:|---:|---:|
| shipped 60 / 20 | 80.5% | 17.0% | 2.5% |
| exact thirds of the distribution, 89 / 71 | 33.7% | 33.9% | 32.4% |
| **chosen, 88 / 70** | **34.3%** | **34.5%** | **31.2%** |

88/70 is within half a point of the exact-thirds cut and is two round numbers a
reader can hold. The distribution did not argue for anything other than thirds:
it is broad and smooth between 47 and 92, with the only lump at the top.

Measured against the other two policies at the same constants — the check that
the bands mean something rather than merely being equal-sized:

| policy | lovedSon | stranger | hatedSon |
|---|---:|---:|---:|
| restraint | 85.1% | 14.5% | 0.4% |
| random | 34.3% | 34.5% | 31.2% |
| spendthrift | 16.0% | 25.9% | 58.1% |

A player who never spends blood gets the loved son five times in six; a player
who always spends it gets the hated son more often than not. That separation is
the mechanic working.

### Two things for the playtest, and one for batch 9

- **These are calibrated on random play**, which is the floor rather than a
  human. A careful player loses blood more slowly and will skew toward the loved
  son; the playtest question *"was there anything you were running out of?"* is
  the one that tells us whether any of this is perceptible at all.
- **The queue moved the distribution slightly.** With the same 88/70 thresholds,
  the pre-queue deck gave 39.5 / 34.0 / 26.5 and the queued deck gives
  34.3 / 34.5 / 31.2 — chains carry blood, so delivering them reliably spends
  more of it. Any future change to chain delivery should re-run this.
- **No card's blood value was touched**, and none should be to hit these
  numbers. Blood lands where the content puts it and is budgeted at the chain
  level from batch 6 onward; the thresholds move to fit the deck.
