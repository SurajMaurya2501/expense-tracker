import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/money_quotes.dart';
import 'package:expense_tracker/core/prefs/app_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules two local reminders every day:
///  - morning: a saving / spending quote
///  - evening: a nudge to add today's expenses
///
/// A repeating notification would show the same text every day, so instead the
/// next [_daysAhead] days are scheduled individually, each with its own quote.
/// The schedule is rebuilt every time the app opens via [sync].
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const morningHour = 8;
  static const morningMinute = 0;
  static const eveningHour = 21;
  static const eveningMinute = 0;

  static const _daysAhead = 14;
  static const _androidIcon = 'ic_stat_notify';
  static const _androidLargeIcon = 'ic_notification_large';

  static const _morningChannelId = 'morning_quote';
  static const _eveningChannelId = 'evening_expense_reminder';

  static const _morningKind = 1;
  static const _eveningKind = 2;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Sets up the plugin and the device time zone. Safe to call more than once.
  Future<void> init() async {
    if (_ready || !_supported) return;

    tz_data.initializeTimeZones();
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (e) {
      debugPrint('Could not read the device time zone, using UTC: $e');
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        // Permission is requested later, at a natural moment, not at launch.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  /// Brings the schedule in line with the user's preference.
  ///
  /// Call this when the app opens. [hasLoggedToday] is used to skip tonight's
  /// reminder when the user has already added an expense today.
  Future<void> sync({required Future<bool> Function() hasLoggedToday}) async {
    if (!_ready) return;

    try {
      if (!await AppPrefs.remindersEnabled()) {
        await _plugin.cancelAllPendingNotifications();
        return;
      }
      if (!await _requestPermission()) return;
      await _schedule(skipTonight: await hasLoggedToday());
    } catch (e) {
      debugPrint('Could not schedule reminders: $e');
    }
  }

  /// Removes tonight's reminder, e.g. after the user logs an expense.
  Future<void> cancelTodayEvening() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _id(DateTime.now(), _eveningKind));
    } catch (e) {
      debugPrint('Could not cancel tonight\'s reminder: $e');
    }
  }

  Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? await android.areNotificationsEnabled() ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  Future<void> _schedule({required bool skipTonight}) async {
    await _plugin.cancelAllPendingNotifications();

    final now = tz.TZDateTime.now(tz.local);

    for (var offset = 0; offset < _daysAhead; offset++) {
      final morning = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + offset,
        morningHour,
        morningMinute,
      );
      final evening = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + offset,
        eveningHour,
        eveningMinute,
      );

      if (morning.isAfter(now)) {
        await _scheduleOne(
          id: _id(morning, _morningKind),
          when: morning,
          title: 'Good morning',
          body: MoneyQuotes.morningFor(morning),
          channelId: _morningChannelId,
          channelName: 'Morning money quote',
          channelDescription: 'A saving or spending quote to start your day.',
        );
      }

      final skipThisEvening = offset == 0 && skipTonight;
      if (evening.isAfter(now) && !skipThisEvening) {
        await _scheduleOne(
          id: _id(evening, _eveningKind),
          when: evening,
          title: MoneyQuotes.eveningTitleFor(evening),
          body: MoneyQuotes.eveningFor(evening),
          channelId: _eveningChannelId,
          channelName: 'Evening expense reminder',
          channelDescription: 'A reminder to add the day\'s expenses.',
        );
      }
    }
  }

  Future<void> _scheduleOne({
    required int id,
    required tz.TZDateTime when,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String channelDescription,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      scheduledDate: when,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          // Small icon comes from res/drawable/ic_stat_notify.xml (set at
          // init). The tint and large icon carry the app's gold-coin logo.
          color: AppColors.coinGold,
          largeIcon: const DrawableResourceAndroidBitmap(_androidLargeIcon),
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // Inexact is enough for a daily reminder and avoids the exact-alarm
      // permission, which Google Play restricts.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// One stable id per calendar day and kind, e.g. 2026-11-21 evening
  /// becomes 202611212.
  int _id(DateTime day, int kind) =>
      (day.year * 10000 + day.month * 100 + day.day) * 10 + kind;
}
