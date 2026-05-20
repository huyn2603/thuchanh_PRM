import 'dart:async';
import 'dart:convert';

// =====================================================
// LAB 3 - ADVANCED DART PRACTICE
// =====================================================

// =====================================================
// EXERCISE 1 - PRODUCT MODEL & REPOSITORY
// =====================================================

// Product model
class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}

// Repository
class ProductRepository {
  // Broadcast stream controller
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  // Fake database
  List<Product> products = [
    Product(1, "Laptop", 1200),
    Product(2, "Mouse", 25),
    Product(3, "Keyboard", 80),
  ];

  // Future function
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));

    return products;
  }

  // Stream function
  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  // Add new product
  void addProduct(Product product) {
    products.add(product);

    _controller.add(product);
  }
}

Future<void> exercise1() async {
  print("========== EXERCISE 1 ==========");

  ProductRepository repo = ProductRepository();

  // Get all products
  List<Product> allProducts = await repo.getAll();

  print("All products:");

  for (var product in allProducts) {
    print(product);
  }

  // Listen stream
  repo.liveAdded().listen((product) {
    print("New product added: $product");
  });

  // Add new product
  repo.addProduct(Product(4, "Monitor", 300));

  await Future.delayed(Duration(seconds: 1));

  print("");
}

// =====================================================
// EXERCISE 2 - USER REPOSITORY WITH JSON
// =====================================================

class User {
  String name;
  String email;

  User(this.name, this.email);

  // Factory fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['email'],
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

// Simulate API
Future<List<User>> fetchUsers() async {
  await Future.delayed(Duration(seconds: 1));

  // Fake JSON response
  String jsonData = '''
  [
    {"name":"Duy","email":"duy@gmail.com"},
    {"name":"John","email":"john@gmail.com"}
  ]
  ''';

  // Decode JSON
  List<dynamic> data = jsonDecode(jsonData);

  // Convert JSON to User list
  return data.map((item) => User.fromJson(item)).toList();
}

Future<void> exercise2() async {
  print("========== EXERCISE 2 ==========");

  List<User> users = await fetchUsers();

  for (var user in users) {
    print(user);
  }

  print("");
}

// =====================================================
// EXERCISE 3 - ASYNC + MICROTASK DEBUGGING
// =====================================================

void exercise3() {
  print("========== EXERCISE 3 ==========");

  print("Start");

  // Microtask queue
  scheduleMicrotask(() {
    print("Microtask executed");
  });

  // Event queue
  Future(() {
    print("Future executed");
  });

  print("End");

  print("");
}

// =====================================================
// EXERCISE 4 - STREAM TRANSFORMATION
// =====================================================

Future<void> exercise4() async {
  print("========== EXERCISE 4 ==========");

  // Stream numbers
  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Transform stream
  Stream<int> transformed = numbers
      .map((number) => number * number)
      .where((number) => number % 2 == 0);

  // Listen stream
  await for (var value in transformed) {
    print(value);
  }

  print("");
}

// =====================================================
// EXERCISE 5 - FACTORY CONSTRUCTORS & CACHE
// =====================================================

class Settings {
  // Singleton instance
  static final Settings _instance = Settings._internal();

  // Private constructor
  Settings._internal();

  // Factory constructor
  factory Settings() {
    return _instance;
  }
}

void exercise5() {
  print("========== EXERCISE 5 ==========");

  Settings a = Settings();

  Settings b = Settings();

  // Check same object
  print(identical(a, b));

  print("");
}

// =====================================================
// MAIN FUNCTION
// =====================================================

Future<void> main() async {
  await exercise1();

  await exercise2();

  exercise3();

  // Wait a little for async order
  await Future.delayed(Duration(seconds: 1));

  await exercise4();

  exercise5();

  print("========== FINISHED LAB 3 ==========");
}