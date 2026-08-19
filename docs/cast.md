# The Cast

**STATUS: APPROVED.** Retroactive from batch 1 — six batches and six hundred
cards were written against this file, the cast works, and the draft banner was a
stale artefact rather than an open question. Approved during batch 6. The file
is still *live*: a batch that evolves a character updates their entry and adds a
*What batch N changed* section, exactly as before. Approval settles who these
people are, not that they have stopped happening.

This is the permanent cast. Sixteen people the player knows by name. The same
uncle every time, the same wife, the same captain on the payroll.

The whole point is recognition. By card two hundred the player should read
`UNCLE SALLY` at the top of a card and feel something before the sentence
lands. That only works if these names carry across the entire 900 and nothing
else competes with them for the top of the card.

---

## The setting

**New York. Brooklyn — Bushwick and the Ridgewood line. The late sixties.**

The window is roughly 1963 to 1972. **No card ever states the *present* year, a
date, or a named news event.** Cards are drawn at random
([game_state.dart](../lib/game_state.dart)), so there is no chronology to be
consistent with. The decade is texture, not a timeline. Write everything in a
continuous present.

**Past years are allowed and are used, which this file denied until batch 9.**
Twenty-six cards across all nine batches name a year between 1946 and 1964 —
from `b1_059` onward, so the practice is as old as the deck. Every one of them
is backstory: *the club has been open since 1948*, *your father bought those
shares in 1955*, *we used a boy on a bicycle in 'forty-six*. That does not fix
the present and so cannot make two cards contradict each other, which is what
the rule exists to prevent. **The rule is therefore about the present only**, and
the absolute wording was doc drift, found during the anachronism sweep.

A dated past is in fact load-bearing for `AURELIO`, whose voice is a frame
thirty years out of date — see his entry.

What that texture is:

- Valachi has talked. The thing has a name now and the government says it out
  loud. Everyone in this cast has an opinion about that and most of them are
  frightened.
- The neighbourhood is turning over. Italians are leaving for Long Island and
  Jersey. The people moving in do not owe your father anything.
- The Brooklyn piers are dying — containers, and the freight is going to
  Newark. The airport is where the money moved to.
- The Commission still meets, still matters, and is mostly a body of old men
  trying to stop anything from happening.

**Scale.** Mid-sized family. Around sixty made men across three crews —
Bushwick, Canarsie/waterfront, Ridgewood-Maspeth. Big enough that you don't
know every soldier's name; small enough that losing one capo is a wound, not
a line item.

**The money.** Numbers, shylocking, a garment-trucking outfit, vending
machines, an ILA local on the Brooklyn piers, airport freight, and a linen
supply company that is very nearly legitimate.

### The fault line: safety

Every serious argument in this cast reduces to one question — **how much
exposure is the money worth.** Not morality. Survival.

- **Narcotics** is the sharp end. The old guard forbids it because it carries
  life sentences, and a man facing life talks. The young earners are doing it
  anyway, because it is the only place the money grew.
- **Going legitimate** is the quiet end. Slower, safer, and the old guard reads
  it as a man who won't earn.

The uncle thinks the player is soft. The accountant thinks the player is slow.
Both of them are arguing about the same thing.

---

## The player

**Nicola "Nico" Marchetti.** Took the seat in his mid-thirties when his father,
Don Aldo, died in his own bed — leaving it to his son over his own brother.
That single fact is the engine of half this cast.

Forms of address, which matter and should stay consistent:

| Who | Calls him |
|---|---|
| Giulia, Aurelio | Nico |
| Concetta | Nicola |
| Sally | *kid*, or *Nicoletto* when he wants it to sting |
| Everyone else | Don Marchetti, or boss |

(Name is changeable — say the word and it changes everywhere before batch one.)

---

## Hard rules for the cast

1. **Speaker strings are exact.** Use the canonical string in the table below,
   character for character. `UNCLE SALLY`, never `SALLY` or `UNCLE SAL`. The
   whole recognition effect dies to inconsistency.
2. **The silenced do not speak.** Every character has a *silence flag* — dead,
   gone, or run — listed in [flag-registry.md](flag-registry.md). Every card
   spoken by that character must carry **all** of their silence flags in
   `requires.excludesFlags`. No exceptions, and the deck validator should be
   taught to enforce it.

   Two deliberate exceptions. **Giulia has no silence flag** — she cannot be
   written out, and `giulia_left` changes where she speaks from, not whether.
   Killing the player's wife is an ending, not a card state. **Sally's
   `sally_retired` is not silence either** — a man sent to Florida still calls.
3. **No walk-ons at the top of a card.** If a voice is needed once, it speaks
   through a cast member or through the reserve voices (below). A named person
   who appears in one card does not go in this file and does not get a flag.
4. **Off-stage names are not cast.** Some relations are named for consistency
   and never speak — see the appendix. They may be referred to; they may not
   be a `speaker`.
5. **Stay inside the budget.** Every batch checks itself against the table at
   the bottom before it ships.

---

## The sixteen

### The blood

---

#### 1. Salvatore "Sally Doors" Marchetti — `UNCLE SALLY`

**Role.** Underboss. Your father's younger brother. Passed over for the seat
and kept the number two, which makes him both necessary and permanent.

**Wants.** To be consulted before you decide, not after — and, underneath
that, to hear you admit the wrong man is sitting in the chair.

**Talks.** Short sentences, all of them about the past. Never asks a question
he doesn't have the answer to. Calls you *kid* in front of other people.

**Dangerous / useful.** He knows every man in the family personally because he
put most of them there. He cannot be removed without splitting the house, and
he knows it. Useful when you need something done the old way and no questions
raised. Dangerous every other minute of the day.

**Running state.** `sally_humiliated`, `sally_backed`, `sally_faction`,
`sally_moved`, `sally_retired`, `sally_dead`

---

#### 2. Giulia Marchetti — `GIULIA`

**Role.** Your wife. A pharmacist's daughter from the next parish over. Not in
the business and entirely aware of the business — she married you knowing
exactly what you were, which is why she has never once accepted "don't ask."

**Wants.** The children out of it. Not out of the house, out of the *life* —
and she has a specific idea of what that would take.

**Talks.** Plainly, and at the worst possible moment. Does not raise her voice.
Asks the one question you were hoping nobody would ask, then waits.

**Dangerous / useful.** **Most of the blood cost runs through her.** She is
where a killing is paid for. Not as a reaction shot — she names the widow, she
knows what the funeral cost, she knows which child is now fatherless. If the
blood counter is the game's conscience, Giulia is its voice. Use her hardest
after the player has done the pragmatic thing and got away with it.

**Running state.** `giulia_told`, `giulia_lied_to`, `giulia_shielded`,
`giulia_home_touched`, `giulia_left`

---

#### 3. Concetta Marchetti — `CONCETTA`

**Role.** Your mother. Don Aldo's widow. Sally's sister-in-law, and the only
person alive who outranks both of you.

**Wants.** The name to survive her. She is not sentimental about you
personally; you are the vessel it is currently in.

**Talks.** In blessings that are instructions and instructions that sound like
blessings. Brings up your father in every conversation, accurately.

**Dangerous / useful.** She can end an argument in the family with a sentence.
She can also side with Sally — and if she ever does, publicly, the house tilts.
Her approval is the only thing that makes a hard decision feel legitimate.

