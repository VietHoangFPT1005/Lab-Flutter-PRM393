// ============================================================
// Feature 02 Screen – SePay Payment
// Flow: Nhập số tiền → Hiện QR → Auto-check → Thành công
// ============================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/payment_order.dart';
import '../services/sepay_service.dart';
import '../config/sepay_config.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amountCtrl = TextEditingController();
  final _descCtrl   = TextEditingController(text: 'Thanh toán đơn hàng');
  final _formKey    = GlobalKey<FormState>();

  PaymentOrder? _order;
  Timer?        _pollTimer;
  int           _pollCount = 0;
  static const  _maxPoll   = 60; // 60 × 5s = 5 phút

  // ── Create order & show QR ────────────────────────────────
  void _createOrder() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final orderId = 'ORD${Random().nextInt(999999).toString().padLeft(6, '0')}';
    final amount  = int.parse(_amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''));

    setState(() {
      _order = PaymentOrder(
        orderId: orderId,
        amount: amount,
        description: _descCtrl.text.trim(),
        status: PaymentStatus.checking,
      );
      _pollCount = 0;
    });

    // Poll SePay every 5 seconds
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkPayment());
  }

  Future<void> _checkPayment() async {
    if (_order == null) return;
    _pollCount++;

    final received = await SePayService.checkPaymentReceived(
      orderId: _order!.orderId,
      amount: _order!.amount,
    );

    if (!mounted) return;

    if (received) {
      _pollTimer?.cancel();
      setState(() => _order!.status = PaymentStatus.success);
      _showResultDialog(success: true);
    } else if (_pollCount >= _maxPoll) {
      _pollTimer?.cancel();
      setState(() => _order!.status = PaymentStatus.failed);
      _showResultDialog(success: false);
    }
  }

  void _showResultDialog({required bool success}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              color: success ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              success ? 'Thanh toán thành công!' : 'Hết thời gian thanh toán',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (success) ...[
              const SizedBox(height: 8),
              Text(_order!.amountFormatted,
                  style: const TextStyle(fontSize: 22, color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _order = null);
              _amountCtrl.clear();
            },
            child: Text(success ? 'Xong' : 'Thử lại'),
          ),
        ],
      ),
    );
  }

  void _cancelPayment() {
    _pollTimer?.cancel();
    setState(() => _order = null);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán SePay'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: _order == null ? _buildForm() : _buildQrPage(),
    );
  }

  // Step 1: Input form
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bank info card
            Card(
              color: Colors.deepOrange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tài khoản nhận tiền',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Divider(),
                    _infoRow('Ngân hàng', 'VietinBank'),
                    _infoRow('Số tài khoản', SePayConfig.accountNumber),
                    _infoRow('Chủ tài khoản', SePayConfig.accountName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Amount field
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền (VND)',
                hintText: 'Ví dụ: 50000',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Nhập số tiền';
                final n = int.tryParse(v.replaceAll(RegExp(r'[^0-9]'), ''));
                if (n == null || n < 1000) return 'Tối thiểu 1,000 đ';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Nội dung chuyển khoản',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập nội dung' : null,
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _createOrder,
              icon: const Icon(Icons.qr_code),
              label: const Text('Tạo mã QR thanh toán',
                  style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SizedBox(
                width: 130,
                child: Text(label,
                    style: const TextStyle(color: Colors.grey))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );

  // Step 2: QR code + auto-check
  Widget _buildQrPage() {
    final o = _order!;
    final remaining = (_maxPoll - _pollCount) * 5;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 10),
                Text('Đang chờ thanh toán...',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Amount
          Text(o.amountFormatted,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange)),
          const SizedBox(height: 4),
          Text('Nội dung: ${o.transferContent}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),

          // QR code image from VietQR
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              o.qrImageUrl,
              width: 280,
              height: 320,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  width: 280,
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 280,
                height: 180,
                child: Center(
                    child: Text('Không tải được QR\nKiểm tra kết nối mạng',
                        textAlign: TextAlign.center)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Timer
          Text(
            'Tự động kiểm tra sau mỗi 5 giây · Còn ${remaining}s',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Instruction
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('Hướng dẫn thanh toán',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _step('1', 'Mở app ngân hàng → Quét QR'),
                  _step('2', 'Kiểm tra số tiền: ${o.amountFormatted}'),
                  _step('3', 'Nhập đúng nội dung: ${o.transferContent}'),
                  _step('4', 'Xác nhận → Hệ thống tự động xác nhận'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: _cancelPayment,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Huỷ thanh toán'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _step(String num, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 11,
                backgroundColor: Colors.deepOrange,
                child: Text(num,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold))),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ],
        ),
      );
}
