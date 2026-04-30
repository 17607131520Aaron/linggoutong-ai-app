import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';
import 'package:linggoutong_ai_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPhoneValid = false;
  int _countdown = 0;
  bool _isCodeLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
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
    if (_isCodeLogin) {
      if (_codeController.text.length < 4) return;
    } else {
      if (_passwordController.text.length < 6) return;
    }
    AuthService.login();
    context.go('/');
  }

  bool get _canLogin {
    if (!_isPhoneValid) return false;
    if (_isCodeLogin) return _codeController.text.length >= 4;
    return _passwordController.text.length >= 6;
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
            _buildLogo(),
            const SizedBox(height: 48),
            _buildPhoneInput(),
            const SizedBox(height: 16),
            _isCodeLogin ? _buildCodeInput() : _buildPasswordInput(),
            const SizedBox(height: 8),
            _buildLoginModeSwitch(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 16),
            _buildRegisterEntry(),
            const SizedBox(height: 20),
            _buildAgreement(),
            const SizedBox(height: 40),
            _buildThirdPartyLogin(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
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
        const Text(
          '领狗通 AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AntColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '智能助手，随时为您服务',
          style: TextStyle(
            fontSize: 14,
            color: AntColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Container(
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
    );
  }

  Widget _buildCodeInput() {
    return Container(
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
    );
  }

  Widget _buildPasswordInput() {
    return Container(
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
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(fontSize: 16, color: AntColors.textPrimary),
              decoration: const InputDecoration(
                hintText: '请输入密码',
                hintStyle: TextStyle(color: AntColors.textQuaternary, fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: AntColors.textTertiary,
              ),
            ),
          ),
          if (_passwordController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _passwordController.clear();
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.cancel, size: 18, color: AntColors.textQuaternary),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildLoginModeSwitch() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isCodeLogin = !_isCodeLogin;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _isCodeLogin ? '密码登录' : '验证码登录',
            style: const TextStyle(
              fontSize: 13,
              color: AntColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _canLogin ? _login : null,
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
    );
  }

  Widget _buildRegisterEntry() {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.push('/register');
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: AntColors.textTertiary),
            children: [
              TextSpan(text: '还没有账号？ '),
              TextSpan(
                text: '去注册',
                style: TextStyle(
                  color: AntColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgreement() {
    return Center(
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
    );
  }

  Widget _buildThirdPartyLogin() {
    return Column(
      children: [
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