**Running state.** `concetta_blessing`, `concetta_sided_sally`,
`concetta_silent`, `concetta_dead`

---

#### 4. Mattia "Matty" Ricci — `MATTY`

**Role.** Your nephew. Your sister Lucia's boy, early twenties, around the club
since he was fifteen and not made.

**Wants.** To be made, and to be told he did well. In that order, and he'd
trade the first for the second.

**Talks.** Too much and too fast. Repeats things he's heard older men say,
slightly wrong. Says *I took care of it* before you've asked what *it* was.

**Dangerous / useful.** **He will kill someone he shouldn't.** That is his
function in this deck. He is fearless because he has never seen a
consequence, and he wants your approval badly enough to earn it in advance.
Everything he costs you, you are also responsible for, because he is family
and you let him stay close.

**Running state.** `matty_made`, `matty_killed_wrong`, `matty_covered`,
`matty_disowned`, `matty_pinched`, `matty_dead`

---

### The table

---

#### 5. Aurelio Sacco — `AURELIO`

**Role.** Consigliere. Your father's consigliere before he was yours. Late
sixties. Has never held a crew and has never wanted one.

**Wants.** The family intact in ten years. Nothing else — not money, not a
seat, not credit.

**Talks.** Quietly, in complete sentences, and he will tell you the thing you
do not want to hear before he tells you anything else. Prefaces the worst news
with *now, listen to me.*

**Dangerous / useful.** He is the truth-teller, and he should become the
player's most trusted voice — which is exactly what makes him worth using
carefully. **Aurelio's frame is thirty years old.** His judgement was formed
when police were a cost and the government was not serious, and he is
constitutionally certain that what worked then works now. He is honest every
time and *wrong* on a meaningful minority of cards — never lying, never
scheming, just applying the wrong decade. The player will not see it coming,
because he has spent two hundred cards being right.

**How he is told apart from ADLER — the rule, added after the batch-9 editorial
pass.** The two of them blurred badly for nine batches: a blind read of twenty
cards found Aurelio identifiable only by *"Now, listen to me."*, and without it
his cards were Adler's. They are both cautious older men who notice a small
exposure before anybody else, so subject matter will never separate them. **The
separator is the direction they reason in:**

| | reasons | sounds like |
|---|---|---|
| `AURELIO` | **backward, from a remembered case** | *Your father paid for everything he owned in cash and was never once asked for a cheque. Schools have changed.* |
| `ADLER` | **forward, from a document that exists now** | *It is also a line on a page joining this company to that building.* |

Aurelio's frame is thirty years old, and that must be **audible in most of his
cards, not just the one per batch where it makes him wrong.** Being wrong is a
meaningful minority; reasoning from 1948 is the whole voice. Fifty-six of his
cards were rewritten for this after batch 9 — text only, same situations, same
choices, same numbers — taking frame coverage from roughly a quarter of his
cards to most of them.

**Nine cards deliberately carry no frame**, and they are the ones where he is
the subject rather than the counsel: `b3_058`, `b3_099`, `b4_074`,
`b4_076`, `b4_079`, `b5_059`, `b6_057`, `b8_061`, `b9_064`. A man
losing his grip on the past should not be reciting it.

**Running state.** `aurelio_overruled`, `aurelio_wrong_proven`,
`aurelio_doubted`, `aurelio_failing`, `aurelio_dead`

**After him — settled in batch 4, when `aurelio_dead` got its first setter.**
**Nobody inherits the chair.** The consigliere is not a post to be refilled in
this deck: writing a second honest adviser with a different name is writing
Aurelio again, and hard rule 4 forbids the seventeenth cast member. So the role
is not replaced, it is *redistributed*, and the redistribution is the point —
each of the three people who pick up a piece of it is worse at that piece than
he was:

| What he did | Who picks it up after `aurelio_dead` | Why it is worse |
|---|---|---|
| Tells the player the thing he doesn't want to hear | `CONCETTA` | She is right, and she is also his mother, so it costs blood to hear it (`b4_096`) |
| Counsel on men and rulings | `UNCLE SALLY` | He has never once been disinterested, and now nobody checks him |
| Procedure, paper, exposure | `ADLER` | He is not made, took no oath, and writes everything down |
| The rest | reserve voices | The room simply gets quieter, which is the intended feeling |

**Budget rule for batches 5–9.** Aurelio keeps his 13 cards per hundred, all of
them carrying `aurelio_dead` in `excludesFlags` as they already do. The
post-Aurelio world is **three or four `aurelio_dead`-gated cards per batch**,
drawn from the Concetta, Sally, Adler and reserve allocations — *not* a second
parallel deck. Anything more and every remaining batch pays a 13-card tax to a
state most runs never reach.

---

#### 6. Dominic "Duke" Scavo — `DUKE`

**Role.** Capo, Bushwick crew. Your best earner, and he knows the number by
heart.

**Wants.** A bigger piece, and for the ban on narcotics to quietly stop being
enforced. He will not ask for the second one directly.

**Talks.** Cheerful, transactional, always with a figure in it. Turns every
conversation into what it costs and what it returns. Never says no — says
*sure, boss,* and then does it his way.

**How he is told apart from ADLER and MOE WILLS — added after batch 9, and this
entry was the gap.** "Always with a figure in it" is a *trait*, not a voice: a
blind read found Duke identifiable only because there was a number in the
sentence, which is the same defect Aurelio had with his catchphrase. The entry
named the outcome — *sure, boss, and then his way* — without ever naming the
mechanism that produces it.

**The mechanism is pre-emptive disclosure. Duke tells you a thing before you can
find it out, and says out loud what he is *not* asking for, so that the framing
of it is his.** *Nobody's asking you to bless anything.* *I'm telling you I
worked it out rather than have somebody tell you I did.* *I am not arguing,
boss. I am asking you where I bring it on Friday.* He has almost always already
acted, or already knows, and the disclosure is the move — it is how a man in a
weak position takes control of a conversation he cannot win.

That separates him from the other two transactional voices, who reason from
somewhere else entirely:

| | reasons from | characteristic move |
|---|---|---|
| `DUKE` | **a transaction already in motion** | discloses first, and names what he is not asking for |
| `ADLER` | **a document that exists now** | *if they ask me for it, I have to give it to them* |
| `MOE WILLS` | **a boundary between two houses** | names what he has *not* done, and asks you to do it |

**Dangerous / useful.** He carries the family's income on his back, which
means every conversation with him is conducted from a weak position. If he
walks, a third of the money walks with him. He is the pressure on the safety
question from the earning side.

**Running state.** `duke_dope`, `duke_warned`, `duke_broke_off`,
`duke_proven_loyal`, `duke_dead`

---

#### 7. Angelo Mucci — `ANGELO`

**Role.** Soldier. Did eight years and did not say one word. Came home to
find his crew gone and his corner reassigned.

**Wants.** What he is owed — the money that was supposed to be held for him,
and the position that was supposed to be waiting.

**Talks.** Very little, and he watches the room while he does it. Has prison
manners: patient, exact, uncomfortable to sit across from.

**Dangerous / useful.** He is the loyalty question with a face on it. He did
everything right and got nothing for it, and half the family quietly assumes
that a man who came home that clean must have made a deal. **If you treat him
the way the family already thinks of him, you will make the thing you're
afraid of.** Useful for anything that needs a man who does not flinch.

