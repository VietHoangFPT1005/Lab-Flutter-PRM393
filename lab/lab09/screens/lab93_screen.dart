// Lab 9.3 – JSON CRUD Mini Database
// Full Add / Edit / Delete / Search on local JSON storage
// Auto-saves after every change

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  bool _isLoading = true;

  static const String _fileName = 'lab93_products.json';

  // ── Initial seed data ──────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> _seedData = [
    {'id': 1, 'name': 'Wireless Headphones', 'category': 'Electronics', 'price': 89.99, 'inStock': true},
    {'id': 2, 'name': 'Running Shoes', 'category': 'Sports', 'price': 120.0, 'inStock': true},
    {'id': 3, 'name': 'Coffee Maker', 'category': 'Kitchen', 'price': 49.99, 'inStock': false},
    {'id': 4, 'name': 'Yoga Mat', 'category': 'Sports', 'price': 25.0, 'inStock': true},
    {'id': 5, 'name': 'Smart Watch', 'category': 'Electronics', 'price': 199.99, 'inStock': true},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── Storage helpers ────────────────────────────────────────────────────────

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> _loadData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);
        _allProducts = decoded.map((e) => Product.fromJson(e)).toList();
      } else {
        // First launch: use seed data
        _allProducts = _seedData.map((e) => Product.fromJson(e)).toList();
        await _saveData(); // persist seed
      }
    } catch (e) {
      _allProducts = _seedData.map((e) => Product.fromJson(e)).toList();
    }
    _applyFilter();
    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    final file = await _getFile();
    final encoded = jsonEncode(_allProducts.map((p) => p.toJson()).toList());
    await file.writeAsString(encoded);
  }

  void _applyFilter() {
    final q = _searchQuery.toLowerCase();
    setState(() {
      _filteredProducts = q.isEmpty
          ? List.from(_allProducts)
          : _allProducts
              .where((p) =>
                  p.name.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q))
              .toList();
    });
  }

  int _nextId() {
    if (_allProducts.isEmpty) return 1;
    return _allProducts.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // ── CRUD Operations ────────────────────────────────────────────────────────

  Future<void> _addProduct(Product product) async {
    _allProducts.add(product);
    await _saveData();
    _applyFilter();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added: ${product.name}')),
      );
    }
  }

  Future<void> _updateProduct(Product updated) async {
    final index = _allProducts.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _allProducts[index] = updated;
      await _saveData();
      _applyFilter();
    }
  }

  Future<void> _deleteProduct(int id) async {
    _allProducts.removeWhere((p) => p.id == id);
    await _saveData();
    _applyFilter();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── Dialog for Add / Edit ──────────────────────────────────────────────────

  void _showProductDialog({Product? existing}) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl =
        TextEditingController(text: existing?.category ?? '');
    final priceCtrl =
        TextEditingController(text: existing?.price.toString() ?? '');
    bool inStock = existing?.inStock ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Product' : 'Add Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('In Stock'),
                    value: inStock,
                    onChanged: (v) => setDialogState(() => inStock = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final category = categoryCtrl.text.trim();
                  final price = double.tryParse(priceCtrl.text.trim());
                  if (name.isEmpty || category.isEmpty || price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all fields correctly')),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  if (isEdit) {
                    _updateProduct(Product(
                      id: existing.id,
                      name: name,
                      category: category,
                      price: price,
                      inStock: inStock,
                    ));
                  } else {
                    _addProduct(Product(
                      id: _nextId(),
                      name: name,
                      category: category,
                      price: price,
                      inStock: inStock,
                    ));
                  }
                },
                child: Text(isEdit ? 'Save' : 'Add'),
              ),
            ],
          );
        });
      },
    );
  }

  // ── Delete with confirm dialog ─────────────────────────────────────────────

  void _confirmDelete(Product p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content:
            Text('Are you sure you want to delete "${p.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(p.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 – CRUD Database'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Search bar ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or category...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() => _searchQuery = '');
                                _applyFilter();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFilter();
                    },
                  ),
                ),

                // ── Count bar ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${_filteredProducts.length} product(s)',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // ── Product list ─────────────────────────────────────
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No products found.',
                              style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            final p = _filteredProducts[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  child: Text(
                                    '${p.id}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                title: Text(p.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  '${p.category} • \$${p.price.toStringAsFixed(2)}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: p.inStock
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.inStock ? 'In Stock' : 'Out',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 20),
                                      onPressed: () =>
                                          _showProductDialog(existing: p),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 20),
                                      onPressed: () => _confirmDelete(p),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
