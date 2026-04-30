import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';
import 'package:linggoutong_ai_app/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPhoneValid = false;
  int _countdown = 0;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _isPhoneValid = value.length == 11;
    });
  }

  Future<void> _sendCode() async {
    if (!_isPhoneValid) return;
    
    try {
      final response = await ApiService.sendSmsCode(_phoneController.text);
      
      print('Send SMS response: code=${response.code}, message=${response.message}, isSuccess=${response.isSuccess}');
      
      if (response.isSuccess) {
        setState(() {
          _countdown = 60;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('验证码已发送'), behavior: SnackBarBehavior.floating),
          );
        }
        
        Future.doWhile(() async {
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return false;
          setState(() => _countdown--);
          return _countdown > 0;
        });
      }
    } catch (e) {
      print('Send SMS error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  bool get _canRegister {
    return _isPhoneValid &&
        _codeController.text.length >= 4 &&
        _passwordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;
  }

  String get _passwordStrength {
    final pwd = _passwordController.text;
    if (pwd.isEmpty) return '';
    if (pwd.length < 6) return '弱';
    if (pwd.length < 10) return '中';
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(pwd);
    final hasDigit = RegExp(r'[0-9]').hasMatch(pwd);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pwd);
    if (hasLetter && hasDigit && hasSpecial) return '强';
    if (hasLetter && hasDigit) return '中';
    return '弱';
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case '弱':
        return AntColors.error;
      case '中':
        return AntColors.warning;
      case '强':
        return AntColors.success;
      default:
        return AntColors.borderSecondary;
    }
  }

  double get _strengthPercent {
    switch (_passwordStrength) {
      case '弱':
        return 0.33;
      case '中':
        return 0.66;
      case '强':
        return 1.0;
      default:
        return 0;
    }
  }

  Future<void> _register() async {
    if (!_canRegister) return;
    
    try {
      final response = await ApiService.register(
        phone: _phoneController.text,
        code: _codeController.text,
        password: _passwordController.text,
      );
      
      if (response.isSuccess && mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AntRadius.md),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AntColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: AntColors.success, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  '注册成功',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AntColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '欢迎加入领狗通AI！',
                  style: TextStyle(fontSize: 14, color: AntColors.textTertiary),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AntColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AntRadius.xl),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('去登录', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册失败: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AntColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildBenefitsCard(),
            const SizedBox(height: 28),
            _buildFormSection(),
            const SizedBox(height: 16),
            _buildLoginEntry(),
            const SizedBox(height: 20),
            _buildAgreement(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AntColors.primary, AntColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.auto_awesome, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '创建账号',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AntColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '开启智能AI之旅',
                  style: TextStyle(fontSize: 14, color: AntColors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AntColors.primary.withValues(alpha: 0.06),
            AntColors.primaryLight.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AntRadius.md),
        border: Border.all(color: AntColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.card_giftcard, size: 18, color: AntColors.primary),
              SizedBox(width: 6),
              Text(
                '新用户福利',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AntColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _benefitItem(Icons.stars, '赠送 100 次免费对话额度'),
          const SizedBox(height: 8),
          _benefitItem(Icons.workspace_premium, '解锁 Pro 会员体验 3 天'),
          const SizedBox(height: 8),
          _benefitItem(Icons.bolt, '优先体验最新 AI 模型'),
        ],
      ),
    );
  }

  Widget _benefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AntColors.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AntColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildPhoneInput(),
        const SizedBox(height: 14),
        _buildCodeInput(),
        const SizedBox(height: 14),
        _buildPasswordInput(),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildPasswordStrength(),
        ],
        const SizedBox(height: 14),
        _buildConfirmPasswordInput(),
        if (_confirmPasswordController.text.isNotEmpty &&
            _passwordController.text != _confirmPasswordController.text) ...[
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '两次密码输入不一致',
              style: TextStyle(fontSize: 12, color: AntColors.error),
            ),
          ),
        ],
        const SizedBox(height: 28),
        _buildRegisterButton(),
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
          const Icon(Icons.shield_outlined, size: 20, color: AntColors.textTertiary),
          const SizedBox(width: 8),
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
              decoration: BoxDecoration(
                color: _isPhoneValid ? AntColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(AntRadius.xs),
              ),
              child: Text(
                _countdown > 0 ? '${_countdown}s后重发' : '获取验证码',
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
          const Icon(Icons.lock_outline, size: 20, color: AntColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(fontSize: 16, color: AntColors.textPrimary),
              decoration: const InputDecoration(
                hintText: '请设置密码（不少于6位）',
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
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildPasswordStrength() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _strengthPercent,
              backgroundColor: AntColors.borderSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '密码强度：$_passwordStrength',
          style: TextStyle(fontSize: 12, color: _strengthColor),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordInput() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AntColors.bgSecondary,
        borderRadius: BorderRadius.circular(AntRadius.md),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.lock_outline, size: 20, color: AntColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              style: const TextStyle(fontSize: 16, color: AntColors.textPrimary),
              decoration: const InputDecoration(
                hintText: '请确认密码',
                hintStyle: TextStyle(color: AntColors.textQuaternary, fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: AntColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _canRegister ? _register : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AntColors.primary,
              disabledBackgroundColor: AntColors.primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AntRadius.xl),
              ),
              elevation: 0,
            ),
            child: const Text(
              '注册',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginEntry() {
    return Center(
      child: GestureDetector(
        onTap: () => context.pop(),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: AntColors.textTertiary),
            children: [
              TextSpan(text: '已有账号？ '),
              TextSpan(
                text: '去登录',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 12, color: AntColors.textTertiary, height: 1.6),
            children: [
              TextSpan(text: '注册即代表同意 '),
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
    );
  }
}
