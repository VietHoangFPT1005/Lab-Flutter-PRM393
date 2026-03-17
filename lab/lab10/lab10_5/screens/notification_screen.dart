// Lab 10.5 – Local Notification Demo Screen

import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notifService = NotificationService();
  bool _permissionGranted = false;
  int _notifId = 100;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final granted = await _notifService.requestPermission();
    setState(() => _permissionGranted = granted);
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Notification permission denied. Enable in Settings.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _sendNotification({
    required String title,
    required String body,
  }) async {
    await _notifService.showNotification(
      id: _notifId++,
      title: title,
      body: body,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent: "$title"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5 – Notifications'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Permission status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _permissionGranted
                      ? Colors.green[50]
                      : Colors.red[50],
                  border: Border.all(
                    color: _permissionGranted ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _permissionGranted
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: _permissionGranted ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _permissionGranted
                          ? 'Notification permission granted'
                          : 'Notification permission denied',
                      style: TextStyle(
                        color: _permissionGranted ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Trigger Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Notification buttons
              _NotifButton(
                icon: Icons.check_circle,
                label: 'Login Success Notification',
                color: Colors.green,
                onTap: () => _notifService.notifyLoginSuccess('Student'),
              ),
              const SizedBox(height: 12),
              _NotifButton(
                icon: Icons.logout,
                label: 'Logout Notification',
                color: Colors.red,
                onTap: _notifService.notifyLogout,
              ),
              const SizedBox(height: 12),
              _NotifButton(
                icon: Icons.notifications,
                label: 'Custom Notification',
                color: Colors.orange,
                onTap: () => _sendNotification(
                  title: '🔔 Lab 10 Alert',
                  body: 'This is a custom notification from Lab 10.5!',
                ),
              ),
              const SizedBox(height: 12),
              _NotifButton(
                icon: Icons.shopping_cart,
                label: 'Order Placed Notification',
                color: Colors.blue,
                onTap: () => _sendNotification(
                  title: '📦 Order Placed!',
                  body: 'Your order #${DateTime.now().millisecondsSinceEpoch % 10000} has been placed.',
                ),
              ),
              const SizedBox(height: 24),
              if (!_permissionGranted)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _requestPermission,
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Request Permission Again'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Future<void> Function() onTap;

  const _NotifButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          await onTap();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('$label sent!'),
                  duration: const Duration(seconds: 1)),
            );
          }
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
