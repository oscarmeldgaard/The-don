/// The single declared list of every legal flag name.
///
/// A card may only reference flags listed here, in `setFlags`,
/// `requires.flags` or `requires.excludesFlags`. The deck validator enforces
/// it, so a typo in one of a hundred and fifty cards fails the test suite
/// instead of quietly making that card unreachable forever.
///
/// Flags come in two kinds, and the distinction matters:
///
/// * [runFlags] are set by cards during a run and die with the run.
/// * [deckFlags] are the same in every respect that matters to the engine;
///   they are the flags [docs/flag-registry.md] declares for the batch decks.
/// * [inheritedFlags] are never set by a card. They are seeded at the start
///   of a run from the persisted enemies and debts, and are what let the
///   son's cards see the father's mess.
///
/// [runFlags] and [deckFlags] are separate sets only because [runFlags]
/// carries a test contract — every one of them must be settable by a card in
/// the deck. That holds for the eight placeholder flags and the placeholder
/// deck. It cannot hold for [deckFlags] until all nine batches are written,
/// because batch one legitimately never sets `sally_moved` or `giulia_left`.
/// Fold the two together once the deck is complete.
class GameFlags {
  const GameFlags._();

  // ---------------------------------------------------------------------
  // Run flags — set by cards, cleared on death.
  // ---------------------------------------------------------------------

  /// Set when the docks are seized. Gates dock-side consequences.
  static const String docksTaken = 'docks_taken';

  /// Set when a rival killing is answered rather than absorbed.
  static const String atWar = 'at_war';

  /// Set once a detective is on the payroll.
  static const String copOnPayroll = 'cop_on_payroll';

  /// Set when a Commission sit-down is refused.
  static const String commissionSnubbed = 'commission_snubbed';

  /// Set when a federal approach is met with silence.
  static const String fedStonewalled = 'fed_stonewalled';

  /// Set when the dock union's demand is refused.
  static const String unionRefused = 'union_refused';

  /// Set when the alderman's campaign is funded.
  static const String aldermanFunded = 'alderman_funded';

  /// Set when a large gambling debt is written off.
  static const String whaleForgiven = 'whale_forgiven';

  static const Set<String> runFlags = <String>{
    docksTaken,
    atWar,
    copOnPayroll,
    commissionSnubbed,
    fedStonewalled,
    unionRefused,
    aldermanFunded,
    whaleForgiven,
  };

  // ---------------------------------------------------------------------
  // Deck flags — the registry in docs/flag-registry.md, in its order.
  //
  // Kept as plain literals rather than 96 named constants: nothing in Dart
  // refers to them by name, the card JSON is the only consumer, and a flat
  // list stays diffable against the document it mirrors. If code ever needs
  // one of these by name, promote that one to a constant.
  // ---------------------------------------------------------------------

  /// The state of the family and the city, independent of any one person.
  ///
  /// `at_war`, `docks_taken` and `commission_snubbed` belong to this group in
  /// docs/flag-registry.md but are declared above as [atWar], [docksTaken]
  /// and [commissionSnubbed], because [Legacy] maps them to inherited
  /// enemies by name. They are not repeated here: a const set literal
  /// rejects duplicates, and that check is worth keeping across 96 strings.
  static const Set<String> worldFlags = <String>{
    'dope_sanctioned',
    'dope_banned',
    'feds_active',
    'books_open',
    'house_split',
    'rosa_room',
  };

  /// Per-character running state. One-way ratchets: set once, never cleared.
  /// Silence flags (`*_dead`, `*_gone`, `adler_ran`) live here too.
  static const Set<String> characterFlags = <String>{
    // 1. UNCLE SALLY
    'sally_humiliated', 'sally_backed', 'sally_faction',
    'sally_moved', 'sally_retired', 'sally_dead',
    // 2. GIULIA — no silence flag, by design
    'giulia_told', 'giulia_lied_to', 'giulia_shielded',
    'giulia_home_touched', 'giulia_left',
    // 3. CONCETTA
    'concetta_blessing', 'concetta_sided_sally',
    'concetta_silent', 'concetta_dead',
    // 4. MATTY
    'matty_made', 'matty_killed_wrong', 'matty_covered',
    'matty_disowned', 'matty_pinched', 'matty_dead',
    // 5. AURELIO
    'aurelio_overruled', 'aurelio_wrong_proven', 'aurelio_doubted',
    'aurelio_failing', 'aurelio_dead',
    // 6. DUKE
    'duke_dope', 'duke_warned', 'duke_broke_off',
    'duke_proven_loyal', 'duke_dead',
    // 7. ANGELO
    'angelo_paid', 'angelo_suspected', 'angelo_flipped', 'angelo_dead',
    // 8. CAPT. KIERNAN
    'kiernan_price_up', 'kiernan_price_up_2', 'kiernan_refused',
    'kiernan_cold', 'kiernan_gone',
    // 9. DET. RANIERI
    'ranieri_watching', 'ranieri_offered', 'ranieri_case_open',
    'ranieri_family_touched', 'ranieri_dead',
    // 10. DON BRACA
    'braca_sponsor', 'braca_owed_him', 'braca_owes_you',
    'braca_insulted', 'braca_dead',
    // 11. FALLON
    'fallon_pension_touched', 'fallon_squeezed', 'fallon_indicted',
    'fallon_replaced', 'fallon_dead',
    // 12. ADLER
    'adler_legit_front', 'adler_subpoenaed', 'adler_skimming',
    'adler_ran', 'adler_dead',
    // 13. MOE WILLS
    'wills_partner', 'wills_stopped_paying', 'wills_dope',
    'wills_war', 'wills_dead',
    // 14. ROSA
    'rosa_forgiven', 'rosa_place_taken', 'rosa_place_burned', 'rosa_gone',
    // 15. FATHER COLLA
    'colla_roof_paid', 'colla_refused_you', 'colla_warned_you', 'colla_gone',
    // 16. DR. NARDI
    'nardi_debt_cleared', 'nardi_used', 'nardi_talked', 'nardi_gone',
  };

