/// Xiishopy ERP - Safe Date Parsing Utilities
/// Handles both Firestore Timestamp objects and ISO string dates.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Safely convert a value to DateTime.
/// Handles:
/// - Firestore Timestamp (has toDate())
/// - String ISO dates
/// - null
DateTime safeToDate(dynamic value, {DateTime? fallback}) {
  if (value == null) {
    return fallback ?? DateTime.now();
  }
  // Firestore Timestamp object from package
  if (value is Timestamp) {
    return value.toDate();
  }
  // Native JS-like Timestamp (web/web assembly)
  if (value is dynamic && value.toDate != null) {
    try {
      return value.toDate() as DateTime;
    } catch (_) {}
  }
  // String date
  if (value is String) {
    return DateTime.tryParse(value) ?? fallback ?? DateTime.now();
  }
  // Already a DateTime
  if (value is DateTime) {
    return value;
  }
  // Number (milliseconds since epoch)
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  return fallback ?? DateTime.now();
}