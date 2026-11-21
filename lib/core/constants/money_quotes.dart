/// Short lines used by the daily reminder notifications.
///
/// Morning lines are saving / spending mindset quotes. Evening lines nudge
/// the user to log what they spent today. Both lists rotate by calendar day
/// so the same line never shows two days in a row.
class MoneyQuotes {
  const MoneyQuotes._();

  static const morning = <String>[
    'Do not save what is left after spending; spend what is left after saving. - Warren Buffett',
    'Beware of little expenses; a small leak will sink a great ship. - Benjamin Franklin',
    'A penny saved is a penny earned. - Benjamin Franklin',
    'A budget tells your money where to go instead of wondering where it went.',
    'Small daily savings quietly turn into big goals.',
    'Spend on what matters today, so you can afford what matters tomorrow.',
    'Wealth is built one sensible decision at a time.',
    'Before you buy, ask: need, want, or impulse?',
    'Pay yourself first. Even a small amount counts.',
    'The best time to start saving was yesterday. The next best is today.',
    'Track it today so it does not surprise you at month end.',
    'Cheap habits repeated daily cost more than one big purchase.',
    'Saving is a habit, not a number. Keep it going today.',
    'Every rupee, dollar or euro you keep is a vote for your future.',
    'Wait 24 hours before any non-essential purchase.',
    'Spending with a plan feels better than spending with regret.',
    'You do not need to earn more to save more. Start by noticing where it goes.',
    'Financial freedom is built with ordinary days and steady choices.',
    'Buy things that last. Skip things that only impress.',
    'Today\'s small no is tomorrow\'s big yes.',
    'Your future self is counting on what you decide today.',
    'Know what you spend, and you will know what you can save.',
    'Treat your savings like a bill you always pay.',
    'Spend intentionally. Enjoy fully. Save steadily.',
    'A little discipline today buys a lot of freedom later.',
    'Look at the price, then at the cost to your goals.',
    'Skipping one unplanned purchase today is a quick win.',
    'Money is a tool. Decide what you want it to build.',
    'Progress beats perfection. Save something today.',
    'Good money habits are boring, and that is exactly why they work.',
  ];

  static const eveningTitles = <String>[
    'Add today\'s spendings',
    'Log today\'s expenses',
    'Did you spend anything today?',
    'Quick check-in: today\'s spending',
  ];

  static const evening = <String>[
    'Take 30 seconds to add today\'s expenses before you forget.',
    'Snap a bill or add an entry now. Future you will thank you.',
    'A quick entry tonight keeps your month accurate.',
    'Tracked today, in control tomorrow. Add your expenses now.',
    'Coffee, snacks, travel: log them while they are fresh.',
    'Your day is done. Close it by adding what you spent.',
    'Small expenses add up. Record them before bed.',
    'Two minutes now saves guessing at month end.',
    'Add today\'s bills to see how your day compares with your budget.',
    'No spend today? Great. Open the app and confirm it.',
    'Keep your streak going. Add today\'s spending.',
    'Before you wind down, record today\'s expenses.',
  ];

  static String morningFor(DateTime day) => morning[_dayNumber(day) % morning.length];

  static String eveningTitleFor(DateTime day) =>
      eveningTitles[_dayNumber(day) % eveningTitles.length];

  static String eveningFor(DateTime day) =>
      evening[_dayNumber(day) % evening.length];

  /// Whole days since the epoch for the given calendar date, ignoring the
  /// time of day and time zone offsets.
  static int _dayNumber(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}
