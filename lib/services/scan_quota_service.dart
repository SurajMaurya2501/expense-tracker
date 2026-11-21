import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// Thrown when this device has used all of its free bill scans.
class ScanLimitReachedException implements Exception {
  const ScanLimitReachedException();

  @override
  String toString() =>
      'You have used all ${ScanQuotaService.limit} free bill scans.';
}

/// Thrown when the remaining scans cannot be checked (offline, rules not
/// deployed, no device id). Scanning is blocked in that case.
class ScanQuotaUnavailableException implements Exception {
  const ScanQuotaUnavailableException();

  @override
  String toString() => 'Could not check your free bill scans.';
}

/// Limits every device to [limit] AI bill scans for life.
///
/// The count lives in Firestore (`scan_quota/{hash of Android ID}`), not on the
/// phone, so uninstalling and reinstalling the app does not give new scans.
/// The Android ID survives an uninstall; it only changes on a factory reset.
///
/// Every attempt counts, whether Gemini reads the bill or not. The count is
/// raised *before* the Gemini call, and the Firestore security rules in
/// `firestore.rules` only allow it to go up by one and never past [limit].
class ScanQuotaService {
  ScanQuotaService._();

  static final ScanQuotaService instance = ScanQuotaService._();

  /// Keep in sync with the limit in `firestore.rules`.
  static const limit = 20;

  static const _collection = 'scan_quota';

  /// Scans left, or null until it has been read once.
  final ValueNotifier<int?> remaining = ValueNotifier<int?>(null);

  String? _deviceKey;

  Future<DocumentReference<Map<String, dynamic>>> _doc() async {
    var key = _deviceKey;
    if (key == null) {
      String? androidId;
      try {
        androidId = await const AndroidId().getId();
      } catch (e) {
        debugPrint('Could not read the Android ID: $e');
      }
      if (androidId == null || androidId.isEmpty) {
        throw const ScanQuotaUnavailableException();
      }
      key = sha256.convert(utf8.encode('spendwise:$androidId')).toString();
      _deviceKey = key;
    }
    return FirebaseFirestore.instance.collection(_collection).doc(key);
  }

  /// Reads the scans left from Firestore (or its offline cache) so the UI can
  /// show it. Never throws; the previous value is kept if the read fails.
  Future<int?> refresh() async {
    try {
      final snapshot = await (await _doc()).get();
      final used = (snapshot.data()?['used'] as num?)?.toInt() ?? 0;
      remaining.value = (limit - used).clamp(0, limit);
    } catch (e) {
      debugPrint('Could not read the scan quota: $e');
    }
    return remaining.value;
  }

  /// Uses up one scan. Call this right before sending a bill to Gemini.
  ///
  /// Runs as a transaction, so it needs a connection: going offline cannot be
  /// used to scan without being counted.
  ///
  /// Throws [ScanLimitReachedException] when no scans are left, and
  /// [ScanQuotaUnavailableException] when the count cannot be verified.
  Future<void> consume() async {
    final doc = await _doc();
    try {
      final left = await FirebaseFirestore.instance.runTransaction<int>((
        transaction,
      ) async {
        final snapshot = await transaction.get(doc);
        final used = (snapshot.data()?['used'] as num?)?.toInt() ?? 0;
        if (used >= limit) throw const ScanLimitReachedException();

        if (snapshot.exists) {
          transaction.update(doc, {'used': used + 1});
        } else {
          transaction.set(doc, {
            'used': 1,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        return limit - used - 1;
      });
      remaining.value = left;
    } on ScanLimitReachedException {
      remaining.value = 0;
      rethrow;
    } catch (e) {
      // permission-denied here usually means firestore.rules is not deployed.
      debugPrint('Could not use a scan: $e');
      throw const ScanQuotaUnavailableException();
    }
  }
}
