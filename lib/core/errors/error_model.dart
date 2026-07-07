class ErrorModel {
  final String errorMessage;

  ErrorModel({required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    // Handle RFC 7807 Problem Details (https://tools.ietf.org/html/rfc7807)
    String? title = json['title'] as String?;
    String? detail = json['message'] as String?;
    final errors = json['errors'] as Map<String, dynamic>?;

    // Try to extract the first validation error message
    if (errors != null && errors.isNotEmpty) {
      final firstErrorValues = errors.values.first;
      if (firstErrorValues is List && firstErrorValues.isNotEmpty) {
        final firstMsg = firstErrorValues[0];
        if (firstMsg is String) {
          return ErrorModel(errorMessage: firstMsg);
        }
      }
    }

    // Fall back to title or detail
    String msg = title ?? detail ?? 'An unknown error occurred';
    return ErrorModel(errorMessage: msg);
  }
}