import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final int userId;
  final String phone;
  final String nickname;
  final String? avatar;
  final String? email;
  final String? createTime;

  UserInfo({
    required this.userId,
    required this.phone,
    required this.nickname,
    this.avatar,
    this.email,
    this.createTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? 0,
      phone: json['phone'] ?? '',
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'],
      email: json['email'],
      createTime: json['createTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
      'email': email,
      'createTime': createTime,
    };
  }
}

class UserInfoService {
  static const String _userInfoKey = 'user_info';
  static UserInfo? _currentUser;

  static UserInfo? get currentUser => _currentUser;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoStr = prefs.getString(_userInfoKey);
    if (userInfoStr != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(userInfoStr);
        _currentUser = UserInfo.fromJson(json);
      } catch (e) {
        _currentUser = null;
      }
    }
  }

  static Future<void> saveUserInfo(UserInfo userInfo) async {
    _currentUser = userInfo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, jsonEncode(userInfo.toJson()));
  }

  static Future<void> clearUserInfo() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
  }

  static Future<UserInfo?> getUserInfo() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    await init();
    return _currentUser;
  }
}