import 'package:linggoutong_ai_app/common/api_response.dart';
import 'package:linggoutong_ai_app/utils/http.dart';

class ApiService {
  static final Http _http = Http();

  // 获取用户信息
  static Future<ApiResponse<Map<String, dynamic>>> getUserInfo() async {
    return await _http.get<Map<String, dynamic>>('/api/app/user/info');
  }

  // 登录
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String phone,
    required String code,
  }) async {
    return await _http.post<Map<String, dynamic>>(
      '/api/app/auth/login',
      data: {
        'phone': phone,
        'code': code,
      },
    );
  }

  // 发送验证码
  static Future<ApiResponse<void>> sendSmsCode(String phone) async {
    return await _http.post<void>(
      '/api/app/auth/sms-code',
      data: {'phone': phone},
    );
  }

  // 注册
  static Future<ApiResponse<void>> register({
    required String phone,
    required String code,
    required String password,
  }) async {
    return await _http.post<void>(
      '/api/app/auth/register',
      data: {
        'phone': phone,
        'code': code,
        'password': password,
      },
    );
  }
}