  /// Chain flags. An opening card sets one on *both* sides and the follow-up
  /// requires it, so a chain never dead-ends on the branch not taken. They
  /// record that a conversation happened, not which way it went.
  static const Set<String> chainFlags = <String>{
    // batch 1
    'matty_wills_bill',
    'matty_answered',
    'angelo_home_asked',
    'angelo_question',
    'fallon_pension_asked',
    'fallon_desperate',
    'rosa_asked',
    'duke_spoke',
    'braca_freight',
    'aurelio_frame_ranieri',
    // batch 2
    'matty_button', 'matty_own_piece', 'ledger_day', 'ledger_answered',
    'duke_lunches', 'duke_held', 'duke_short', 'giulia_house',
    'kiernan_owed_name', 'angelo_watched', 'braca_after', 'wills_building',
    // batch 3
    'sally_count', 'sally_asked_open', 'sally_two_doors', 'sally_house_edge',
    'sally_last_table', 'pinto_policy', 'pinto_winter', 'house_window',
    'window_answered', 'kiernan_third', 'braca_last', 'bushwick_after',
    'nardi_asked',
    // batch 4
    'aurelio_two_pages', 'aurelio_second_chair', 'aurelio_last_counsel',
    'wills_bags', 'wills_answer', 'ranieri_bakery', 'bakery_asked',
    'hall_spring', 'sally_florida_call', 'matty_offer',
    'concetta_sunday_word', 'adler_short_page',
    // batch 5
    'ranieri_line', 'ranieri_stayed', 'ranieri_table', 'fallon_last',
    'fallon_after', 'state_lottery', 'lottery_answer', 'truck_offer',
    'funeral_asked', 'reporter_asking', 'terminal_bid', 'young_blood',
    // batch 6
    'ridgewood_boys', 'ridgewood_bag', 'ridgewood_named', 'lucia_asked',
    'matty_ruling', 'chair_list', 'chair_vote', 'linen_offer', 'linen_signed',
    'rosa_leaving', 'colla_letter', 'paolo_asked', 'wills_connection',
    // batch 7
    'aldo_box', 'box_counted', 'box_word', 'laundry_audit', 'audit_answer',
    'braca_asks_uptown', 'uptown_ruling', 'himrod_shop', 'concetta_giving',
    'ceremony_day', 'bank_line', 'club_lease',
    // batch 8
    'bushwick_number', 'bushwick_hands', 'bushwick_answer', 'uptown_verdict',
    'wills_told', 'paolo_jersey', 'jersey_counted', 'guarantee_asked',
    'new_men_month', 'club_shut', 'nardi_finished', 'grand_jury',
    // batch 9
    'sally_told_them', 'sally_door_asked', 'sally_thursday', 'house_kept',
    'house_named', 'linen_return', 'return_signed', 'angelo_asked_chair',
    'braca_called', 'local_wound_up', 'matty_asked_out', 'pinto_asked_winter',
  };

  static const Set<String> deckFlags = <String>{
    ...worldFlags,
    ...characterFlags,
    ...chainFlags,
  };

  // ---------------------------------------------------------------------
  // Inherited flags — seeded from the persisted legacy, never set by a card.
  // ---------------------------------------------------------------------

  static const String enemyRivalFamily = 'enemy_rival_family';
  static const String enemyCommission = 'enemy_commission';
  static const String enemyFeds = 'enemy_feds';
  static const String enemyUnion = 'enemy_union';

  static const String debtDetective = 'debt_detective';
  static const String debtAlderman = 'debt_alderman';
  static const String debtBookmaker = 'debt_bookmaker';
  static const String debtDockBosses = 'debt_dock_bosses';

  static const Set<String> inheritedFlags = <String>{
    enemyRivalFamily,
    enemyCommission,
    enemyFeds,
    enemyUnion,
    debtDetective,
    debtAlderman,
    debtBookmaker,
    debtDockBosses,
  };

  static const Set<String> registry = <String>{
    ...runFlags,
    ...deckFlags,
    ...inheritedFlags,
  };
}
