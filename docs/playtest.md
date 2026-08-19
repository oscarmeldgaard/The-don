# The playtest

**Status: built and ready to run. Not yet run.** Nine batches of structure are
finished, the test suite is green over the full 900 cards, and every remaining
question about this game is one a simulation cannot answer. This file is the
session, written so somebody who was not in the room for any of the previous
nine batches can run it correctly.

Batch 5 closed tuning against the greedy oracle and said the next word on
difficulty comes from a person. This is that.

---

## What the session is actually for

**Three questions, and only three.** Everything below exists to get honest
answers to them, which mostly means *not* asking them directly.

| | The question | Why it cannot be simulated |
|---|---|---|
| 1 | **Is there a cast?** Does `UNCLE SALLY` at the top of a card mean something by the second run, or are these sixteen interchangeable name-plates? | cast.md's whole premise is recognition. No harness can tell you whether a name landed. |
| 2 | **Is anything running out?** Does the player feel pressure — and specifically, do they notice blood, which has no number, no icon and no explanation? | The meters are legible to code and invisible to the player by design. Whether that reads as tension or as noise is a human fact. |
| 3 | **Is there a story, or just cards?** After four batches of chain-delivery work, does a person notice that some cards are part of something? | 19.3% of a median run is chain beats. Whether that is *perceived* is the open question, and it is the one the batch-9 finding hangs on. |

**The numbers are already known and are not what this session is for.** Meter
nets, band shares, gating depth, blood distribution, ending reachability and
chain-completion rates are all measured and recorded in
[content-bible.md](content-bible.md). Do not spend the session confirming them.

---

## The two hooks

Built in [playtest.dart](../lib/playtest.dart), switched on from the URL, off in
every other circumstance. Neither changes a single value the player sees.

| Hook | URL | What it does |
|---|---|---|
| **trace** | `?trace=1` | Records every swipe silently and prints the run to the browser console at each death. **Never to the screen.** |
| **seed** | `?seed=100` | Fixes the draw, so the last run reliably delivers a six-beat storyline. |

**Why the trace is silent and read late.** The session asks the player what they
remember *before* anyone looks at what actually happened. If the facilitator can
see the run while it is played, they will ask leading questions about it without
meaning to, and the one measurement worth taking is gone. Open devtools before
the session starts and put the console on a second screen or minimise it.

**Why seed 100.** Chosen by [burnseed.dart](../test/burnseed.dart), which
searched 4,000 seeds. It is the only one where `b6_076` — *Lucia's boy*, the
six-beat burn — opens under **all 27** play policies tried, and it completes
under 24 of them. A seed fixes the draw but not the player, so a seed that only
works if the participant plays a particular way is worthless; this one does not
depend on how they play. It is pinned by a test so it cannot rot.

---

## Setting up

```
flutter build web --release
node tools/playtest_server.js
```

The server prints the four URLs. Check before the participant arrives:

- [ ] The build is **release**, not debug — a debug banner changes how people behave.
- [ ] Devtools console is open and **out of the participant's sight**.
- [ ] The window is **portrait-ish**. The layout was designed for a phone; a
      maximised desktop window is not what this game is.
- [ ] You have somewhere to write. **Write what they say, in their words.**
- [ ] Nothing on screen shows a number. There should be four dimming icons and a
      block of text, and nothing else.

---

## The session

Four runs. **Roughly 35–45 minutes.** Do not rush runs 1–3 to get to the
questions; the questions are only worth anything if the runs were played
properly.

### Before anything

Say exactly this much and no more:

> "You're the boss of a crime family in Brooklyn in the sixties. People come to
> you with problems. Swipe left or right. That's all of it — I'm not going to
> explain anything else, and if you ask me a question during the run I'm going
> to say *do whatever you think*."

**Do not mention:** meters, blood, family/commission/cops/cash, that there are
900 cards, that some cards connect to each other, or that anyone recurs. Every
one of those is a thing the session is trying to find out whether they notice.

### Run 1 — unguided

`http://localhost:8080/?trace=1&label=run1`

Say nothing. Let them die. If they ask what a meter is, say *do whatever you
think*, and note that they asked — a question at swipe 3 and a question at swipe
30 mean different things.

**Watch for and write down:** where their eyes go, whether they read the whole
card or just the labels, and the first time they hesitate. **The first long
pause is data.** Note the swipe number.

### Between run 1 and run 2 — the cast question

Ask, in this order, and stop after the first one they cannot answer:

1. **"Who was in that?"**
2. If they name anyone: **"What did they want?"**
3. **"Was there anyone you were glad to see?"** — and if yes, *"what happened the
   time before?"*

**Do not name anybody first.** The entire question is whether a name arrives
unprompted. If they say "the uncle" or "the wife" rather than *Sally* or
*Giulia*, that counts and it is a different answer from a surname — write down
which form they used.

**What a good result looks like:** two or three characters unprompted, at least
one with a want attached. **What a bad result looks like:** "some guys" — or
they name a *card* rather than a person.

### Run 2 — unguided

`http://localhost:8080/?trace=1&label=run2`

Still say nothing. This is the run where recognition should start doing work, so
watch for it: a card they react to faster, a name they say out loud, a visible
"oh, this guy again".

### Between run 2 and run 3 — the blood question, not named

Ask exactly:

> **"Was there anything you were running out of?"**

**Do not say the word blood.** Do not say counter, meter, resource, family, or
point at the screen. This is the question batch 6's succession work left behind
and it has to be asked cold, because blood has no number and no icon and its
only consumer is which son inherits. If they have to be told it exists, it does
not exist.

