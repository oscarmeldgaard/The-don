# Flag Registry

**STATUS: APPROVED**, with [cast.md](cast.md) and on the same terms — retroactive
from batch 1, settled during batch 6. This file's banner said *do not write cards
until both are marked APPROVED*, so approving cast.md alone would have left the
same stale instruction one file over.

Every flag any card may reference, in `setFlags`, `requires.flags`, or
`requires.excludesFlags`. This document is the source; [flags.dart](../lib/flags.dart)
is the enforcement copy of it. A flag that is not here does not exist, and
[card_validator.dart](../lib/card_validator.dart) will fail the test suite on
sight of one.

---

## The one engine constraint that shaped all of this

`GameState.choose` only ever calls `_activeFlags.addAll`
([game_state.dart:118](../lib/game_state.dart#L118)). **Nothing clears a flag
mid-run.** A flag is set once and stays set until `restart()`.

So there is no way to express *"has Kiernan been paid this month"* — it would
latch on the first payment and never come off. Every running state below is
therefore written as a **one-way ratchet**: not a toggle that flips back and
forth, but a notch that only ever advances. Kiernan's price goes up, and up
again, and never comes down. Sally is humiliated, and stays humiliated.

This is a better fit for the material than a toggle would have been — nobody
in this family forgets anything — but it costs one thing, noted at the bottom
under **Pending engine changes**, and it is the only place it hurts.

**Rule for card authors: never set a flag you would want to unset later.** If
a card wants to walk something back, that is a *second, further* flag —
`sally_backed` after `sally_humiliated`, not the removal of the first.

---

## World state

The state of the family and the city, independent of any one person.

| Flag | Means | Typically set by |
|---|---|---|
| `at_war` | An answered killing. Open hostilities with another family. | Any retaliation card |
| `docks_taken` | The Brooklyn pier operation was seized outright. | Docks cards |
| `commission_snubbed` | A Commission sit-down was refused. | `DON BRACA` cards |
| `dope_sanctioned` | The player has let narcotics run, tacitly or otherwise. | `DUKE`, `MOE WILLS` |
| `dope_banned` | The player has enforced the ban publicly, in front of the crews. | `UNCLE SALLY`, `AURELIO` |
| `feds_active` | Federal attention, as distinct from the NYPD. Kiernan cannot help with this. | `ADLER`, `FALLON`, `DET. RANIERI` |
| `books_open` | A making ceremony is currently possible. Gates `matty_made`. | `UNCLE SALLY`, `DON BRACA` |
| `house_split` | The family has visibly divided. Crews know which side they're on. | Consequences of `sally_moved` |

`dope_sanctioned` and `dope_banned` are **mutually exclusive in practice** —
no card may set one without excluding the other. That pairing is the safety
fault line in flag form, and most of the interesting gating in the deck hangs
off it.

---

## Character running state

Silence flags are marked **†**. Every card spoken by a character must carry
every one of their † flags in `requires.excludesFlags`.

### 1. `UNCLE SALLY`

| Flag | Means |
|---|---|
| `sally_humiliated` | Overruled or contradicted in front of other men. |
| `sally_backed` | The player sided with him on something that cost real money or face. |
| `sally_faction` | He is gathering people. Names are being counted. |
| `sally_moved` | He has moved against the player openly. Point of no return. |
| `sally_retired` | Sent away — Florida, the old country, a quiet house. Still calls. Not silence. |
| `sally_dead` **†** | |

### 2. `GIULIA` — no silence flag, by design

| Flag | Means |
|---|---|
| `giulia_told` | She was told a specific thing outright, rather than working it out. |
| `giulia_lied_to` | The player lied and she caught it. Does not expire. |
| `giulia_shielded` | The player kept blood away from the house at a real cost. |
| `giulia_home_touched` | Violence reached the house itself. |
| `giulia_left` | She took the children out. Changes where she speaks from, not whether. |

### 3. `CONCETTA`

| Flag | Means |
|---|---|
| `concetta_blessing` | She has publicly approved of how the player is running it. |
| `concetta_sided_sally` | She sided with the uncle, in front of the family. |
| `concetta_silent` | She has stopped speaking to the player. Not silence for card purposes — she is spoken *about*, and other cast members carry it. |
| `concetta_dead` **†** | |

### 4. `MATTY`

| Flag | Means |
|---|---|
| `matty_made` | Straightened out. Requires `books_open`. |
| `matty_killed_wrong` | The killing he should not have done. The deck's central young-man event. |
| `matty_covered` | The player cleaned it up. Only meaningful after `matty_killed_wrong`. |
| `matty_disowned` | Put out of the family. Still the player's sister's son. |
| `matty_pinched` | Arrested and facing real time. |
| `matty_dead` **†** | |

### 5. `AURELIO`

| Flag | Means |
|---|---|
| `aurelio_overruled` | The player went against his counsel on something large. |
| `aurelio_wrong_proven` | His advice was followed and it cost the family, demonstrably. The one that matters. |
| `aurelio_doubted` | The player asked someone else first, and he found out. |
| `aurelio_failing` | Age is taking him. His counsel gets less reliable, not less confident. |
| `aurelio_dead` **†** | |

### 6. `DUKE`

| Flag | Means |
|---|---|
| `duke_dope` | He is running narcotics, sanctioned or not. |
| `duke_warned` | Told once, formally, in front of a witness. |
| `duke_broke_off` | Took his crew and the third of the income with it. |
| `duke_proven_loyal` | Had a clear opportunity to move and did not take it. |
| `duke_dead` **†** | |

### 7. `ANGELO`

| Flag | Means |
|---|---|
| `angelo_paid` | Made whole — the held money, the position, or both. |
| `angelo_suspected` | The family has decided he must have talked. May be set without the player's involvement. |
| `angelo_flipped` | He is cooperating. Should only be reachable via `angelo_suspected` without `angelo_paid`. |
| `angelo_dead` **†** | |

### 8. `CAPT. KIERNAN` — on the payroll at card one

| Flag | Means |
|---|---|
| `kiernan_price_up` | First raise. |
| `kiernan_price_up_2` | Second raise. Requires `kiernan_price_up`. |
| `kiernan_refused` | The player said no once. Survivable. |
| `kiernan_cold` | Stopped returning calls. Should require `kiernan_refused`. |
| `kiernan_gone` **†** | Transferred, retired, or indicted. Off the board. |

### 9. `DET. RANIERI`

| Flag | Means |
|---|---|
| `ranieri_watching` | He has the family specifically, not generally. |
| `ranieri_offered` | Someone tried to buy him. The insult, not the transaction. |
| `ranieri_case_open` | A live case with the family's name on it. |
| `ranieri_family_touched` | Someone went at his people. Catastrophic and irreversible. |
| `ranieri_dead` **†** | Killing him should be close to run-ending. |

### 10. `DON BRACA`

| Flag | Means |
|---|---|
| `braca_sponsor` | He is vouching for the player at the Commission. |
| `braca_owed_him` | The player owes him a favour. Will be called in. |
| `braca_owes_you` | He owes the player. Worth more unspent than spent. |
| `braca_insulted` | A slight he has registered and not mentioned. |
| `braca_dead` **†** | |

### 11. `FALLON`

| Flag | Means |
|---|---|
| `fallon_pension_touched` | The local's pension fund has been borrowed against. Should imply `feds_active` eventually. |
| `fallon_squeezed` | Taken from harder than the local can carry. |
| `fallon_indicted` | Charged. A desperate man with something to trade. |
| `fallon_replaced` | Lost his local. |
| `fallon_dead` **†** | |

### 12. `ADLER`

| Flag | Means |
|---|---|
| `adler_legit_front` | Money has been structured into something with a tax return. |
| `adler_subpoenaed` | The ledgers have been asked for, formally. |
| `adler_skimming` | He is taking. Whether the player knows is a separate matter. |
| `adler_ran` **†** | Gone, with or without the books. |
| `adler_dead` **†** | |

### 13. `MOE WILLS`

| Flag | Means |
|---|---|
| `wills_partner` | A real partnership, not a street tax. |
| `wills_stopped_paying` | The tax has stopped and nothing has been done about it. |
| `wills_dope` | He has his own connection, of the kind the Commission forbids. |
| `wills_war` | Open conflict north of the parkway. |
| `wills_dead` **†** | |

### 14. `ROSA`

| Flag | Means |
|---|---|
| `rosa_forgiven` | The debt was written off. |
| `rosa_place_taken` | The restaurant was taken for the debt. |
| `rosa_place_burned` | Burned for the insurance. |
| `rosa_gone` **†** | Left the neighbourhood. |

### 15. `FATHER COLLA`

| Flag | Means |
|---|---|
| `colla_roof_paid` | The parish got its money. |
| `colla_refused_you` | Refused a burial, a blessing, or to be seen with the player. |
| `colla_warned_you` | Said the sentence at the end that was not about parish business. |
| `colla_gone` **†** | Transferred out by the diocese. |

### 16. `DR. NARDI`

| Flag | Means |
|---|---|
| `nardi_debt_cleared` | The sports-book debt is gone. So is the leverage. |
| `nardi_used` | Called out to patch someone up off the books. |
| `nardi_talked` | His nerve failed. |
| `nardi_gone` **†** | |

---

## Chain flags

Flags whose only job is to hold a multi-card chain together: an opening card
sets one on **both** sides, and the follow-up requires it. They record *"this
conversation has happened"*, not *"it went this way"* — the branch is carried
by the character flags set alongside them. Written this way so a chain never
dead-ends on the branch the player didn't take.

Added by **batch 1**.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `matty_wills_bill` | Moe Wills has presented the bill for the body Matty left. | `b1_077` (both) | `b1_078` |
| `matty_answered` | The family has formally ruled on what Matty is now. | `b1_078` (both) | `b1_079` |
| `angelo_home_asked` | Angelo has asked, out loud, for the money held for his eight years. | `b1_080` (both) | `b1_081` |
| `angelo_question` | Whether Angelo talked inside has been raised at the table. | `b1_081` (both) | `b1_082` |
| `fallon_pension_asked` | Fallon has proposed the loan out of the local's pension fund. | `b1_083` (both) | `b1_084` |
| `fallon_desperate` | The local's decline is no longer deniable and Fallon is trading on it. | `b1_084` (both) | `b1_085` |
| `rosa_asked` | Rosa has proposed paying the debt in kind rather than cash. | `b1_088` (both) | `b1_089` |
| `duke_spoke` | Duke has put the narcotics question to the player directly. | `b1_090` (both) | `b1_091` |
| `braca_freight` | The airport freight has been discussed with Braca. | `b1_092` (both) | `b1_093` |
| `aurelio_frame_ranieri` | Aurelio has given his counsel on the Ranieri problem. | `b1_094` (both) | `b1_095` |

Added by **batch 2**. Twelve, and no new world or character flags — batch 2
spends batch 1's currency rather than printing more.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `matty_button` | What the newly-made nephew is entitled to has been put to the table. | `b2_076` (both) | `b2_077` |
| `matty_own_piece` | The family has settled what piece Matty gets and who he answers to. | `b2_077` (both) | `b2_078` |
| `ledger_day` | The linen company's books have been asked for, formally, in person. | `b2_079` (both) | `b2_080` |
| `ledger_answered` | The family has decided how the bookkeeper answers the paper. | `b2_080` (both) | `b2_081` |
| `duke_lunches` | Duke has disclosed that another family is courting him. | `b2_082` (both) | `b2_083` |
| `duke_held` | The table has ruled on what Duke is given, or taken off, to keep him. | `b2_083` (both) | `b2_084` |
| `duke_short` | Bushwick's envelope has come in light and somebody has noticed. | `b2_084` (both) | `b2_085` |
| `giulia_house` | The house on Long Island has been raised out loud. | `b2_086` (both) | `b2_087` |
| `kiernan_owed_name` | Kiernan has asked for a body for his clearance rate. | `b2_088` (both) | `b2_089` |
| `angelo_watched` | The family has acted on the suspicion rather than sat with it. | `b2_090` (both) | `b2_091` |
| `braca_after` | Braca has raised, out loud, what happens at the Commission after him. | `b2_092` (both) | `b2_093` |
| `wills_building` | The Halsey Street building has been discussed with Moe Wills. | `b2_094` (both) | `b2_095` |

Added by **batch 3**. Thirteen, and again no new world or character flags — batch 3
spends what batches 1 and 2 printed, and gives first setters to eleven flags that
had none.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `sally_count` | The uncle's counting has become a road envelopes travel, and it has been noticed by name. | `b3_076` (both) | `b3_077` |
| `sally_asked_open` | He has asked for a crew of his own, out loud, in front of the table. | `b3_077` (both) | `b3_078` |
| `sally_two_doors` | The consigliere has named the split as a split. | `b3_078` (both) | `b3_079` |
| `sally_house_edge` | Concetta has been asked to spend her voice, one way or the other. | `b3_079` (both) | `b3_080` |
| `sally_last_table` | The crews have physically separated and the house knows it. | `b3_080` (both) | `b3_081` |
| `pinto_policy` | The insurance arithmetic on Pinto's has been laid in front of the player. | `b3_082` (both) | `b3_083` |
| `pinto_winter` | Rosa has noticed the man who came to look at her wiring. | `b3_083` (both) | `b3_084` |
| `house_window` | Someone fired into the player's house. | `b3_085` (both) | `b3_086` |
| `window_answered` | The family has ruled on whether the house is answered for. | `b3_086` (both) | `b3_087` |
| `kiernan_third` | The sergeant's envelope has become its own question. | `b3_088` (both) | `b3_089` |
| `braca_last` | Braca's dying has been acted on rather than heard about. | `b3_090` (both) | `b3_091` |
| `bushwick_after` | The family has ruled on men following Duke out of the door. | `b3_092` (both) | `b3_093` |
| `nardi_asked` | The doctor has been questioned by people with a photograph. | `b3_094` (both) | `b3_095` |

Added by **batch 4**. Twelve, and again no new world or character flags — batch 4
gives first setters to five flags that had none anywhere in the deck
(`aurelio_failing`, `aurelio_dead`, `wills_war`, `ranieri_family_touched`,
`adler_skimming`) and reads twenty-one flags earlier batches set.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `aurelio_two_pages` | The consigliere has found his own handwriting disagreeing with itself, and said so out loud. | `b4_076` (both) | `b4_077` |
| `aurelio_second_chair` | Whether a younger man sits beside the consigliere has been settled in front of the table. | `b4_077` (both) | `b4_078` |
| `aurelio_last_counsel` | The consigliere has asked to be finished by the player rather than by the room. | `b4_078` (both) | `b4_079` |
| `wills_bags` | Collectors came back off the Bed-Stuy line without the bags and were told to say why. | `b4_080` (both) | `b4_081` |
| `wills_answer` | The player and Moe Wills have spoken about what replaces the old understanding. | `b4_081` (both) | `b4_082` |
| `ranieri_bakery` | The bakery on Central Avenue has been identified, by name, as the detective's father's. | `b4_083` (both) | `b4_084` |
| `bakery_asked` | Ranieri has asked, once, in the street, about his father's shop. | `b4_084` (both) | `b4_085` |
| `hall_spring` | The seized local's spring election and its federal observer have been put to the player. | `b4_086` (both) | `b4_087` |
| `sally_florida_call` | The retired uncle has telephoned from Florida with a question of his own. | `b4_088` (both) | `b4_089` |
| `matty_offer` | The nephew inside has been offered eighteen months with a condition on it. | `b4_090` (both) | `b4_091` |
| `concetta_sunday_word` | The mother's sentence on Sunday has been felt outside the family. | `b4_092` (both) | `b4_093` |
| `adler_short_page` | A crew's counted figure and the bookkeeper's figure have been found not to match. | `b4_094` (both) | `b4_095` |

Added by **batch 5**. Twelve, and again no new world or character flags — batch 5
gives first setters to `ranieri_dead` and `fallon_dead`, and reads nineteen flags
earlier batches set.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `ranieri_line` | Somebody has said out loud, at the family's own table, what ought to be done about the detective. | `b5_076` (both) | `b5_077` |
| `ranieri_stayed` | He turned down the transfer and said so himself. | `b5_077` (both) | `b5_078` |
| `ranieri_table` | The Commission's rule about policemen has been put to the house as a question. | `b5_078` (both) | `b5_079` |
| `fallon_last` | The union man's heart has been raised, by him, in private. | `b5_080` (both) | `b5_081` |
| `fallon_after` | The family has decided what it does about the local before it is empty. | `b5_081` (both) | `b5_082` |
| `state_lottery` | The state's own numbers game has been put in front of the player. | `b5_083` (both) | `b5_084` |
| `lottery_answer` | Bed-Stuy has asked what the street tax is for now. | `b5_084` (both) | `b5_085` |
| `truck_offer` | Somebody has offered to buy the trucking company outright. | `b5_086` (both) | `b5_087` |
| `funeral_asked` | A made man's funeral has been arranged, loudly or quietly. | `b5_088` (both) | `b5_089` |
| `reporter_asking` | A young man with a notebook is working Knickerbocker Avenue. | `b5_090` (both) | `b5_091` |
| `terminal_bid` | The air freight terminal contract has been raised. | `b5_092` (both) | `b5_093` |
| `young_blood` | A soldier's son has asked how a man starts. | `b5_094` (both) | `b5_095` |

Added by **batch 6**. Thirteen, and again no new world or character flags — batch 6
gives first setters to `matty_dead`, `rosa_gone` and `colla_gone`, and reads
twenty-one flags earlier batches set.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `ridgewood_boys` | Three young men from Ridgewood have attached themselves to the player's nephew, in public and by name. | `b6_076` (both) | `b6_077` |
| `ridgewood_bag` | Money the boys took off nobody's lot is sitting in the back room of the club. | `b6_077` (both) | `b6_078` |
| `ridgewood_named` | Another family has used the nephew's name and the player's in the same sentence. | `b6_078` (both) | `b6_079` |
| `lucia_asked` | The boy's mother has asked, through the player's wife, whether her son will be alive at Christmas. | `b6_079` (both) | `b6_080` |
| `matty_ruling` | The house has been told, in the mother's kitchen, what the other family wants done about the nephew. | `b6_080` (both) | `b6_081` |
| `chair_list` | A capo has put names forward for the open chairs, out loud, in front of the table. | `b6_082` (both) | `b6_083` |
| `chair_vote` | The men who are not on the list have worked out that they are not on it. | `b6_083` (both) | `b6_084` |
| `linen_offer` | A legitimate contract with an auditor attached has been put to the linen company. | `b6_085` (both) | `b6_086` |
| `linen_signed` | The family has settled whether the linen company can go on being two things at once. | `b6_086` (both) | `b6_087` |
| `rosa_leaving` | Rosa has asked, out loud, whether a person is allowed to leave the neighbourhood. | `b6_088` (both) | `b6_089` |
| `colla_letter` | The diocese has asked the priest whether he is content in the parish. | `b6_090` (both) | `b6_091` |
| `paolo_asked` | The player's son has asked his mother what his father does all day. | `b6_092` (both) | `b6_093` |
| `wills_connection` | Moe Wills has told the player, first and himself, about an offer the Commission has a rule about. | `b6_094` (both) | `b6_095` |

Added by **batch 7**. Twelve, and again no new world or character flags — batch 7
gives first setters to `concetta_dead` and `adler_dead`, and reads twenty-two
flags earlier batches set.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `aldo_box` | The uncle has said out loud that his brother kept something behind the boiler and that nobody telephoned him about it. | `b7_076` (both) | `b7_077` |
| `box_counted` | The bookkeeper has been asked where money with no page of its own is supposed to go. | `b7_077` (both) | `b7_078` |
| `box_word` | The widow has been sat with while she counted it, and the wife will not be the second person keeping it quiet. | `b7_078` (both) | `b7_079` |
| `laundry_audit` | The hospital contract's auditor has asked, in writing, about a payment the company cannot explain in writing. | `b7_080` (both) | `b7_081` |
| `audit_answer` | The family has settled how the bookkeeper answers a man who has offered him immunity. | `b7_081` (both) | `b7_082` |
| `braca_asks_uptown` | The Commission has raised the Bed-Stuy arrangement with the player, privately, before saying his name. | `b7_083` (both) | `b7_084` |
| `uptown_ruling` | The house has decided what the uncle says at that table in three weeks. | `b7_084` (both) | `b7_085` |
| `himrod_shop` | Two of the family's men have been found taxing the player's wife's father. | `b7_086` (both) | `b7_087` |
| `concetta_giving` | The mother has begun giving her husband's things away and has said so herself. | `b7_088` (both) | `b7_089` |
| `ceremony_day` | Where and when the books open has been settled out loud. | `b7_090` (both) | `b7_091` |
| `bank_line` | A bank has offered the linen company credit against a personal guarantee with the player's name on it. | `b7_092` (both) | `b7_093` |
| `club_lease` | The building the club sits in has been sold over the family's head. | `b7_094` (both) | `b7_095` |

Added by **batch 8**. Twelve, and again no new world or character flags — batch 8
gives first setters to `duke_dead` and `wills_dead`, and reads eighteen flags
earlier batches set through `requires.flags` and thirty-eight in all.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `bushwick_number` | The best earner has worked out the family's whole number by himself and said it out loud at the table. | `b8_076` (both) | `b8_077` |
| `bushwick_hands` | Whether the capo is losing his crew or keeping his hands clean has been put to the house as a question. | `b8_077` (both) | `b8_078` |
| `bushwick_answer` | The bookkeeper has been made to write down where a figure that is too large came from. | `b8_078` (both) | `b8_079` |
| `uptown_verdict` | The Commission has asked, in a garden, that the Bed-Stuy arrangement be seen to by the people who know the man. | `b8_080` (both) | `b8_081` |
| `wills_told` | Moe Wills has been told, to his face, whether he goes. | `b8_081` (both) | `b8_082` |
| `paolo_jersey` | The player's son has been offered a way out of the neighbourhood that does not end with him coming back. | `b8_083` (both) | `b8_084` |
| `jersey_counted` | The crews have found out where the boss's boy is going to sleep, and have counted it. | `b8_084` (both) | `b8_085` |
| `guarantee_asked` | The bank has asked for a notarised statement of what the player personally owns. | `b8_086` (both) | `b8_087` |
| `new_men_month` | A newly made man has asked, a month late, what he is now. | `b8_088` (both) | `b8_089` |
| `club_shut` | There is a padlock on the Knickerbocker Avenue door and forty men on the pavement. | `b8_090` (both) | `b8_091` |
| `nardi_finished` | The doctor has asked to be let go, with what he took out of a man still on his shelf. | `b8_092` (both) | `b8_093` |
| `grand_jury` | A federal grand jury has named the player as a witness rather than a target. | `b8_094` (both) | `b8_095` |

Added by **batch 9**. Twelve, and again no new world or character flags — batch 9
gives the first setter to the one flag left in this file that had none,
`sally_dead`, and reads twenty-four flags earlier batches set through
`requires.flags` and forty-nine in all.

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `sally_told_them` | The uncle has said out loud that men are calling themselves his, that he never asked them to, and that he cannot stop them. | `b9_076` (both) | `b9_077` |
| `sally_door_asked` | Soldiers have been asked to their faces which way they would go, and have reported it. | `b9_077` (both) | `b9_078` |
| `sally_thursday` | The uncle's wife has asked the player's wife whether her husband will be at his own table at Christmas. | `b9_078` (both) | `b9_079` |
| `house_kept` | The wife has said out loud that she knows what has been kept out of the house, and has asked to be allowed to know it. | `b9_080` (both) | `b9_081` |
| `house_named` | The club has begun treating the boss's wife as a figure rather than a person, and has been answered one way or the other. | `b9_081` (both) | `b9_082` |
| `linen_return` | The linen company's tax return has to be signed, and the house has settled whose name goes at the bottom. | `b9_083` (both) | `b9_084` |
| `return_signed` | There is a paper in a public office with this family's earnings on it and a man's name under them. | `b9_084` (both) | `b9_085` |
| `angelo_asked_chair` | The soldier who did nine years has asked, out loud and in front of people, to be considered for a crew. | `b9_086` (both) | `b9_087` |
| `braca_called` | The Commission's man has asked to have his debt named, and been given an answer. | `b9_088` (both) | `b9_089` |
| `local_wound_up` | The International's move to merge the local into Newark has been answered. | `b9_090` (both) | `b9_091` |
| `matty_asked_out` | The nephew's mother has offered him a job at a printer's and a room in Ridgewood. | `b9_092` (both) | `b9_093` |
| `pinto_asked_winter` | The priest has reported that Rosa Pinto has moved to the eight o'clock Mass, and the house has decided whether to ask her why. | `b9_094` (both) | `b9_095` |

## World state — batch 1 addition

| Flag | Means | Set by | Read by |
|---|---|---|---|
| `rosa_room` | The upstairs room at Pinto's is a family meeting place, taken in lieu of the debt. | `b1_088` left | `b1_096` (excludes), `b2_075` |

---

## Counts

| | |
|---|---|
| World state | 9 |
| Character running state | 77 |
| Chain flags | 108 (10 batch 1, 12 batch 2, 13 batch 3, 12 batch 4, 12 batch 5, 13 batch 6, 12 batch 7, 12 batch 8, 12 batch 9) |
| **Total active** | **194** |
| Silence flags among them | 16 |

**At 900 cards every flag in this file has at least one setter.** `sally_dead`
was the last one that did not; `b9_079` sets it on both sides. Two flags are
read only through `excludesFlags` and never through `requires.flags` —
`angelo_dead` and `sally_moved` — which is the job they exist to do.

### Situational silence — settled in batch 3

Batch 2 left one question open deck-wide: `matty_pinched` is not a silence flag,
so by the letter of hard rule 2 a Matty card could surface while he is in the
Tombs. **Batch 3 settles it without promoting anything to †.**

A flag is *situationally silencing* for a character when it does not remove them
from the deck but does contradict a particular kind of card. The rule is by
setting, not by person:

| Flag | Silences | Still speaks |
|---|---|---|
| `matty_pinched` | `MATTY` on the street or at the club | from a telephone or a visiting room (`b3_056`) |
| `matty_disowned` | `MATTY` on family business | as an outsider volunteering (`b1_099`) |
| `sally_moved`, `house_split` | `UNCLE SALLY` on ordinary house business | in the split itself, and after it (`b3_100`) |
| `giulia_left` | `GIULIA` in the marital house | from her sister's kitchen (`b3_097`) |
| `duke_broke_off` | `DUKE` on the family's business | from outside, cordially (`b2_096`, `b3_093`) |
| `angelo_flipped` | `ANGELO` asking to be trusted | asking anyway, both of you knowing (`b2_100`) |
| `kiernan_cold` | `CAPT. KIERNAN` doing favours | when the ratchet turns again (`b2_062`) |
| `rosa_place_taken`, `rosa_place_burned` | `ROSA` in her own dining room | behind somebody else's counter (`b1_096`) |
| `fallon_replaced` | `FALLON` speaking for a local | as a man without one (`b3_062`) |
| `docks_taken` | the offer to take the local (`b3_046`) | — |
| `aurelio_failing` | the opening of the two-pages chain (`b4_076`) | everywhere else — he is not silenced, he is slower (`b4_074`) |
| `wills_war` | `MOE WILLS` and the Bed-Stuy line as ordinary business | the street reporting the line (`b4_097`) |
| `ranieri_family_touched` | `DET. RANIERI` as a neighbour | as a man with a file and a date (`b4_098`) |
| `nardi_talked` | `DR. NARDI` at his own surgery | in a folder somebody else has read (`b4_100`) |
| `ranieri_dead` | `DET. RANIERI` entirely, and every card that assumes a policeman can be talked to | the city afterwards (`b5_096`) |
| `fallon_dead` | `FALLON`, and the local as a thing with a friend at the top of it | the pier without him (`b5_097`) |
| `matty_dead` | `MATTY` entirely, and every card that treats the nephew as a problem still running | the mother who has stopped saying the player's name (`b6_096`) |
| `rosa_gone` | `ROSA`, and the restaurant as a place with her in it | the empty windows on Grove Street (`b6_097`) |
| `colla_gone` | `FATHER COLLA`, and the parish as somewhere the family is known | the new priest, through Concetta (`b6_098`) |
| `concetta_dead` | `CONCETTA` entirely, and every card that carries the mother's house as somewhere still lived in | the wife, with her keys in her bag (`b7_096`) |
| `adler_dead` | `ADLER` entirely, and every card in which somebody is doing the family's arithmetic | the capo who wants to bring a man in from Rego Park (`b7_097`) |
| `duke_dead` | `DUKE` entirely, and every card that treats Bushwick as a crew with somebody at the top of it | the envelope eleven men counted for themselves (`b8_096`) |
| `wills_dead` | `MOE WILLS`, and the Bed-Stuy line as a thing that can be negotiated with | the week nobody north of the parkway wrote a number (`b8_097`) |

These count as **flag-free** where `requires.flags` is empty: they are the same
kind of addition as a silence flag, and the batch-1 convention in
[content-bible.md](content-bible.md) is extended rather than broken. A batch that
adds one of these to a card is suppressing a contradiction, not gating content.

---

## Pending changes to `lib/flags.dart`

**No Dart has been written for any of this.** Recorded here so the change is
one deliberate edit later, not sixteen incidental ones.

1. ~~**Add** all 96 flags above to `GameFlags.registry`.~~ **Done.** They live
   in `GameFlags.deckFlags` — split into `worldFlags`, `characterFlags` and
   `chainFlags` mirroring the sections of this document, and merged into
   `registry`. `batch_1.json` validates clean.

   Kept separate from `runFlags` deliberately: that set carries a test
   contract at [card_deck_test.dart:128](../test/card_deck_test.dart#L128) —
   *every run flag must be settable by some card* — which cannot hold until
   all nine batches exist, since batch 1 legitimately never sets
   `sally_moved`. Fold the two sets together when the deck is complete.

   **A new batch registers its own new flags here and in `flags.dart`, and
   runs the validator to zero, as part of shipping.**

   **Batches 2, 3 and 4 — DONE, during batch 4.** All thirty-seven chain flags
   below are now in `GameFlags.chainFlags`, each under its own `// batch N`
   comment, and all four batch files are in `CardRepository.deckPaths`. The
   snippets are kept as the record of what landed:

   ```dart
   // flags.dart, appended to chainFlags
   // batch 2
   'matty_button', 'matty_own_piece', 'ledger_day', 'ledger_answered',
   'duke_lunches', 'duke_held', 'duke_short', 'giulia_house',
   'kiernan_owed_name', 'angelo_watched', 'braca_after', 'wills_building',
   ```

   For three batches this did not land, so `CardValidator` could not see
   `batch_2.json` at all — it was not in the loaded deck — and the suite was
   green against 100 of 400 cards. That is now impossible: see rule 3 below.

   **Batch 3's thirteen**, landed in the same edit:

   ```dart
   // flags.dart, appended to chainFlags
   // batch 3
   'sally_count', 'sally_asked_open', 'sally_two_doors', 'sally_house_edge',
   'sally_last_table', 'pinto_policy', 'pinto_winter', 'house_window',
   'window_answered', 'kiernan_third', 'braca_last', 'bushwick_after',
   'nardi_asked',
   ```

   `batch_3.json` validates clean against the same faithful port, run over all
   three batch files concatenated — 300 cards, zero issues — plus the three
   rules the Dart validator does not enforce: cast.md hard rule 2, *every
   `requires.flags` entry is set by some card in the deck*, and *every speaker
   is one of the sixteen cast names or the five reserve voices*.

   **Batch 4's twelve**, landed in the same edit:

   ```dart
   // flags.dart, appended to chainFlags
   // batch 4
   'aurelio_two_pages', 'aurelio_second_chair', 'aurelio_last_counsel',
   'wills_bags', 'wills_answer', 'ranieri_bakery', 'bakery_asked',
   'hall_spring', 'sally_florida_call', 'matty_offer',
   'concetta_sunday_word', 'adler_short_page',
   ```

   `batch_4.json` validates clean against the same faithful port run over all
   four batch files concatenated — 400 cards, zero issues — plus the same three
   extra rules. `flutter test` passes 104/104 against the deck as currently
   wired, unchanged by this batch.

   **Batch 5's twelve, batch 6's thirteen, batch 7's twelve and batch 8's twelve**
   landed the same
   way, each in its own batch, under `// batch 5` through `// batch 8`
   comments in `GameFlags.chainFlags`, with each file added to
   `CardRepository.deckPaths` in the same pass. The debt has not stacked since
   batch 4, and `shipped batch deck` (rule 3 below) is what stops it stacking
   again: a written-but-unwired batch now fails the build rather than passing
   it. `flutter test` passes 129/129 over the real 800 cards.

4. ~~**The `dope_sanctioned` / `dope_banned` exclusion is not being kept.**~~
   **Settled and enforced during batch 8.**

   The rule above — *no card may set one without excluding the other* — had been
   broken by `b6_036` and `b6_063` since batch 6, and the consequence was live
   rather than theoretical: `b1_090` left sets `dope_sanctioned`, `b6_036` left
   could then set `dope_banned` in the same run, and at that point all sixteen
   reader cards are eligible at once — six written as *since you banned it* and
   ten as *since the ruling let it run* — against a deck that draws at random.

   **The rule was kept and the two cards were corrected**, not the other way
   round. `b1_090` is the card that opens the thread and it already implemented
   the rule exactly: exclude both, set one on each side, asked once and answered
   once. Batch 6 drifted from that model; the model was not wrong. `b6_036` and
   `b6_063` now carry `dope_sanctioned` and `dope_banned` in `excludesFlags`,
   mirroring it. Nothing is stranded — `dope_sanctioned` keeps two setters,
   `dope_banned` three, every reader stays reachable, and `b6_063`'s own gate
   (`duke_warned`) keeps five routes that leave the ruling untouched. Gating
   only: no text, effect, weight or flag-set changed, and batch 6's balance
   figures are identical.

   **Striking the rule instead was considered and rejected.** It would have put
   the burden on all sixteen reader cards across six shipped batches, each of
   which would then have to survive being drawn after the opposite ruling — a far
   larger and more judgement-laden edit than two `excludesFlags` entries. It also
   fights the ratchet principle at the top of this document: a walk-back is a
   second, further flag, never the removal of the first. Without the exclusion
   the pair is precisely the toggle that can never toggle back.

   **`b8_079` is the one deliberate exception and it does not set either flag.**
   That beat is the deck's only route to `duke_dead`, so excluding `dope_banned`
   there would drop the fourth card of batch 8's spine for every player who had
   already banned. Under the ratchet principle its left side wants a *new* flag
   for the reversal, and minting one post-hoc with no readers is worse than the
   alternative, so the sanction is carried by `duke_dope` — set on both sides of
   `b8_078` — and the beat stays drawable in every run.
2. **Retire `cop_on_payroll`.** It exists in [flags.dart](../lib/flags.dart)
   and in placeholder card `core_03`, and it is superseded by the Kiernan
   ratchet — he is bought before card one, so there is no buying event to
   record. It should be removed when the placeholder deck is replaced, not
   before; the validator will name every card still using it.
3. ~~**Consider a validator rule** for silence flags.~~ **Done in batch 4**, as
   a test rather than a validator rule — it is an authoring constraint, not a
   runtime one, so it belongs in the suite and not in the code path that loads
   a deck at boot. `shipped batch deck` in
   [card_deck_test.dart](../test/card_deck_test.dart) enforces four things over
   the concatenated deck from `deckPaths`: the sixteen names and their silence
   flags (a dead man talking, the single most likely mistake across 900 cards),
   every speaker being cast or reserve, every `requires.flags` entry being
   settable by some card, and ids unique *across* batch files. Batches 2–4 had
   been checking these in a throwaway script that died with the session.

### Pending engine changes — optional

One thing the ratchet design cannot express, recorded in case it is ever worth
the code:

- **Recurring obligations.** *"Kiernan hasn't been paid this month"* needs a
  flag that can come off. It would take a `clearFlags` list on `CardChoice`,
  mirroring `setFlags`, applied before `setFlags` in `choose`. Perhaps twenty
  lines including the validator.

  **Not recommended yet.** The ratchet covers the dramatic content — a price
  that only goes up is better material than a bill that gets settled — and a
  clearable flag makes card gating much harder to reason about across 900
  cards. Revisit only if a batch genuinely stalls without it.
