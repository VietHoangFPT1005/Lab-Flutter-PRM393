import 'dart:async';

void main() async {
  print('========== LAB 2: DART ESSENTIALS ==========');

  // Thực thi lần lượt các bài tập
  exercise1();
  exercise2();
  exercise3();
  exercise4();
  await exercise5(); // Sử dụng await vì bài 5 có xử lý bất đồng bộ

  print('========== END OF LAB 2 ==========');
}

// --- Exercise 1: Basic Syntax & Data Types ---
// Mục tiêu: Khai báo biến và sử dụng String Interpolation [cite: 17]
void exercise1() {
  print('\n===== EXERCISE 1: BASIC SYNTAX & DATA TYPES =====');

  // Khai báo các kiểu dữ liệu cơ bản [cite: 20]
  int age = 20;
  double height = 1.75;
  String name = 'Nguyen Viet Hoang';
  bool isStudent = true;

  // Sử dụng string interpolation ($var, ${expr}) để in giá trị [cite: 21]
  print('Name: $name');
  print('Age: $age years old');
  print('Height: $height meters');
  print('Is student: $isStudent');
  print('Next year age: ${age + 1}'); // Biểu thức trong ${}
}

// --- Exercise 2: Collections & Operators ---
// Mục tiêu: Thao tác với List, Set, Map và các toán tử [cite: 23]
void exercise2() {
  print('\n===== EXERCISE 2: COLLECTIONS & OPERATORS =====');

  // 1. List - Danh sách có thứ tự [cite: 25]
  List<int> numbers = [1, 2, 3, 4, 5];
  print('Original list: $numbers');

  // Toán tử số học & so sánh [cite: 26]
  int sum = numbers[0] + numbers[1];
  int diff = numbers[4] - numbers[0];
  print('Sum of first two: $sum');
  print('Difference: $diff');

  // 2. Set - Tập hợp các giá trị duy nhất [cite: 27]
  Set<String> fruits = {'apple', 'banana', 'orange'};
  fruits.add('apple'); // Sẽ không được thêm vì đã tồn tại
  print('Fruits set: $fruits');

  // 3. Map - Cấu trúc Key-Value [cite: 27]
  Map<String, int> scores = {'Math': 90, 'Physics': 85};
  scores['Chemistry'] = 88; // Thêm phần tử mới [cite: 28]
  print('Scores: $scores');
  print('Math score: ${scores['Math']}');

  // Toán tử điều kiện (Ternary) [cite: 23]
  String sizeStatus = numbers.length > 3 ? 'Large list' : 'Small list';
  print('List size: $sizeStatus');
}

// --- Exercise 3: Control Flow & Functions ---
// Mục tiêu: Áp dụng logic điều khiển và hàm [cite: 30]
void exercise3() {
  print('\n===== EXERCISE 3: CONTROL FLOW & FUNCTIONS =====');

  // Kiểm tra điểm bằng if/else [cite: 32]
  int score = 85;
  print('Score: $score');
  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');
  } else {
    print('Grade: F');
  }

  // Vòng lặp [cite: 34]
  List<String> colors = ['Red', 'Green', 'Blue'];
  print('--- Loop examples ---');
  for (var color in colors) {
    print('Color: $color');
  }

  // Sử dụng hàm (Normal & Arrow syntax) [cite: 35]
  int add(int a, int b) => a + b; // Arrow syntax
  print('Sum using arrow function: ${add(10, 5)}');
}

// --- Exercise 4: Intro to OOP ---
// Mục tiêu: Lớp, kế thừa và ghi đè phương thức [cite: 37]
class Car {
  String brand;
  int year;

  // Constructor thông thường [cite: 39]
  Car(this.brand, this.year);

  // Named constructor [cite: 40]
  Car.withoutYear(this.brand) : year = 0;

  void displayInfo() {
    print('Car: $brand, Year: ${year == 0 ? "N/A" : year}');
  }
}

// Subclass kế thừa Car
class ElectricCar extends Car {
  int batteryRange;

  ElectricCar(String brand, int year, this.batteryRange) : super(brand, year);

  @override
  void displayInfo() {
    print('Electric Car: $brand, Year: $year, Range: $batteryRange km');
  }
}

void exercise4() {
  print('\n===== EXERCISE 4: INTRO TO OOP =====');

  Car car1 = Car('Toyota', 2020);
  car1.displayInfo();

  Car car2 = Car.withoutYear('Honda');
  car2.displayInfo();

  ElectricCar tesla = ElectricCar('Tesla', 2023, 400);
  tesla.displayInfo(); // Gọi phương thức đã override
}

// --- Exercise 5: Async, Future, Null Safety & Streams ---
// Mục tiêu: Xử lý bất đồng bộ và an toàn kiểu null [cite: 43]
Future<void> exercise5() async {
  print('\n===== EXERCISE 5: ASYNC, FUTURE & NULL SAFETY =====');

  // 1. Async/Await & Future [cite: 46]
  print('Start loading data...');
  String data = await fetchData(); // Giả lập chờ tải dữ liệu [cite: 47]
  print('Data received: $data');

  // 2. Null Safety [cite: 48]
  String? nullableName; // Có thể null
  print('Name length: ${nullableName?.length ?? "Null value"}'); // Toán tử ? và ??

  // 3. Streams [cite: 49]
  print('--- Stream Example ---');
  await for (int val in countStream(3)) {
    print('Stream value: $val');
  }
}

// Hàm giả lập tải dữ liệu [cite: 47]
Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 1), () => 'Sample Data');
}

// Hàm tạo Stream đơn giản [cite: 49]
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    yield i;
  }
}