**Running state.** `angelo_paid`, `angelo_suspected`, `angelo_flipped`,
`angelo_dead`

---

### The payroll

---

#### 8. Captain Walter Kiernan — `CAPT. KIERNAN`

**Role.** Precinct captain, Brooklyn North. On your father's payroll since
before you had a say in it. *(This is the "sheriff" slot — the New York
equivalent.)*

**Wants.** More than last time. Always more than last time, and always with a
reason that is genuinely true.

**Talks.** Friendly, familiar, ruinous. Talks about his pension, his
daughter's tuition, and the new people downtown who don't understand how
things work. Never states a number — makes you say it.

**Dangerous / useful.** **Bought, not owned.** He sells you protection, not
loyalty, and the price ratchets: every time the heat downtown rises, so does
he. He will not betray you for money. He will absolutely stop returning calls
the moment you become more dangerous to him than you are profitable. Refusing
him once is survivable. Refusing him twice is not.

He is **already on the payroll at card one** — inherited, not recruited. There
is no flag for buying him; the flags track only which way the ratchet has
turned.

**Running state.** `kiernan_price_up`, `kiernan_price_up_2`,
`kiernan_refused`, `kiernan_cold`, `kiernan_gone`

---

#### 9. Detective Sergeant Michael Ranieri — `DET. RANIERI`

**Role.** Brooklyn North detective squad. The one who can't be bought. **He is
the cops meter with a face on it.**

**Wants.** You, specifically — and not for the reason you'd assume.

**Talks.** Like a neighbour, because he is one. No threats, no theatre. Asks
after your mother by name and means it. The politeness is the pressure.

**Dangerous / useful.** He grew up four blocks away. His father was a baker
who paid your father's tax every Friday for nineteen years, and Michael
Ranieri has spent his entire adult life being asked whether he's *connected*
because of his surname. He cannot be bought because being bought would prove
every last thing anyone ever said about him. **Offering him money is worse
than doing nothing** — it is the specific insult he has organised his life
around. Never useful. Only ever a cost, of one kind or another.

**Running state.** `ranieri_watching`, `ranieri_offered`, `ranieri_case_open`,
`ranieri_family_touched`, `ranieri_dead`

---

### The world

---

#### 10. Don Ettore Braca — `DON BRACA`

**Role.** Boss of another family, thirty years older than you, seated at the
Commission. **He is the Commission with a face on it.**

**Wants.** Quiet, and a percentage of anything new. He genuinely does not want
your seat; he wants nothing to happen for another ten years.

**Talks.** Warmly, at length, about your father, and somewhere in the fourth
minute a decision arrives that you did not agree to. Never gives an order —
gives an opinion, twice.

**Dangerous / useful.** His approval *is* the commission meter. He can
sponsor you or he can decline to take your call, and there is no third
option. Useful as an arbiter when a rival crowds you. Dangerous because
everything he arbitrates costs a piece, and because a man who wants nothing to
happen is a poor ally when something has to.

**Running state.** `braca_sponsor`, `braca_owed_him`, `braca_owes_you`,
`braca_insulted`, `braca_dead`

---

#### 11. Hugh Fallon — `FALLON`

**Role.** President of an ILA local on the Brooklyn piers. Irish, third
generation on the waterfront.

**Wants.** To keep his local alive long enough to retire out of it — and for
you to remember that he delivers cargo, votes, and a pension fund.

**Talks.** Loud, profane, sentimental about the docks, and thirty seconds from
tears at any moment. Calls you *Don Marchetti* in a way that is not quite
respectful.

**Dangerous / useful.** The pension fund is the single largest pile of money
anyone in this deck can touch, and it is the single fastest way to bring
federal attention. His piers are dying — the freight is going to Newark — so
he needs you more each time you speak, which makes him both cheap and
desperate. Desperate men take deals.

**Running state.** `fallon_pension_touched`, `fallon_squeezed`,
`fallon_indicted`, `fallon_replaced`, `fallon_dead`

---

#### 12. Leon Adler — `ADLER`

**Role.** Accountant. Office above the linen supply on Flushing Avenue. Not
Italian, not made, and has handled the family's money for twenty-two years.

**Wants.** The money moved into things with tax returns — real estate,
vending, the linen company — before someone subpoenas a ledger.

**Talks.** In numbers and conditionals. *If they ask me for the ledger, I have
to give them the ledger.* Anxious, precise, and never wrong about arithmetic.

**Dangerous / useful.** He is the cash meter's advocate and the safety
argument's quietest, most correct voice. He is also the softest point in the
entire family: not made, no oath, a wife and a house in Forest Hills, and
everything written down somewhere. **Every dollar he protects, he also
documents.**

**Running state.** `adler_legit_front`, `adler_subpoenaed`, `adler_skimming`,
`adler_ran`, `adler_dead`

---

#### 13. Elmore "Moe" Wills — `MOE WILLS`

**Role.** Runs the numbers in Bed-Stuy. Not in your family, not in anyone's —
pays a street tax to you for the right to operate, as his people have since
before you were born.

**Wants.** To stop paying, eventually, without a war about it.

**Talks.** Courteous, cool, and completely unintimidated. Uses your title
correctly and with a very slight edge on it. Says *your father and I had an
understanding* and lets you work out what that means now.

**Dangerous / useful.** He is the neighbourhood changing, in one man. His
people are asking why they pay a tax to men who no longer live there, and he
does not have a good answer for them. He has his own connections now, some of
them the kind the Commission forbids. He is the most useful partner in this
deck and the one you have the least actual leverage over.

**Running state.** `wills_partner`, `wills_stopped_paying`, `wills_dope`,
`wills_war`, `wills_dead`

---

#### 14. Rosa Pinto — `ROSA`

**Role.** Owns Pinto's, on Grove Street. Borrowed from you to bury her
husband. The vig outran the restaurant about a year ago.

**Wants.** More time. Every single time, more time.

**Talks.** Apologising before she's said anything, and then not apologising at
all. Knows your wife. Knows what you ate at your father's wake.

**Dangerous / useful.** **She is the cost that isn't blood.** The ordinary
person the business grinds — someone the player will meet, and meet again, and
watch get smaller. Her restaurant is also a decent front, a place to meet, and
worth more to you empty than she is worth to you solvent. She is never a
threat. She is only ever a mirror.

**Running state.** `rosa_forgiven`, `rosa_place_taken`, `rosa_place_burned`,
`rosa_gone`

---

#### 15. Father Vincent Colla — `FATHER COLLA`

**Role.** Parish priest. Buried your father. Baptised your children. Hears
confession from roughly forty per cent of this deck.

**Wants.** The roof. Then the boiler. Then the school. He will take your money
every time and he will never once pretend it is clean.

**Talks.** Gently, and about parish business, and then one sentence at the end
that is not about parish business at all.

**Dangerous / useful.** **He knows everything and says nothing** — and he is
absolutely not corruptible by the fact that he takes your money. He can refuse
a funeral. He can decline to be seen with you. He gives the player the one
thing the meters cannot: a reading on what they have become, delivered by
someone with no stake in it.

**Running state.** `colla_roof_paid`, `colla_refused_you`, `colla_warned_you`,
`colla_gone`

---

#### 16. Dr. Piero Nardi — `DR. NARDI`

