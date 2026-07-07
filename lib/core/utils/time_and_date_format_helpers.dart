import 'package:intl/intl.dart';

String formatTimeHelper(String? isoString) {
  if (isoString == null) return '';
  try {
    return DateFormat('h:mm a').format(DateTime.parse(isoString));
  } catch (_) {
    return isoString; // fallback to raw string if parsing fails
  }
}

String formatDateHelper(String? isoString) {
  if (isoString == null) return '';
  try {
    return DateFormat('MMM d, y').format(DateTime.parse(isoString));
  } catch (_) {
    return isoString; // Fallback if parsing fails
  }
}