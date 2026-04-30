import 'package:flutter/material.dart';

// 蚂蚁金服风格统一配色
class AntColors {
  // 主色调
  static const Color primary = Color(0xFF1677FF);
  static const Color primaryLight = Color(0xFF4096FF);
  static const Color primaryDark = Color(0xFF0958D9);
  
  // 功能色
  static const Color success = Color(0xFF52C41A);
  static const Color warning = Color(0xFFFAAD14);
  static const Color error = Color(0xFFFF4D4F);
  static const Color info = Color(0xFF1677FF);
  
  // 中性色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textQuaternary = Color(0xFFCCCCCC);
  
  // 背景色
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F5);
  static const Color bgTertiary = Color(0xFFFAFAFA);
  
  // 边框色
  static const Color borderPrimary = Color(0xFFE5E5E5);
  static const Color borderSecondary = Color(0xFFF0F0F0);
  
  // 阴影
  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

// 蚂蚁风格圆角
class AntRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}

// 蚂蚁风格间距
class AntSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}
