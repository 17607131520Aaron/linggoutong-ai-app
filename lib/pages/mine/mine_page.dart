import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linggoutong_ai_app/common/ant_theme.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AntColors.bgSecondary,
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(context),
            const SizedBox(height: 12),
            _buildStatsCard(),
            const SizedBox(height: 12),
            _buildVipCard(),
            const SizedBox(height: 12),
            _buildMenuSection(),
            const SizedBox(height: 12),
            _buildOtherMenuSection(),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile'),
      child: Container(
      margin: const EdgeInsets.all(16),
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.diamond, size: 12, color: AntColors.warning),
                      SizedBox(width: 4),
                      Text(
                        'Pro 会员',
                        style: TextStyle(
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

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AntColors.bgPrimary,
        borderRadius: BorderRadius.circular(AntRadius.md),
        boxShadow: AntColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('1,280', '对话次数'),
          _buildDivider(),
          _buildStatItem('56,800', '消息总数'),
          _buildDivider(),
          _buildStatItem('98.5%', '满意度'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AntColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AntColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 0.5,
      height: 30,
      color: AntColors.borderSecondary,
    );
  }

  Widget _buildVipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AntRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.diamond, color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '升级 Pro 会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '解锁全部 AI 功能',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.amber, Color(0xFFFFD700)],
              ),
              borderRadius: BorderRadius.circular(AntRadius.xl),
            ),
            child: const Text(
              '立即升级',
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AntColors.bgPrimary,
        borderRadius: BorderRadius.circular(AntRadius.md),
        boxShadow: AntColors.shadow,
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.history, '对话历史', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.bookmark_outline, '我的收藏', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.download_outlined, '下载记录', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.language, '语言设置', () {}),
        ],
      ),
    );
  }

  Widget _buildOtherMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AntColors.bgPrimary,
        borderRadius: BorderRadius.circular(AntRadius.md),
        boxShadow: AntColors.shadow,
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.help_outline, '帮助与反馈', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.info_outline, '关于我们', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.description_outlined, '用户协议', () {}),
          _buildMenuDivider(),
          _buildMenuItem(Icons.privacy_tip_outlined, '隐私政策', () {}),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AntColors.bgPrimary,
          borderRadius: BorderRadius.circular(AntRadius.md),
          boxShadow: AntColors.shadow,
        ),
        child: const Center(
          child: Text(
            '退出登录',
            style: TextStyle(
              fontSize: 16,
              color: AntColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AntColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: AntColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AntColors.textQuaternary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 0.5, color: AntColors.borderSecondary),
    );
  }
}
