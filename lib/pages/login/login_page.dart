import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isPhoneValid = false;
  int _countdown = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _isPhoneValid = value.length == 11;
    });
  }

  void _sendCode() {
    if (!_isPhoneValid) return;
    setState(() {
      _countdown = 60;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  void _login() {
    if (_codeController.text.length < 4) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AntColors.textPrimary, size: 20),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Logo
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AntColors.primary, AntColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AntColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '领狗通 AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AntColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '智能助手，随时为您服务',
                style: TextStyle(
                  fontSize: 14,
                  color: AntColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // 手机号输入
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AntColors.bgSecondary,
                borderRadius: BorderRadius.circular(AntRadius.md),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Text(
                    '+86',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AntColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 18, color: AntColors.textTertiary),
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: AntColors.borderSecondary,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      style: const TextStyle(fontSize: 16, color: AntColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: '请输入手机号',
                        hintStyle: TextStyle(color: AntColors.textQuaternary, fontSize: 16),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: _onPhoneChanged,
                    ),
                  ),
                  if (_phoneController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _phoneController.clear();
                        setState(() => _isPhoneValid = false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.cancel, size: 18, color: AntColors.textQuaternary),
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 验证码输入
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AntColors.bgSecondary,
                borderRadius: BorderRadius.circular(AntRadius.md),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(fontSize: 16, color: AntColors.textPrimary, letterSpacing: 8),
                      decoration: const InputDecoration(
                        hintText: '请输入验证码',
                        hintStyle: TextStyle(color: AntColors.textQuaternary, fontSize: 16, letterSpacing: 0),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isPhoneValid && _countdown == 0 ? _sendCode : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        _countdown > 0 ? '${_countdown}s' : '获取验证码',
                        style: TextStyle(
                          fontSize: 14,
                          color: _isPhoneValid ? AntColors.primary : AntColors.textQuaternary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 登录按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isPhoneValid && _codeController.text.length >= 4 ? _login : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AntColors.primary,
                  disabledBackgroundColor: AntColors.primary.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AntRadius.xl),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '登录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 协议
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, color: AntColors.textTertiary, height: 1.6),
                  children: [
                    TextSpan(text: '登录即代表同意 '),
                    TextSpan(
                      text: '《用户协议》',
                      style: TextStyle(color: AntColors.primary),
                    ),
                    TextSpan(text: ' 和 '),
                    TextSpan(
                      text: '《隐私政策》',
                      style: TextStyle(color: AntColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 第三方登录
            Row(
              children: [
                Expanded(child: Container(height: 0.5, color: AntColors.borderSecondary)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('其他登录方式', style: TextStyle(fontSize: 12, color: AntColors.textQuaternary)),
                ),
                Expanded(child: Container(height: 0.5, color: AntColors.borderSecondary)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThirdPartyButton(Icons.wechat, Colors.green),
                const SizedBox(width: 40),
                _buildThirdPartyButton(Icons.apple, Colors.black),
                const SizedBox(width: 40),
                _buildThirdPartyButton(Icons.language, AntColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPartyButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('功能开发中，敬请期待'), behavior: SnackBarBehavior.floating),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AntColors.bgSecondary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
