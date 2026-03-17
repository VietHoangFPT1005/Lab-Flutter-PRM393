import 'dart:async';
import 'dart:convert';

// ============================================================
// EXERCISE 1: Product Model & Repository
// Goal: Understand Futures and Streams
// ============================================================

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  // Danh sách sản phẩm mẫu
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 999.99),
    Product(id: 2, name: 'Phone', price: 699.99),
    Product(id: 3, name: 'Tablet', price: 499.99),
  ];

  // StreamController để phát sự kiện khi có sản phẩm mới
  final _controller = StreamController<Product>.broadcast();

  // Future: Lấy tất cả sản phẩm (mô phỏng delay từ API)
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1)); // Giả lập network delay
    return _products;
  }

  // Stream: Lắng nghe sản phẩm mới được thêm realtime
  Stream<Product> liveAdded() => _controller.stream;

  // Thêm sản phẩm mới và phát qua stream
  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product); // Emit event qua stream
  }

  void dispose() => _controller.close();
}

Future<void> exercise1() async {
  print('=' * 50);
  print('EXERCISE 1: Product Model & Repository');
  print('=' * 50);

  final repo = ProductRepository();

  // Lắng nghe stream trước
  repo.liveAdded().listen((product) {
    print('[Stream] New product added: $product');
  });

  // Lấy tất cả sản phẩm bằng Future
  print('\nFetching all products...');
  final products = await repo.getAll();
  print('All products:');
  for (var p in products) {
    print('  - $p');
  }

  // Thêm sản phẩm mới (sẽ trigger stream)
  print('\nAdding new product...');
  repo.addProduct(Product(id: 4, name: 'Headphones', price: 199.99));

  await Future.delayed(Duration(milliseconds: 100));
  repo.dispose();
  print('');
}

// ============================================================
// EXERCISE 2: User Repository with JSON
// Goal: Practice JSON serialization / deserialization
// ============================================================

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor để parse từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Chuyển object thành JSON
  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Mô phỏng JSON response từ API
  static const String _mockApiResponse = '''
  [
    {"name": "Nguyen Van A", "email": "vana@email.com"},
    {"name": "Tran Thi B", "email": "thib@email.com"},
    {"name": "Le Van C", "email": "vanc@email.com"}
  ]
  ''';

  // Fetch và parse JSON data
  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(seconds: 1)); // Giả lập network delay

    // Parse JSON string thành List<dynamic>
    final List<dynamic> jsonList = jsonDecode(_mockApiResponse);

    // Map từng item thành User object
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> exercise2() async {
  print('=' * 50);
  print('EXERCISE 2: User Repository with JSON');
  print('=' * 50);

  final userRepo = UserRepository();

  print('Fetching users from API...');
  final users = await userRepo.fetchUsers();

  print('Parsed ${users.length} users:');
  for (var user in users) {
    print('  - $user');
  }

  // Demo: Convert back to JSON
  print('\nConvert first user back to JSON:');
  print('  ${jsonEncode(users.first.toJson())}');
  print('');
}

// ============================================================
// EXERCISE 3: Async + Microtask Debugging
// Goal: Differentiate microtask and event queues
// ============================================================

void exercise3() {
  print('=' * 50);
  print('EXERCISE 3: Async + Microtask Debugging');
  print('=' * 50);

  print('1. Synchronous code START');

  // Event queue - thực thi sau cùng
  Future(() {
    print('4. Future callback (Event Queue)');
  });

  // Microtask queue - ưu tiên cao hơn event queue
  scheduleMicrotask(() {
    print('3. Microtask 1 (Microtask Queue)');
  });

  // Thêm một Future nữa
  Future(() {
    print('5. Another Future callback');
  });

  // Thêm một microtask nữa
  scheduleMicrotask(() {
    print('3.5. Microtask 2 (Microtask Queue)');
  });

  print('2. Synchronous code END');

  print('''
  
GIẢI THÍCH THỨ TỰ THỰC THI:
---------------------------
1. Code đồng bộ chạy TRƯỚC TIÊN (1, 2)
2. Microtask Queue chạy SAU code đồng bộ (3, 3.5)
3. Event Queue chạy CUỐI CÙNG (4, 5)

Lý do: Dart Event Loop ưu tiên:
  Synchronous > Microtask Queue > Event Queue
''');
}