Follow up only with:
- **"What made you think that?"**
- **"Could you have stopped it?"**

If they name blood or describe it without a word for it — *"the family stuff",
"I kept losing people"* — that is the strongest possible result and you should
get their exact phrasing down verbatim.

### Run 3 — unguided

`http://localhost:8080/?trace=1&label=run3`

Last of the honest runs. By now they have a strategy; note what they think it is
if they volunteer one, but **do not ask for it yet**.

### After run 3 — the conversation, before the trace

**The trace stays closed until this is finished.** Ask, in order:

1. **"What were you trying to do?"**
2. **"Was there a moment you felt you'd got something wrong?"**
3. **"Did any of it join up? Did anything carry over from one card to another?"**
   — the story question, asked without the word *chain* or *story*.
4. **"If you played again tomorrow, what would you do differently?"**
5. **"Was any of it funny?"** — Matty is written to be funny right up until he is
   not, and nobody has ever checked whether that lands.

Only now open the console and read the traces.

### Run 4 — the seeded burn, recorded separately

`http://localhost:8080/?trace=1&seed=100&label=burn`

**This one is different and is scored on its own.** It reliably delivers
`b6_076` — the six-beat storyline in which the player's nephew is killed. It is
the most effortful writing in the deck and, under ordinary play, most runs never
see anything this long.

Say only: *"One more."*

**Watch for the beats, and write down the swipe number of each reaction.** The
arc is: three kids from Ridgewood start saying *Matty Ricci's people*; a paper
bag of somebody else's money; a Provenzano capo saying the nephew's name and the
player's in one sentence; Lucia in Giulia's kitchen asking whether her son will
be alive at Christmas; and then no third answer.

Afterwards, ask:

1. **"What was that about?"** — can they narrate it back as one thing?
2. **"When did you know how it was going to end?"**
3. **"Was that different from the other three?"** — asked neutrally. **If they
   say no, that is the most important finding of the session** and it means the
   chain-delivery work is invisible to a player, which is exactly the question
   batch 9's opener-reach finding was left open on.

---

## Recording it

Afterwards, write into [content-bible.md](content-bible.md) under a new
**Playtest** section:

- **What they said, in their words.** Quotes, not paraphrase. A paraphrase of a
  playtest is a summary of your own opinion.
- The trace JSON for all four runs.
- Swipe numbers for every hesitation and reaction you noted.
- **What you did not find out**, which matters as much. A question they answered
  with a shrug is a question that was asked wrong.

**Do not tune anything during or immediately after the session.** One person is
one person. The standing instruction from batch 5 holds until there is a reason
to change it, and one session is a reason to *think*, not a reason to ship a
different vice quota.

---

## The thing most likely to go wrong

**Talking.** The instinct to explain the game while somebody plays it is
extremely strong and it destroys the session — every question this is built to
answer is a question about what the player worked out on their own. If you say
*"that one's your uncle"*, question 1 is gone for the rest of the session and it
cannot be recovered.

Write down the urge instead. What you wanted to explain is a list of what the
game fails to say for itself, and that list is worth having.

---

## List B — the agenda for a fresh player

**Untouched by the editorial work, and it stays that way.** Every item here is
one the author is structurally disqualified from answering, because he wrote the
cards and cannot un-know them. This is what the session in
[playtest.md](playtest.md) is for.

**Ranked by how much rides on the answer.**

### 1. Does a careful human find the game unlosable?

**The strongest candidate for what a fresh player will report, and the largest
open risk in the project.** A *cautious* policy — one card deep, taking whichever
side leaves the worst meter closest to the middle, with no lookahead —
**survives to the 500-swipe cap in 58% of 2,000 runs.**

That number matters precisely because it is not the greedy oracle. Batch 5
closed simulation tuning on the argument that the oracle recomputes perfectly
and no human does, so its survival was not evidence about people. This policy
does not recompute perfectly. It is about as much thought as an attentive player
gives a card, and it mostly does not die.

If a careful person plays three runs and none of them ends, **that is a bigger
problem than every writing finding in this document combined**, and no amount of
prose fixes it. Ask it with *"did you ever think you were going to lose?"* and
watch run length rather than trusting the answer.

### 2. Is there a cast at all?

Does an unprompted name come back after two runs, or is it "some guys"? The
Aurelio/Adler fix, the speaker budgets and the whole 900-card recognition
premise all assume the answer is yes, and it has never been tested on anyone.

### 3. Does the arc structure register?

The seeded burn run's *"was that different from the other three?"* If no, chain
delivery is invisible to a player and the opener-reach finding is moot.

### 4. Does blood register without being named?

Untestable by the author: he knows it is there. Ask *"was there anything you were
running out of?"* and nothing more specific.

### 5. Is the stop-on / swipe-past ratio anywhere near 83/17?

That was one author's read of 35 cards in a real run order. A stranger is
probably nearer 60/40. Have them mark the same 35.

### 6. Do the vices read as pressure or as unfairness?

The design intent is legible to the author and would not be to a player who
meets three of them in ten swipes.

### 7. Does the ending feel like the run they just played?

The ending texts were rewritten for a 23-swipe median, and the distribution was
corrected so all eight fire. Whether the paragraph lands as consequence is still
a human question.

### 8. Is Matty funny?

He is the deck's most distinct voice, the joke is deliberate, and it has never
been tested on anybody.