**Role.** General practice on Wyckoff Avenue. Takes out bullets on kitchen
tables and files nothing.

**Wants.** His sports-book debt to go away. That is the entire reason he does
not ask questions, and both of you know it.

**Talks.** Clipped, resentful, professional. States the medical fact and
nothing else. Will not say the word *gunshot*.

**Dangerous / useful.** He is the difference between a wounded man and a dead
one, which makes him load-bearing on exactly the nights that matter. He is
also a man who hates you, keeps no records, and has therefore never had to be
loyal. Nobody has ever checked whether he can hold his nerve, because nobody
has ever needed to until they needed to.

**Running state.** `nardi_debt_cleared`, `nardi_used`, `nardi_talked`,
`nardi_gone`

---

## Card budget

Across all 900 cards. The number is **cards on which that character is the
`speaker`** — not cards they are mentioned in. Mentions are unlimited.

| # | Speaker string | Character | Cards | Share | Per 50-card batch |
|---|---|---|---|---:|---:|---:|
| 5 | `AURELIO` | Consigliere | 115 | 12.8% | ~6.4 |
| 2 | `GIULIA` | Wife | 100 | 11.1% | ~5.6 |
| 1 | `UNCLE SALLY` | Uncle / underboss | 95 | 10.6% | ~5.3 |
| 4 | `MATTY` | Nephew | 75 | 8.3% | ~4.2 |
| 6 | `DUKE` | Capo | 65 | 7.2% | ~3.6 |
| 12 | `ADLER` | Accountant | 55 | 6.1% | ~3.1 |
| 8 | `CAPT. KIERNAN` | Bought captain | 50 | 5.6% | ~2.8 |
| 9 | `DET. RANIERI` | Honest detective | 45 | 5.0% | ~2.5 |
| 3 | `CONCETTA` | Mother | 40 | 4.4% | ~2.2 |
| 7 | `ANGELO` | Soldier home from prison | 35 | 3.9% | ~1.9 |
| 11 | `FALLON` | Union | 35 | 3.9% | ~1.9 |
| 10 | `DON BRACA` | Rival boss / Commission | 35 | 3.9% | ~1.9 |
| 13 | `MOE WILLS` | Bed-Stuy numbers | 30 | 3.3% | ~1.7 |
| 14 | `ROSA` | Restaurant owner | 25 | 2.8% | ~1.4 |
| 15 | `FATHER COLLA` | Priest | 25 | 2.8% | ~1.4 |
| 16 | `DR. NARDI` | Doctor | 15 | 1.7% | ~0.8 |
| — | *reserve voices* | see below | 60 | 6.7% | ~3.3 |
| | | **Total** | **900** | **100%** | **50** |

### Reserve voices — 60 cards

For cards that genuinely have no cast member in them: a street, a phone that
rings, a newspaper, a room. Permitted speaker strings, and only these:

`THE STREET` · `THE CLUB` · `A SOLDIER` · `THE PAPERS` · `THE PHONE`

A reserve voice is never a person. It has no name, no running state, and no
continuity. **If you find yourself giving a reserve card a name, it belongs to
a cast member instead.**

### How a batch checks itself

Before a batch of 50 ships:

1. Count speakers. Each should be within **±40% of its per-batch figure** —
   `AURELIO` between 4 and 9, `DR. NARDI` between 0 and 2. Wide on purpose:
   a batch about the docks will lean on Fallon.
2. Running total across all batches so far must be within **±10%** of the
   pro-rata budget. Divergence is allowed to be local, never cumulative.
3. No character absent from **three consecutive batches** except `DR. NARDI`,
   `ROSA`, `FATHER COLLA`, and `MOE WILLS`, which may go two batches dark.
4. Every card carries its speaker's `*_dead` flag in `requires.excludesFlags`.
5. Every flag used is in [flag-registry.md](flag-registry.md).

---

## What batch 1 changed

Written as continuous state. Batch 2 continues from here rather than
resetting.

- **Aurelio.** His wrong-decade blind spot is now on the board in two places
  and both are *telephones and policemen* — `b1_004` (a wiretap needs a judge,
  so talk on the phone) and `b1_094` (a detective who can't be bought will
  move on, they always do). Both are honest, both are thirty years out of
  date, and `b1_075` is him being gracious about having been overruled while
  learning nothing. Keep his errors in that register: procedure, not
  judgement of people. He is never wrong about a man.
- **Uncle Sally** is the batch's second voice on almost every family ruling —
  Angelo, Matty, the powder. `sally_humiliated` is reachable from six cards
  and `sally_backed` from five, so by batch 2 he is likely already leaning one
  way. `b1_071` is Concetta reporting on him rather than him speaking, and its
  right side starts him counting names (`sally_faction`).
- **Angelo.** His eight years' money is unspent at the top of batch 1 and the
  three-card chain (`b1_080`→`b1_082`) is the family deciding whether to make
  the informer it is afraid of. `angelo_paid` is reachable from three separate
  cards, which is deliberate: the game should let a player who wants to do
  right by him do right by him.
- **Matty** kills the wrong man in this batch (`b1_076`) and the man belonged
  to Moe Wills' book, not ours. That is the connective tissue: the nephew's
  mistake arrives as a bill from a man we tax. `b1_099` is Matty disowned and
  still volunteering, which is his whole character with the funny part
  removed.
- **Moe Wills** now has a specific grievance with a name on it rather than a
  general one, and `wills_stopped_paying` is reachable through it.
- **Kiernan's ratchet** has turned once in this batch and is warm the whole
  way — `b1_087` is him doing the player an unasked favour and billing for it
  in the same breath. `b1_097` is the first time he is frightened rather than
  greedy.
- **Rosa** can lose the restaurant in this batch (`b1_089` left). If she does,
  the debt card is suppressed and `b1_096` replaces her: same woman, behind a
  counter on Woodbine, asking for one afternoon. **No Rosa card in this batch
  costs blood** — per her entry, she is the cost that isn't blood.
- **Father Colla's** sideways line this batch is `b1_062`: the boy spent
  twenty minutes on his car and then asked whether a thing is still a sin if
  somebody else was going to do it anyway.

---

## What batch 2 changed

Continuous state again. Batch 3 continues from here.

- **Matty** now has a terminus. `matty_pinched` had no setter anywhere in the
  deck; `b2_078` is it, and both sides set it — he is arrested either way, and
  the choice is only what the house does about it. The reserved `matty_made`
  chain (`b2_076`→`b2_078`) runs button → entitlement → the Eight-Three, and
  reads correctly whether or not `matty_killed_wrong` is set. The funny part
  is fully intact right up to `b2_077`: he wants a medal for saying no four
  times. Then the phone call. **He is not written as guilty** — the bag isn't
  his, and no card ever settles whether that's true.
- **Duke** can now leave. `duke_broke_off` had no setter; `b2_085` is it, at
  the end of the four-card chain, and it is a handshake rather than a war.
  `duke_proven_loyal` also gets its only setter (`b2_082` left — he discloses
  the lunches before anyone reports them). The escalation is deliberately
  *not* about narcotics: he leaves over being made to explain himself, which
  is what Sally says out loud in `b2_083`.
- **Adler** can now vanish. `b2_081` left sets `adler_ran`, which is a silence
  flag — every Adler card leaves the deck and `b2_099` replaces him with
  Aurelio standing in a dark office. He is the softest point in the family and
  batch 2 is where that gets tested. `adler_subpoenaed` gets its setters here.
