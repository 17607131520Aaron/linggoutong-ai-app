import 'dart:async';
import 'package:flutter/material.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isComposing = false;
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _isTyping) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isComposing = false;
    });

    _messageController.clear();
    _scrollToBottom();

    // 模拟AI回复（打字机效果）
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startTypingEffect('收到您的消息：${_messages.last.text}');
      }
    });
  }

  void _startTypingEffect(String fullText) {
    setState(() {
      _isTyping = true;
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        isTyping: true,
      ));
    });

    int charIndex = 0;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (charIndex < fullText.length) {
        setState(() {
          _messages.last = ChatMessage(
            text: fullText.substring(0, charIndex + 1),
            isUser: false,
            timestamp: _messages.last.timestamp,
            isTyping: true,
          );
        });
        charIndex++;
        _scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          _isTyping = false;
          _messages.last = ChatMessage(
            text: fullText,
            isUser: false,
            timestamp: _messages.last.timestamp,
            isTyping: false,
          );
        });
      }
    });
  }

  void _stopTyping() {
    _typingTimer?.cancel();
    if (_messages.isNotEmpty && _messages.last.isTyping) {
      setState(() {
        _isTyping = false;
        _messages.last = ChatMessage(
          text: _messages.last.text,
          isUser: false,
          timestamp: _messages.last.timestamp,
          isTyping: false,
        );
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleQuickQuestion(String question) {
    _messageController.text = question;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI对话'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _typingTimer?.cancel();
              setState(() {
                _messages.clear();
                _isTyping = false;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // AI头像和欢迎语
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '你好，我是AI助手',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '有什么我可以帮你的吗？',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          // 快捷问题卡片
          _buildQuickQuestionCard(
            icon: Icons.lightbulb_outline,
            title: '帮我写一篇',
            subtitle: '文章、报告、文案',
            question: '帮我写一篇关于人工智能的文章',
          ),
          const SizedBox(height: 12),
          _buildQuickQuestionCard(
            icon: Icons.code,
            title: '帮我写代码',
            subtitle: 'Python、Java、前端',
            question: '帮我写一个Python快速排序算法',
          ),
          const SizedBox(height: 12),
          _buildQuickQuestionCard(
            icon: Icons.translate,
            title: '帮我翻译',
            subtitle: '中英互译、多语言',
            question: '帮我翻译这段话成英文：你好世界',
          ),
          const SizedBox(height: 12),
          _buildQuickQuestionCard(
            icon: Icons.school_outlined,
            title: '帮我解答问题',
            subtitle: '数学、科学、历史',
            question: '什么是机器学习？',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String question,
  }) {
    return GestureDetector(
      onTap: () => _handleQuickQuestion(question),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                  ),
                  child: message.isTyping
                      ? _buildTypingText(message)
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 18, color: Colors.blueGrey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingText(ChatMessage message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        _buildCursor(),
      ],
    );
  }

  Widget _buildCursor() {
    return AnimatedCursor();
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 左侧加号按钮
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.grey[600], size: 28),
              onPressed: () {
                _showAddMenu();
              },
            ),
          ),
          const SizedBox(width: 4),
          // 输入框
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 100),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: '输入你的问题...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onChanged: (text) {
                        setState(() {
                          _isComposing = text.trim().isNotEmpty;
                        });
                      },
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  // 语音按钮
                  IconButton(
                    icon: Icon(Icons.mic_outlined, color: Colors.grey[600], size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('语音功能开发中，敬请期待'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 发送按钮或停止按钮
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              onTap: _isTyping
                  ? _stopTyping
                  : (_isComposing ? _sendMessage : null),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isTyping
                      ? Colors.red[400]
                      : (_isComposing
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isTyping ? Icons.stop : Icons.arrow_upward,
                  color: _isTyping
                      ? Colors.white
                      : (_isComposing ? Colors.white : Colors.grey[500]),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMenuItem(
                      icon: Icons.photo_library_outlined,
                      label: '相册',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('功能开发中，敬请期待')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.camera_alt_outlined,
                      label: '拍摄',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('功能开发中，敬请期待')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.insert_drive_file_outlined,
                      label: '文件',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('功能开发中，敬请期待')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 28, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCursor extends StatefulWidget {
  const AnimatedCursor({super.key});

  @override
  State<AnimatedCursor> createState() => _AnimatedCursorState();
}

class _AnimatedCursorState extends State<AnimatedCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 2,
          height: 16,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: Colors.black87.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });
}