// ============================================================
// EXERCISE 4: Stream Transformation
// Goal: Use functional stream operators (map, where)
// ============================================================

Future<void> exercise4() async {
  print('=' * 50);
  print('EXERCISE 4: Stream Transformation');
  print('=' * 50);

  // Tạo stream từ danh sách số 1-10
  final numberStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  print('Original numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10');
  print('Transform: square each number, then filter even results\n');

  // Chain các transformation
  await numberStream
      .map((n) {
    // Bình phương mỗi số
    final squared = n * n;
    print('map($n) => $squared');
    return squared;
  })
      .where((n) {
    // Lọc chỉ giữ số chẵn
    final isEven = n % 2 == 0;
    print('where($n) => isEven: $isEven');
    return isEven;
  })
      .listen((n) {
    // In kết quả cuối cùng
    print('>>> RESULT: $n\n');
  });

  print('Final filtered results: 4, 16, 36, 64, 100 (even squares)');
  print('');
}

// ============================================================
// EXERCISE 5: Factory Constructors & Cache (Singleton)
// Goal: Show how factory constructors implement caching
// ============================================================

class Settings {
  // Instance duy nhất (singleton)
  static Settings? _instance;

  // Các thuộc tính settings
  String theme;
  String language;

  // Private constructor - không thể gọi từ bên ngoài
  Settings._internal({this.theme = 'dark', this.language = 'vi'});

  // Factory constructor - luôn trả về cùng một instance
  factory Settings() {
    // Nếu chưa có instance, tạo mới
    _instance ??= Settings._internal();
    return _instance!;
  }

  // Factory với tham số tùy chỉnh
  factory Settings.custom({String? theme, String? language}) {
    _instance ??= Settings._internal(
      theme: theme ?? 'dark',
      language: language ?? 'vi',
    );
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: $theme, language: $language)';
}

// Ví dụ thêm: Cache pattern với factory
class Logger {
  static final Map<String, Logger> _cache = {};
  final String name;

  // Private constructor
  Logger._internal(this.name);

  // Factory trả về cached instance hoặc tạo mới
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  void log(String message) => print('[$name] $message');
}

void exercise5() {
  print('=' * 50);
  print('EXERCISE 5: Factory Constructors & Cache');
  print('=' * 50);

  // Test Singleton Pattern
  print('\n--- Singleton Pattern ---');
  final settings1 = Settings();
  final settings2 = Settings();

  print('settings1: $settings1');
  print('settings2: $settings2');
  print('identical(settings1, settings2): ${identical(settings1, settings2)}');

  // Thay đổi settings1, settings2 cũng bị ảnh hưởng
  settings1.theme = 'light';
  print('\nAfter settings1.theme = "light":');
  print('settings2.theme = ${settings2.theme} (same object!)');

  // Test Cache Pattern
  print('\n--- Cache Pattern ---');
  final logger1 = Logger('API');
  final logger2 = Logger('API');
  final logger3 = Logger('Database');

  print('identical(logger1, logger2): ${identical(logger1, logger2)} (same name)');
  print('identical(logger1, logger3): ${identical(logger1, logger3)} (different name)');

  logger1.log('Request sent');
  logger3.log('Query executed');
  print('');
}

// ============================================================
// MAIN FUNCTION - Chạy tất cả exercises
// ============================================================

void main() async {
  print('\n🚀 LAB 3 - ADVANCED DART PRACTICE EXERCISES\n');

  await exercise1();
  await Future.delayed(Duration(milliseconds: 500));

  await exercise2();
  await Future.delayed(Duration(milliseconds: 500));

  exercise3();
  // Đợi event loop xử lý xong
  await Future.delayed(Duration(milliseconds: 100));

  await exercise4();

  exercise5();

  print('=' * 50);
  print('✅ ALL EXERCISES COMPLETED!');
  print('=' * 50);
}