- **Aurelio** is wrong twice more and both are procedure again, per the rule
  that he is never wrong about a man: `b2_003` (put every man with the same
  lawyer — one story, and the government unpicks it for two years) and
  `b2_069` (answer a subpoena slowly and completely and they stop coming
  back). `b2_073` is the first card where his wrongness is *proven to him* —
  it requires `aurelio_frame_ranieri` + `ranieri_case_open`, both set in batch
  1, and sets `aurelio_wrong_proven` on both sides. He takes it well and
  learns nothing structural, which is the point.
- **Kiernan's** ratchet turns again and the register changes. `b2_088` is the
  first time he asks for something that isn't money — a name for a burglary
  pattern — and it is still warm. `b2_062` sets `kiernan_cold` behind
  `kiernan_refused`, and it is written as the third refusal: he says he won't
  ask twice, and he doesn't. *(Corrected in batch 6's audit: this said "gets its
  only setter", and it never was — `b1_060` reached `kiernan_cold` first, and
  `b5_096` and `b6_066` reach it since. Four setters, one reader.)*
- **Angelo** reaches the end of the road batch 1 built. `angelo_flipped` gets
  its setter at `b2_091` right, reachable only through `angelo_suspected`
  without `angelo_paid`, exactly as the registry requires. `b2_063` is Sally
  asking for permission he isn't asking for, and its right side sets
  `angelo_dead`. `b2_100` is the suppression variant: a flipped Angelo asking
  for money for his mother's operation, and the player knowing.
- **Moe Wills** stops being a tax and becomes a business. `wills_partner` gets
  its second setter (`b2_094` left, the building on Halsey) and its first
  reader (`b2_098`). His grievance is now specific and demographic rather than
  personal — his people ask why they pay men who moved to Long Island.
- **Giulia** gets the Long Island house, which is the concrete version of what
  cast.md says she wants: not out of the house, out of the *life*. `b2_086`
  is flag-free and cheap to reach. `b2_056` reads `giulia_told` — the honest
  branch finally has a reader, and it costs her something to be the person who
  is told.
- **Concetta** gets `concetta_silent` its first setters (`b2_014`, `b2_039`),
  both of them the player declining an hour at her table.
- **Father Colla's** sideways line this batch is `b2_051`: your father's name
  was on the feast banner eleven years, and nobody ever asked him whether he
  wanted it there. `b2_067` is the other half of a warning he gave earlier —
  you have not stopped coming to Mass, and he does not yet know whether that
  makes it better or worse.
- **Rosa** is smaller again and still not blood. `b2_075` asks whether she is
  the cook or the woman who is allowed to stay. No Rosa card in this batch
  costs blood, per her entry.
- **Don Braca** raises his own succession (`b2_092`) and it is the batch's
  cheapest route to `braca_sponsor`. He is seventy-nine and his doctor is a
  pessimist; batch 3 owns whether that goes anywhere.

---

## What batch 3 changed

Continuous state again. Batch 4 continues from here.

- **Uncle Sally** is the batch. The reserved `sally_faction` slow burn is built
  as a six-card arc (`b3_076`→`b3_081`) and it ends him one way or the other:
  `sally_retired` (Florida, Thursday, and he still calls) or `sally_moved` +
  `house_split`. Both had no setter anywhere in the deck before this. The arc
  never re-asks *is your uncle moving* — it opens on Adler noticing that the
  Canarsie envelope now travels through Sally's kitchen and arrives correct to
  the dollar. **He is not written as a schemer.** He asks for Canarsie out
  loud, in front of the table, because that is the only way he knows to be
  told he matters, and the player refusing him is what makes the second door.
- **Concetta** is the hinge of that arc, and `concetta_sided_sally` gets its
  only setter at `b3_079` — not by her turning on her son, but by the player
  declining to ask her to spend herself. She says a sentence on Sunday either
  way. Asking her to say yours costs 13 blood; leaving her free costs the
  house.
- **Giulia.** `giulia_home_touched` and `giulia_left` both get their first
  setters, in one three-card chain (`b3_085`→`b3_087`): four shots through the
  front of the house at three in the morning, the family deciding whether that
  is answered, and then her sister's spare room in Ozone Park. `b3_097` is her
  speaking from that kitchen — per her entry she cannot be written out, and
  `giulia_left` changes where she speaks from, not whether.
- **Don Braca dies.** `braca_dead` gets its only setter and **both sides of
  `b3_091` set it** — the dying is the event, the choice is only whether the
  player gives him his last word about his grandson. Gated behind `braca_after`
  from batch 2, which raised the succession and left it open. `b3_100` is Sally
  on the man who has taken the chair: fifty-one, never met the player's father,
  already asking to meet the young men.
- **Kiernan** reaches the end of his ratchet. `kiernan_gone` had no setter
  anywhere; `b3_089` is it, correctly gated behind `kiernan_price_up_2`, which
  batches 1 and 2 both flagged as unanswered. He is transferred rather than
  indicted, and the player can pay a great deal to keep him and be conspicuous
  doing it. `b3_096` is the replacement: a voice at the Eight-Three that does
  not know anybody.
- **Aurelio** is wrong once more, and again on procedure rather than people:
  `b3_003`, one book in one hand in one room, because no man was ever convicted
  on his own handwriting. `b3_099` is him in the split house asking which of
  the two rooms he is supposed to be honest in.
- **Dr. Nardi** finally gets tested. `nardi_talked` and `nardi_gone` both get
  their first setters in a two-card chain (`b3_094`→`b3_095`): two men with a
  photograph, and then the blind down for four days. Per his entry, nobody has
  ever checked whether he can hold his nerve.
- **Rosa** can lose the place to a fire. `rosa_place_burned` gets its only
  setter at `b3_084`, at the end of a chain that starts as arithmetic and never
  once raises its voice. **No Rosa card in this batch costs blood**, per her
  entry, including the one where she asks whether she should be frightened.
- **Fallon** can be replaced by the player's own man rather than by events —
  `b3_046` sets `docks_taken` and `fallon_replaced` together, and `docks_taken`
  had no setter anywhere. `b3_062` is him afterwards, in his own kitchen at
  eleven in the morning.
- **Matty.** `matty_pinched` now has a reader written from inside the Tombs
  (`b3_056`), and the deck-wide question batch 2 left open is settled in
  [flag-registry.md](flag-registry.md) under *Situational silence*: the flag is
  not promoted to †, and instead every street-set or club-set Matty card in
  this batch carries it in `excludesFlags`. He speaks from a telephone or he
  does not speak.
- **Father Colla's** sideways line this batch is `b3_065`, gated on
  `dope_sanctioned`: he buried a boy of twenty, the mother asked him to say
  from the altar that it was his heart, he said it was his heart, and he would
  like the player to have heard him say that he said it.

---

## What batch 4 changed

Continuous state again. Batch 5 continues from here.

