import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentRole = '普通用户';
  final List<String> _roles = ['普通用户', '管理员', 'VIP会员', '企业用户'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntColors.bgSecondary,
      appBar: AppBar(
        title: const Text('个人信息'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildUserHeader(),
            const SizedBox(height: 12),
            _buildInfoSection(),
            const SizedBox(height: 12),
            _buildActionSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AntColors.bgPrimary,
          borderRadius: BorderRadius.circular(AntRadius.md),
          boxShadow: AntColors.shadow,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AntColors.primary, AntColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI 智能用户',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AntColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: 100001',
                    style: TextStyle(
                      fontSize: 13,
                      color: AntColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AntColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AntRadius.xs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.diamond, size: 12, color: AntColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          _currentRole,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AntColors.warning,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AntColors.textQuaternary),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AntColors.bgPrimary,
        borderRadius: BorderRadius.circular(AntRadius.md),
        boxShadow: AntColors.shadow,
      ),
      child: Column(
        children: [
          _buildInfoItem('手机号', '138****8888'),
          _buildDivider(),
          _buildInfoItem('邮箱', '未绑定'),
          _buildDivider(),
          _buildInfoItem('注册时间', '2024-01-15'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AntColors.textPrimary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AntColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AntColors.bgPrimary,
        borderRadius: BorderRadius.circular(AntRadius.md),
        boxShadow: AntColors.shadow,
      ),
      child: Column(
        children: [
          _buildActionItem(
            Icons.swap_horiz,
            '切换角色',
            onTap: _showRoleSwitchSheet,
          ),
          _buildDivider(),
          _buildActionItem(
            Icons.switch_account_outlined,
            '切换账号',
            onTap: _showSwitchAccountDialog,
          ),
          _buildDivider(),
          _buildActionItem(
            Icons.logout,
            '退出登录',
            color: AntColors.error,
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title,
      {Color color = AntColors.textSecondary, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: color,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AntColors.textQuaternary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 0.5, color: AntColors.borderSecondary),
    );
  }

  void _showRoleSwitchSheet() {
    String selectedRole = _currentRole;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: AntColors.bgPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AntRadius.lg)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AntColors.borderPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '切换角色',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AntColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '当前角色: $_currentRole',
                style: const TextStyle(
                  fontSize: 13,
                  color: AntColors.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              ..._roles.map((role) => _buildRoleItem(role, selectedRole, (r) {
                setSheetState(() => selectedRole = r);
              })),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: AntColors.bgSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AntRadius.md),
                            ),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 16,
                              color: AntColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _currentRole = selectedRole;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('已切换为: $selectedRole'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AntColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AntRadius.md),
                            ),
                          ),
                          child: const Text(
                            '确定',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleItem(String role, String selectedRole, ValueChanged<String> onSelect) {
    final isSelected = role == selectedRole;
    return GestureDetector(
      onTap: () => onSelect(role),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AntColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(AntRadius.sm),
          border: Border.all(
            color: isSelected ? AntColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.shield_outlined,
              size: 20,
              color: isSelected ? AntColors.primary : AntColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? AntColors.primary : AntColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 20, color: AntColors.primary),
          ],
        ),
      ),
    );
  }

  void _showSwitchAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AntRadius.md),
        ),
        title: const Text('切换账号', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        content: const Text('确定要切换到其他账号吗？', style: TextStyle(fontSize: 15, color: AntColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AntColors.textTertiary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text('确定', style: TextStyle(color: AntColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AntRadius.md),
        ),
        title: const Text('提示', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        content: const Text('确定要退出登录吗？', style: TextStyle(fontSize: 15, color: AntColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AntColors.textTertiary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text('确定', style: TextStyle(color: AntColors.primary)),
          ),
        ],
      ),
    );
  }
}
