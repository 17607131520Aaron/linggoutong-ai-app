import 'package:flutter/material.dart';
import 'package:linggoutong_ai_app/router/app_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';
import 'package:linggoutong_ai_app/common/env.dart';
import 'package:linggoutong_ai_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置环境：dev / staging / prod
  Env.setEnv(EnvType.dev);

  await AuthService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '领狗通AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AntColors.primary,
          primary: AntColors.primary,
          secondary: AntColors.primaryLight,
          error: AntColors.error,
          surface: AntColors.bgPrimary,
        ),
        scaffoldBackgroundColor: AntColors.bgSecondary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AntColors.bgPrimary,
          foregroundColor: AntColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AntColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: AntColors.bgPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AntRadius.md),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AntColors.borderSecondary,
          thickness: 0.5,
          space: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AntColors.bgPrimary,
          selectedItemColor: AntColors.primary,
          unselectedItemColor: AntColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0.5,
          selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 10),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