- **Aurelio can die.** `aurelio_failing` and `aurelio_dead` both had no setter
  anywhere; the four-card chain `b4_076`→`b4_079` gives them one, and it is age,
  not violence. He finds the same question written twice in his own book, in his
  own hand, with two different answers, and brings it to the player himself —
  **his mind goes before his honesty does, which is the only order it could go
  in.** `aurelio_failing` is set on both sides of `b4_078` and read at `b4_074`,
  where he asks to be brought things twice because he no longer trusts the date
  at the top of his own page. `b4_079` is Wyckoff Heights, and both sides set
  `aurelio_dead`: the choice is only whether the player takes his counsel one
  last time, knowing it will be 1948, or lets him go believing it is all
  settled. `b4_096` is Concetta afterwards — nobody left who says no. **How the
  family works once he is gone is settled in his entry above** — nobody inherits
  the chair, and the post-Aurelio world is three or four gated cards a batch,
  not a parallel deck. Batches 5–9 continue that rather than improvise it.
  **His wrong-decade card this batch is `b4_002`** and it is procedure again per
  the standing rule: a man under indictment should keep his habits, because
  juries look twice at the ones who change their pattern.
- **Ranieri's family can be touched.** `ranieri_family_touched` had no setter;
  `b4_085` right is it. The three-card chain `b4_083`→`b4_085` runs off the fact
  cast.md has carried since batch one — his father was a baker who paid the tax
  — and the bakery on Central Avenue turns out to have been on Duke's list since
  before either of them. Ranieri asks once, in the street, like a neighbour.
  Then the window goes in and nobody who works for the player can say who did
  it. `b4_098` is what he becomes: no question about the player's mother, a file
  with a name on the tab, and the politeness still there and now much worse.
- **Moe Wills can go to war.** `wills_war` had no setter; `b4_082` left is it,
  at the end of `b4_080`→`b4_082`. It does not start with him — it starts with a
  twenty-six-year-old of his who said out loud what the rest of them think, and
  with Wills declining to punish him for it. The other branch ends the tax
  instead (`wills_stopped_paying`) or makes the partnership real.
  `b4_097` is the street on a line where nobody writes numbers this week.
- **Adler takes.** `adler_skimming` had no setter; `b4_095` sets it on **both**
  sides — four hundred dollars a month for three months, entered in the book as
  a loan to himself, in his own hand, for a daughter at Barnard. The taking is
  the fact; the choice is only whether the family makes him say it back.
- **Sally still calls from Florida.** `sally_retired` had one setter and no
  reader at all. `b4_088`→`b4_089` is the reader: eighty-one degrees, a man down
  there from Cleveland who knows everybody we know, and nobody who can make a
  coffee. `b4_089` is Aurelio counting the telephone calls — three men told him,
  one did not — and it can hand the old man `sally_faction` from two thousand
  miles away. Per his entry, retirement was never silence.
- **`sally_backed` finally reads.** Twenty-two cards across three batches set it
  and nothing had ever noticed. `b4_056` and `b4_057` do: the crews have started
  taking questions to the uncle because he answers them the way the player
  would, and `b4_056` left is the cheapest route to `sally_faction` in the deck.
- **Matty is offered a way out.** `b4_090`→`b4_091` reads `matty_pinched` and is
  the mirror of Angelo's flip: eighteen months instead of nine years, with a
  condition on it, and the boy admits he said he would think about it because he
  wanted to hear the rest. The funny part is gone by this point; `b4_060` still
  has it, wanting to know whether a made man is allowed to say no to the dry
  cleaning.
- **Concetta's Sunday sentence has consequences.** `concetta_sided_sally` was
  set once in batch 3 and read nowhere; `b4_092`→`b4_093` reads it, and she can
  be brought back to the table (`concetta_blessing`) or left to be an old woman
  who was right (`concetta_silent`).
- **The split has texture now.** `house_split` gets three readers (`b4_062`,
  `b4_063`, `b4_064`) rather than another arc, per the note batch 3 left: a wife
  expected at two Sunday tables, a bookkeeper keeping Canarsie on a page of its
  own, and a soldier of nine years asking where he is supposed to stand.
- **Father Colla's sideways line this batch is `b4_051`**: the school has forty
  children whose fathers are away, they have started calling it that, and he
  wrote the word on a form himself last week without noticing.
- **Rosa** is smaller again and still not blood. `b4_050` is an eleven-year-old
  who is very good with people's coats and has started listening to the back
  table. **No Rosa card in this batch costs blood**, per her entry.

---

## What batch 5 changed

**Reconstructed during batch 6**, from that batch's entry in
[content-bible.md](content-bible.md) — batch 5 wrote its summary there and never
added a section here, which is the one housekeeping step it missed. Nothing
below is new; it is batch 5's own record, put where batch 6 needed to read it.

- **Ranieri can be killed.** `ranieri_dead` had no setter; the four-card chain
  `b5_076`→`b5_079` gives it one, gated on `ranieri_watching`. It is the
  heaviest single side in five batches — 20 cops and −18 commission — and per
  his entry it should be close to run-ending. `b5_096` is Kiernan afterwards,
  useless, with every cop in the city looking at a photograph on a wall.
- **Fallon can die of his heart.** `b5_080`→`b5_082`, and **both sides of
  `b5_082` set `fallon_dead`**: the dying is the event, the choice is what the
  family does about nine hundred votes and a welfare fund before the local is
  empty.
- **The vice arrives.** Eight cards declaring `"vice": true`, the deck's first
  forcing pressure. Three flag-free, five gated on depth-1 consequence flags.
  They come out of the other budgets, not on top: 55 → 52 flag-free, 20 → 15
  flag-aware.
- **Blood came up short — 9 of 100 against a 18–19 norm** — and the diagnosis
  is a cast fact worth keeping: all eight of batch 5's arcs were business, and
  **Giulia carries 37 of the 74 blood cards in batches 1–4 on her own.** A batch
  she is barely in is a batch that will be short of blood. The master prompt now
  budgets blood at the chain level because of this.
- **Concetta 3 and reserve 7**, both inside tolerance; every other speaker on
  budget.

---

## What batch 6 changed

Continuous state again. Batch 7 continues from here.

- **Matty can die, and it is the batch.** `matty_dead` had no setter anywhere
  and fifty-one cards already excluded it. The six-card slow burn
  `b6_076`→`b6_081` gives it one, and the arc is his character rather than an
  execution: three kids from Ridgewood start saying *Matty Ricci's people* out
  loud, a paper bag of somebody else's money arrives at the club, a Provenzano
  capo says the nephew's name and the player's in one sentence, and by the
  fourth card Lucia is in Giulia's kitchen asking whether her son will be alive
  at Christmas. **He never does anything worse than want to be somebody.** The
  last card offers no third answer: `matty_dead` and 18 blood, or `at_war` and
  a family that keeps him. `b6_096` is Concetta afterwards — his mother
  telephones, asks after both children, and does not say the player's name.
- **Rosa is allowed to leave.** `rosa_gone` had no setter. `b6_088`→`b6_089` is
  it, and **both sides of the second card set it** — she goes either way; the
  choice is only whether the debt goes with her and whether anything is sent
  after her. Per her entry, **no Rosa card in this batch costs blood**,
  including the one where she asks whether a person is allowed to go.
- **Father Colla is transferred.** `colla_gone` had no setter. `b6_090`→`b6_091`
  is the diocese asking, after nineteen years, whether he is content in the
  parish, and then Rockville Centre in September. His sideways line this batch
  is `b6_018`: a boy of eleven confessed a thing his father did, believing it
  was his, and the priest gave him three Hail Marys for a sin he did not commit
  and would like the player to know that he did that.
