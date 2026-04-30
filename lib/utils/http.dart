import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:linggoutong_ai_app/common/api_response.dart';
import 'package:linggoutong_ai_app/common/env.dart';
import 'package:linggoutong_ai_app/services/auth_service.dart';

class Http {
  static final Http _instance = Http._internal();
  factory Http() => _instance;

  late final Dio _dio;

  Http._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  Dio get dio => _dio;

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;
    
    final whitelistPaths = [
      '/api/app/auth/login',
      '/api/app/auth/register',
      '/api/app/auth/sms-code',
      '/api/app/auth/refresh',
      '/api/web/auth/',
    ];
    
    final isWhitelisted = whitelistPaths.any((p) => path.contains(p));
    
    if (!isWhitelisted) {
      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(data, null);
        if (!apiResponse.isSuccess) {
          Fluttertoast.showToast(
            msg: apiResponse.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      }
    }
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    String message = '网络请求失败';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(error.response);
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      case DioExceptionType.connectionError:
        message = '连接错误';
        break;
      case DioExceptionType.unknown:
        message = error.message ?? '未知错误';
        break;
      default:
        message = '网络请求失败';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    handler.next(error);
  }

  String _handleBadResponse(Response? response) {
    if (response == null) return '服务器响应异常';
    final statusCode = response.statusCode;
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求地址不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      default:
        return '服务器响应异常: $statusCode';
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return ApiResponse.fromJson(response.data, fromJson);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return ApiResponse.fromJson(response.data, fromJson);
  }
}
