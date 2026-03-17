// ============================================================
// Feature 04 Screen – Notification Screen
// ============================================================

import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _notifId = 100;

  // Sample data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Đơn hàng đã được xác nhận',
      body: 'Đơn hàng #ORD12345 của bạn đã được xác nhận và đang được xử lý.',
      type: NotificationType.success,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      id: '2',
      title: 'Khuyến mãi đặc biệt!',
      body: 'Giảm 30% cho tất cả sản phẩm hôm nay. Đừng bỏ lỡ!',
      type: NotificationType.promo,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Cảnh báo đăng nhập',
      body: 'Phát hiện đăng nhập từ thiết bị mới. Nếu không phải bạn, hãy đổi mật khẩu ngay.',
      type: NotificationType.warning,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationItem(
      id: '4',
      title: 'Cập nhật hệ thống',
      body: 'Ứng dụng đã được cập nhật lên phiên bản 2.1.0 với nhiều tính năng mới.',
      type: NotificationType.info,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Thanh toán thành công',
      body: 'Bạn đã thanh toán thành công 150,000đ cho đơn hàng #ORD67890.',
      type: NotificationType.success,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    NotificationService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get _unreadList =>
      _notifications.where((n) => !n.isRead).toList();

  // ── Actions ───────────────────────────────────────────────
  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _toggleRead(NotificationItem item) {
    setState(() => item.isRead = !item.isRead);
  }

  void _deleteNotification(NotificationItem item) {
    setState(() => _notifications.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá thông báo')),
    );
  }

  // ── Send test notifications ───────────────────────────────
  Future<void> _sendImmediate() async {
    await NotificationService.showNow(
      id: _notifId++,
      title: '🔔 Thông báo ngay lập tức',
      body: 'Đây là thông báo được gửi ngay lập tức lúc ${TimeOfDay.now().format(context)}',
    );
    // Also add to in-app list
    setState(() {
      _notifications.insert(
        0,
        NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Thông báo test',
          body: 'Thông báo được tạo lúc ${TimeOfDay.now().format(context)}',
          type: NotificationType.info,
        ),
      );
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi thông báo ngay lập tức!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _sendScheduled() async {
    await NotificationService.showNow(
      id: _notifId++,
      title: '⏰ Thông báo hẹn giờ',
      body: 'Thông báo này được lên lịch 5 giây trước.',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lên lịch thông báo sau 5 giây!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // ── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Thông báo'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Đọc tất cả',
                  style: TextStyle(color: Colors.white70)),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            const Tab(text: 'Tất cả'),
            Tab(text: 'Chưa đọc ($_unreadCount)'),
          ],
        ),
      ),

      // Test buttons bar
      bottomNavigationBar: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _sendImmediate,
                icon: const Icon(Icons.notifications_active, size: 18),
                label: const Text('Ngay lập tức'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _sendScheduled,
                icon: const Icon(Icons.schedule, size: 18),
                label: const Text('Hẹn 5 giây'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_notifications),
          _buildList(_unreadList),
        ],
      ),
    );
  }

  Widget _buildList(List<NotificationItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Không có thông báo',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => _buildTile(items[i]),
    );
  }

  Widget _buildTile(NotificationItem item) {
    final style = NotificationItem.typeStyle[item.type]!;
    final color = Color(style.colorValue);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteNotification(item),
      child: InkWell(
        onTap: () => _toggleRead(item),
        child: Container(
          color: item.isRead ? null : color.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(style.icon, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