- **Giulia's blood runs through the children now** rather than through widows.
  `b6_092`→`b6_093` is Paolo asking what his father does all day and then
  telling his teacher his father is in linen — he has practised it. Six of the
  batch's nineteen blood cards are in the chains, which is what batch 5 missed.
- **Aurelio's wrong-decade card is `b6_003`** and it is procedure again, per the
  standing rule that he is never wrong about a man: slips are safe in a car,
  because no judge in this city has ever signed a paper for a parked
  automobile.
- **Angelo has a life outside being suspected.** He is courted by another
  family and reports it himself (`b6_012`), finds the man who has his corner and
  is offered a coffee (`b6_048`), and under `docks_taken` he is the voice on
  nine hundred men signing a book (`b6_072`). `angelo_paid` gets a third and
  fourth route.
- **The linen company becomes a real object.** `b6_085`→`b6_087` is the quiet
  end of the safety fault line as a three-card chain: a hospital laundry
  contract with an auditor attached, Duke asking where the Friday money goes if
  the company stops being the room it is counted in, and Aurelio conceding that
  it is both the safest thing the family owns and the first place they will
  look.
- **The books open on the player's terms or the uncle's.** `b6_082`→`b6_084`,
  three chairs and eleven men. `books_open` gets two more setters, and the
  branch is `sally_backed` against `sally_humiliated` + `angelo_paid`.
- **Moe Wills tells the player first.** `b6_094`→`b6_095` — he has an offer
  uptown that the Commission has a rule about, he does not need permission, and
  he is telling the player before somebody else does. `wills_dope` gets a second
  setter and Sally is left holding the answer.
- **Speakers.** `DUKE` 8 against a budget of 7 and `ANGELO` 5 against 4, both
  inside the ±40% tolerance and both because the linen chain and the seized hall
  needed them; `DON BRACA` and `FALLON` are one under each. Everyone else is on
  budget.

---

## What batch 7 changed

Continuous state again. Batch 8 continues from here.

- **Concetta dies, and it is age.** `concetta_dead` had no setter anywhere.
  `b7_088`→`b7_089` gives it one: she gives your father's watch to a boy who
  carried her shopping, tells you she has started giving things away and that
  she knows she has, and then one morning she does not get up. **Both sides of
  `b7_089` set it** — the dying is the event, and the choice is only whether the
  player is the one standing in that door when forty people arrive. She is also
  the batch's largest voice increase, from 4 to 6, per the drift table in
  [content-bible.md](content-bible.md); three of the six are in the two chains
  and one is the post-Aurelio card where she takes over telling him he is wrong.
- **Don Aldo's money lands on the people it lands on**, which is what the
  *established backstory* note reserved it for. The four-card chain
  `b7_076`→`b7_079` is Sally hearing about the box from somebody who is not the
  family, Adler saying that money with no page cannot acquire one quietly,
  Giulia refusing to be the second person keeping it, and Concetta at the end:
  *he did not tell me either.* **Nothing is re-discovered** — the boiler came out
  in `b6_054` and no card here pretends otherwise. There is no second box.
- **Adler can be killed.** `adler_dead` had no setter and every Adler card
  already excluded it. `b7_080`→`b7_082` is the quiet end of the safety fault
  line turning sharp: the hospital auditor asks a written question, Aurelio
  explains that immunity means a man *cannot refuse to answer*, and Duke says
  out loud that he knows what time Leon's car starts. The last card offers no
  third answer — `feds_active` and a bookkeeper who talks, or `adler_dead` and
  −15 commission for killing a man under subpoena. Per his entry he is the
  softest point in the family, and this is the batch that stops asking politely.
- **Sally inherits the rulings.** `b7_063` is the post-Aurelio redistribution
  cast.md wrote out after batch 4, made concrete: the crews bring him the
  rulings because there is nobody else to bring them to, he has given four this
  month, and nobody has asked him whether he should be the one giving them.
  `b7_009` is the ungated version of the same drift with the old man still
  alive, and it hands out `sally_backed` or `sally_humiliated`.
- **Giulia is the batch's largest voice, at 15**, and her blood runs through her
  own family rather than the player's for the first time: `b7_086`→`b7_087` is
  two of Duke's men taxing her father's pharmacy on Himrod without knowing whose
  father it was, and the whole crew finding out at once. Six of the batch's
  nineteen blood cards are in the chains, decided when the chains were chosen.
- **Aurelio's wrong-decade card is `b7_003`** and it is procedure again, per the
  standing rule that he is never wrong about a man: put the meetings back in the
  parish hall, because no government has ever put a microphone inside a church
  building.
- **Father Colla's sideways line this batch is `b7_065`**: the roof is finished,
  there is to be a plaque, and a woman asked him on Tuesday whether it is right
  to pray under a roof somebody paid for.
- **Rosa** is smaller again and still not blood. `b7_046` is the girl who does
  the lunches telling people she works for the player, and liking that answer
  better than the true one. **No Rosa card in this batch costs blood**, per her
  entry.
- **Speakers.** Batch 7 hits the allocation table in
  [content-bible.md](content-bible.md) exactly, including `DR. NARDI` at zero —
  he is the only speaker over budget and cast.md rule 1 allows it. `GIULIA` 15
  and `CONCETTA` 6 are both at their ±40% ceiling and are corrections rather
  than budget; batches 8 and 9 have to hold them there or the cumulative drift
  does not close.

---

## What batch 8 changed

Continuous state again. Batch 9 continues from here.

- **Duke can die, and it is the argument, not a betrayal.** `duke_dead` had no
  setter anywhere and fifty-nine cards already excluded it. The four-beat chain
  `b8_076`→`b8_079` gives it one, and per his entry every conversation in it is
  conducted from a weak position: he opens by telling the player the family's own
  number, which he worked out himself, *rather than have somebody tell you I
  did*. Then three of his men at a Provenzano christening and Duke not there.
  Then Adler, who can make every crew's figure agree with something except this
  one, and it is not short — it is too large. The last card offers no third
  answer and Duke says so himself: a third of what the family eats comes off it,
  and the Commission's rule is the Commission's rule. **He never does anything
  the deck has not been asking him to do since card one.** `b8_096` is Adler
  afterwards, on an envelope eleven men counted for themselves and got eleven
  different figures.
- **Moe Wills can be killed, and the player is not the one who wants it.**
  `wills_dead` had no setter. `b8_080`→`b8_082` is it, gated on
  `wills_connection`, which batch 6 opened and batch 7 named as the door. Braca
  brings the table's opinion twice and never gives an order; Wills, who knows
  already, asks exactly one question — *do I go?* — and says he will take
  whatever answer he is given; and Sally counts three days of two men from Ozone
  Park sitting on Fulton Street. Per his entry he is the partner the player has
  the least leverage over, so the deck does not let the player have him cheaply:
  standing out of the way is what was asked for and it is worth +11 commission.
- **Giulia is offered the thing her entry says she wants**, and it is the
  batch's blood. `b8_083`→`b8_085` is her sister's husband's linen route in
  Union — the summer, then the school year, then he does not come back — then a
  soldier at the club who has two of his own and never sent them anywhere, then
  Paolo, who has told his mother he does not want to go and his teacher that he
  does, and neither of them the truth. She speaks ten of the batch's nineteen
  blood cards and `giulia_shielded` gets a setter that costs 12.
