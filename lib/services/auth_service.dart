import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _loginTimeKey = 'login_time';
  static const int _tokenValidDays = 3;

  static bool _isLoggedIn = false;
  static bool _isInitialized = false;

  static bool get isLoggedIn => _isLoggedIn;

  static Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final loginTimeMs = prefs.getInt(_loginTimeKey);

    if (token == null || loginTimeMs == null) {
      _isLoggedIn = false;
      return;
    }

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimeMs);
    final now = DateTime.now();
    final difference = now.difference(loginTime);

    if (difference.inDays >= _tokenValidDays) {
      _isLoggedIn = false;
      await _clearStorage();
    } else {
      _isLoggedIn = true;
    }
  }

  static Future<void> login() async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> logout() async {
    _isLoggedIn = false;
    await _clearStorage();
  }

  static Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_loginTimeKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
