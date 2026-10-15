import 'package:dio/dio.dart';

import '../storage/token_store.dart';
import 'app_failure.dart';

/// Centraliza las peticiones HTTP, la autenticación y la conversión de errores.
class ApiClient {
  ApiClient(this.dio, this.tokens) {
    dio.interceptors.add(
      InterceptorsWrapper(
        // Añade el token Bearer únicamente a las peticiones autenticadas.
        onRequest: (options, handler) async {
          try {
            if (options.extra['authenticated'] == true) {
              final token = await tokens.read();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
            handler.next(options);
          } catch (_) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: const AppFailure(FailureKind.storage),
              ),
            );
          }
        },
        // Notifica la expiración si un 401 corresponde al token de la sesión actual.
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.extra['authenticated'] == true) {
            try {
              final current = await tokens.read();
              if (current != null &&
                  error.requestOptions.headers['Authorization'] ==
                      'Bearer $current') {
                await onUnauthorized?.call();
              }
            } catch (_) {
              handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: const AppFailure(FailureKind.storage),
                ),
              );
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }
  final Dio dio;
  final TokenStore tokens;
  /// Permite que la sesión reaccione a un 401 sin acoplar Dio a la navegación.
  Future<void> Function()? onUnauthorized;

  /// Ejecuta una petición y transforma fallos HTTP o de red en errores de la app.
  Future<Map<String, dynamic>> request(
    String path, {
    String method = 'GET',
    Object? data,
    bool authenticated = false,
  }) async {
    try {
      final response = await dio.request<dynamic>(
        path,
        data: data,
        options: Options(
          method: method,
          extra: {'authenticated': authenticated},
        ),
      );
      if (response.data is! Map) throw const AppFailure(FailureKind.unexpected);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (error) {
      if (error.error is AppFailure) throw error.error! as AppFailure;
      final status = error.response?.statusCode;
      if (status == 401) {
        throw AppFailure(
          authenticated ? FailureKind.unauthorized : FailureKind.credentials,
        );
      }
      if (status == 422) throw const AppFailure(FailureKind.validation);
      if (status == 408 ||
          status == 504 ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const AppFailure(FailureKind.timeout);
      }
      if (status != null && status >= 500) {
        throw const AppFailure(FailureKind.server);
      }
      if (error.type == DioExceptionType.connectionError) {
        throw const AppFailure(FailureKind.offline);
      }
      throw const AppFailure(FailureKind.unexpected);
    }
  }
}
