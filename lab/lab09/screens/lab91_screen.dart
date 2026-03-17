// Lab 9.1 – Read JSON From Assets
// Loads products.json from assets using rootBundle

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    try {
      // Lab 9.1 – Step 3 & 4: Load & decode JSON from assets
      final jsonString =
          await rootBundle.loadString('lab/lab09/data/products.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _products = jsonList.map((e) => Product.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 – Assets JSON'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $_error',
                        style: const TextStyle(color: Colors.red)),
                  ),
                )
              : ListView.builder(
                  itemCount: _products.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final p = _products[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            '${p.id}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(p.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${p.category} • \$${p.price.toStringAsFixed(2)}'),
                        trailing: Chip(
                          label: Text(
                            p.inStock ? 'In Stock' : 'Out of Stock',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white),
                          ),
                          backgroundColor:
                              p.inStock ? Colors.green : Colors.red,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
