abstract class ApiConsumer {
  Future<dynamic> get(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        String? token,
      });

  Future<dynamic> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false,
        String? token,
      });

  Future<dynamic> patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false,
        String? token,
      });

  Future<dynamic> delete(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        String? token,
      });
}