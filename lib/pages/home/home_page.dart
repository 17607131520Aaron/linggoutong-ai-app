import 'package:flutter/material.dart';
import 'package:linggoutong_ai_app/services/api_service.dart';
import 'package:linggoutong_ai_app/services/user_info_service.dart';

// 蚂蚁金服风格配色（与之前保持一致）
const Color _kPrimaryColor = Color(0xFF1677FF);
const Color _kBgColor = Color(0xFFF5F5F5);
const Color _kTextPrimary = Color(0xFF333333);
const Color _kTextSecondary = Color(0xFF999999);
const Color _kBorderColor = Color(0xFFE5E5E5);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserInfo? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final response = await ApiService.getUserInfo();
      if (response.isSuccess && response.data != null) {
        final userInfo = UserInfo.fromJson(response.data!);
        await UserInfoService.saveUserInfo(userInfo);
        if (mounted) {
          setState(() {
            _userInfo = userInfo;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      body: CustomScrollView(
        slivers: <Widget>[
          // 顶部搜索栏 (保持不变)
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            title: Container(
              height: 32,
              decoration: BoxDecoration(
                color: _kBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: _kTextSecondary, size: 18),
                  SizedBox(width: 8),
                  Text('搜索对话、功能', style: TextStyle(color: _kTextSecondary, fontSize: 14)),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: _kTextPrimary),
                onPressed: () {},
              ),
            ],
          ),
          
          // 1. 个人信息与会员卡 (体现AI助手属性)
          SliverToBoxAdapter(child: _buildProfileCard()),
          
          // 2. 每日任务/福利 (保持交互性)
          SliverToBoxAdapter(child: _buildTaskCard()),
          
          // 3. AI 工具箱 (金刚区 - 替换为AI相关功能)
          SliverToBoxAdapter(child: _buildGridMenu()),
          
          // 4. 核心能力/资讯区
          SliverToBoxAdapter(child: _buildCapabilitiesCard()),

          // 5. 历史对话列表 (替换为AI对话记录)
          SliverToBoxAdapter(child: _buildListHeader()),
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildChatItem(index);
              },
              childCount: 10,
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // 1. 个人信息卡片
  Widget _buildProfileCard() {
    final nickname = _userInfo?.nickname ?? '智能用户';
    final phone = _userInfo?.phone ?? '';
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF818CF8)], // 紫色系，更显科技感
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 头像
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('你好，$nickname', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Pro 会员 · 2099-12-31 到期', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              // 续费按钮
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text('续费', style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 统计数据
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Text('1,280', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('对话次数', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
                Column(children: [
                  Text('56,800', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('消息总数', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
                Column(children: [
                  Text('98.5%', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('满意度', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. 每日任务
  Widget _buildTaskCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              const Text('每日福利', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              const Text('做任务领积分 >', style: TextStyle(color: _kTextSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _taskItem('签到', Icons.check_circle, true),
              _taskItem('对话3次', Icons.chat_bubble_outline, false),
              _taskItem('分享', Icons.share_outlined, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskItem(String label, IconData icon, bool done) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: done ? const Color(0xFFE0E7FF) : _kBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: done ? _kPrimaryColor : _kTextSecondary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: done ? _kPrimaryColor : _kTextSecondary)),
      ],
    );
  }

  // 3. AI 工具箱 (金刚区)
  Widget _buildGridMenu() {
    final List<Map<String, dynamic>> menus = [
      {'icon': Icons.translate, 'label': 'AI 翻译'},
      {'icon': Icons.code, 'label': '代码助手'},
      {'icon': Icons.article_outlined, 'label': '文案大师'},
      {'icon': Icons.school_outlined, 'label': '学术问答'},
      {'icon': Icons.image_outlined, 'label': '图像识别'},
      {'icon': Icons.summarize_outlined, 'label': '文档总结'},
      {'icon': Icons.music_note_outlined, 'label': '语音转写'},
      {'icon': Icons.dashboard_customize_outlined, 'label': '更多工具'},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _kBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(menus[index]['icon'] as IconData, color: _kPrimaryColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                menus[index]['label'] as String,
                style: const TextStyle(fontSize: 12, color: _kTextPrimary),
              ),
            ],
          );
        },
      ),
    );
  }

  // 4. 核心能力介绍
  Widget _buildCapabilitiesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('核心能力升级', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _capabilityItem(Icons.update, '模型升级', '已升级至 GPT-4o，逻辑更强'),
          const Divider(height: 24),
          _capabilityItem(Icons.speed, '响应优化', '平均响应时间 < 0.5秒'),
          const Divider(height: 24),
          _capabilityItem(Icons.lock_outline, '隐私保护', '全程加密，数据不留存'),
        ],
      ),
    );
  }

  Widget _capabilityItem(IconData icon, String title, String desc) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _kBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _kPrimaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 2),
            Text(desc, style: const TextStyle(color: _kTextSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  // 5. 对话历史列表
  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('最近对话', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: const Text('查看全部', style: TextStyle(color: _kPrimaryColor, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(int index) {
    final List<String> titles = [
      '帮我写一份React的Hooks最佳实践',
      '如何优化MySQL的慢查询？',
      '写一首关于秋天的现代诗',
      '分析这段Python代码的Bug',
      '制定一个健身减脂计划',
    ];
    final List<String> times = ['刚刚', '10分钟前', '昨天', '昨天', '3天前'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[index % titles.length],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(times[index % times.length], style: const TextStyle(color: _kTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _kBorderColor),
        ],
      ),
    );
  }
}
