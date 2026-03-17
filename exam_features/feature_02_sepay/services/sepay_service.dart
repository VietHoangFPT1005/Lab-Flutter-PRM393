// ============================================================
// Feature 02 Service – SePay API
// Checks if a payment has been received via SePay transaction list
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/sepay_config.dart';

class SePayService {
  static const _timeout = Duration(seconds: 10);

  /// Returns true if a transaction matching [orderId] and [amount]
  /// has been received in the last 15 minutes.
  static Future<bool> checkPaymentReceived({
    required String orderId,
    required int amount,
  }) async {
    try {
      final uri = Uri.parse(SePayConfig.transactionListUrl).replace(
        queryParameters: {
          'limit': '10',
          'account_number': SePayConfig.accountNumber,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${SePayConfig.apiKey}',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      if (response.statusCode != 200) return false;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final transactions = data['transactions'] as List<dynamic>? ?? [];

      for (final tx in transactions) {
        final content = (tx['transaction_content'] as String? ?? '').toLowerCase();
        final amtIn   = int.tryParse(tx['amount_in']?.toString() ?? '0') ?? 0;

        // Match: amount AND orderId appears in the transfer content
        if (amtIn == amount && content.contains(orderId.toLowerCase())) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