- **Concetta holds at 6 and takes the consigliere's job in the room.** `b8_056`
  is the post-Aurelio card cast.md's redistribution table asks her to carry:
  there is nobody left who will say no, the player has noticed, and she thinks
  he likes it. Her cumulative drift closes from −6.8% at 700 to **−1.6% at 800**.
- **Sally inherits more and is asked to notice.** `b8_057` is him counting the
  four rulings he gave this month and asking to be told to stop, because nobody
  else has. `b8_089` is the old argument in its cheapest form — every new man is
  going to Bushwick, and your father spread them and it cost him money.
- **Aurelio's wrong-decade card this batch is `b8_003`** and it is procedure
  again, per the standing rule that he is never wrong about a man: put the
  envelopes in the mail, because nobody in this country has ever opened a letter
  without a judge. He is also the voice on the grand jury (`b8_094`), where he is
  exactly right — *witness* is the worse of the two words.
- **Dr. Nardi is finally asked whether he wants out.** `b8_092`→`b8_093` is the
  two cards his entry has been waiting for: a man on the kitchen table who will
  live, what came out of him in an envelope on the shelf, and a doctor who has
  never once had to be loyal because nobody has ever asked him to be.
- **Father Colla's sideways line this batch is `b8_050`**: the men have started
  coming to the eight o'clock instead of the ten, because the eight is short and
  nobody speaks to anybody afterwards, and he would like to know whether he
  should say something about that.
- **Rosa** is smaller again and still not blood. `b8_048` is her moving the
  Ferrante party for a christening and wanting the player to hear from her that
  she is moving them. **No Rosa card in this batch costs blood**, per her entry.
- **Speakers.** Batch 8 hits its allocation exactly, and every one of the sixteen
  plus reserve is now inside **±2.5% of pro-rata at 800** except `DR. NARDI` at
  +5.0%, who takes one card in batch 9 and lands on his budget. The batch-6
  audit's three drift cases — Concetta, Moe Wills, Giulia — are all closed.

---

## What batch 9 changed

**The last batch.** Nothing continues from here, so this section is a record
rather than a handover.

- **Sally dies, and nobody decides it.** `sally_dead` was the only flag in
  [flag-registry.md](flag-registry.md) still without a setter anywhere, and
  seventy-odd cards already excluded it. The four-beat chain `b9_076`→`b9_079`
  gives it one, built on `sally_faction` exactly as the reservation required —
  it reads the flag, it does not re-seed the thread. The arc is his entry rather
  than an execution: **he comes and asks, which he has never done**, because men
  have started calling themselves his and he did not ask one of them and cannot
  make them stop. Then a soldier who was asked which way he would go and did not
  answer. Then Carmela, in Giulia's kitchen, asking whether her husband will be
  at his own table at Christmas, the way you check a train time. The last card is
  Sally himself, and **both sides set `sally_dead`** — two of the men counting
  themselves to him have decided to settle it and will not be told otherwise, by
  him or by the player. The choice is only whether four men stand on that kitchen
  on Thursday or whether the old man is allowed his own Thursday. He is never
  written as a schemer, and he never moves against the player; per his entry the
  thing he wanted all along was to be consulted, and this is what it cost.
- **`giulia_shielded` finally reads.** Eleven cards across eight batches
  recorded the player keeping blood away from the house at real cost and exactly
  one ever mentioned it — the deck's largest unacknowledged act of decency.
  `b9_080`→`b9_082` is the acknowledgement and it is the batch's second
  house-spending arc: she has counted the nights he came in and washed his hands
  before touching anybody, and she is not asking him to stop, she is asking to be
  allowed to say she knows. It ends on the thing her entry has wanted since batch
  one, in a sentence for the first time — one of the two children out of the
  borough before September, and **the player chooses which.** `b9_059` is
  Concetta on the same flag: she did it for his father for forty years and
  nobody thanked her either, and she will not pretend that was fine.
- **Giulia is not only a bill.** She has twelve cards and, as first written, every
  one of them cost blood — which made her the deck’s conscience and nothing else.
  Two were rewritten: `b9_011` is an evening and a telephone off the hook, and
  `b9_013` is her asking for the Sunday meetings to happen in a room her children
  do not eat in. Neither costs blood. Per her entry she married him knowing exactly
  what he was, and a woman who only ever appears to present the invoice is a
  narrower person than that. The other ten land harder for it.
- **Aurelio's wrong-decade card is `b9_003`** and it is procedure again, per the
  standing rule that he is never wrong about a man: every man on the payroll
  should keep receipts, because a man with paper has an explanation and no jury
  ever went past a receipt. He is also `b9_089`, where he is exactly right — the
  old man will describe his own favour to four people before Friday.
- **Duke says it out loud.** `duke_dope` had eleven setters and two readers
  across seven batches. `b9_060` is him asking to stop pretending the player does
  not know, because the pretending is what gets somebody killed, and `b9_061` is
  Sally asking for the rule to be said aloud once — the one card in the batch
  that can set `dope_sanctioned` or `dope_banned`, and it carries both in
  `excludesFlags` per the mutual-exclusion rule batch 8 settled.
- **Angelo asks.** `b9_086`→`b9_087` is the soldier who did nine years asking to
  be considered for a crew out loud, in front of people, and Sally admitting that
  the family has quietly decided nine silent years are suspicious, *which tells
  you more about us than about him.*
- **Father Colla's sideways line this batch is `b9_065`**: the roof is finished,
  and a boy asked him on Thursday which of the men on the plaque was the worst
  one, because his grandmother said one of them was. He said he did not know. He
  knew.
- **Rosa** is smaller again and still not blood. `b9_094`→`b9_095` is the priest
  noticing she has moved to the eight o'clock, and Rosa saying she has not
  stopped paying and will not, but has stopped being able to look at the people
  she owes it to over a plate of food. **No Rosa card in this batch costs
  blood**, per her entry.
- **The post-Aurelio three are `b9_056`, `b9_057`, `b9_058`** — Concetta, Sally
  and Adler, from those three allocations exactly as the cap requires. Sally's is
  the one that matters: there were three of them in a room for twenty years, now
  there are two, and he has noticed that he wins every argument.
- **Speakers.** Batch 9 hits the allocation batch 8 computed **exactly**, all
  seventeen figures, so every one of the sixteen plus reserve lands precisely on
  its 900-card budget. `DR. NARDI` takes his single card (`b9_048`) and closes
  the last drift in the deck.

---

## Appendix: off-stage names

Named for consistency across 900 cards. **None of these is ever a `speaker`,
and none has a flag.** If one of them starts needing a running state, come back
here and promote them properly.

| Name | Who |
|---|---|
| Don Aldo Marchetti | Your father. Dead. Referenced constantly. |
| Paolo, Anna | Your son and daughter. Children throughout. |
| Lucia Ricci | Your sister. Matty's mother. Lives in Ridgewood. |
| Carmela | Sally's wife. |
| The Braca family | Don Braca's people. |
| The 83rd | Kiernan's precinct. |
| St. Barbara's | Father Colla's parish. |
| The Knickerbocker club | The social club. Where most cards happen. |
| Pinto's | Rosa's restaurant, on Grove Street. |
| Marchetti Linen Supply | The nearly-legitimate front, Flushing Avenue. |
