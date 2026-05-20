// ======================================================
// LAB 2 - DART ESSENTIALS PRACTICE
// ======================================================

// ======================================================
// EXERCISE 1 - BASIC SYNTAX & DATA TYPES
// ======================================================

void exercise1() {
  print("========== EXERCISE 1 ==========");

  // Integer
  int age = 22;

  // Double
  double height = 1.75;

  // String
  String name = "Duy";

  // Boolean
  bool isStudent = true;

  // Print variables
  print("Name: $name");
  print("Age: $age");
  print("Height: $height");
  print("Student: $isStudent");

  // String interpolation with expression
  print("Next year age: ${age + 1}");

  print("");
}

// ======================================================
// EXERCISE 2 - COLLECTIONS & OPERATORS
// ======================================================

void exercise2() {
  print("========== EXERCISE 2 ==========");

  // List
  List<int> numbers = [10, 20, 30, 40];

  print("Original List: $numbers");

  // Access by index
  print("First element: ${numbers[0]}");

  // Add element
  numbers.add(50);

  print("After add: $numbers");

  // Remove element
  numbers.remove(20);

  print("After remove: $numbers");

  // Arithmetic operators
  int a = 10;
  int b = 5;

  print("a + b = ${a + b}");
  print("a - b = ${a - b}");
  print("a * b = ${a * b}");
  print("a / b = ${a / b}");

  // Comparison operators
  print("a == b : ${a == b}");
  print("a > b : ${a > b}");

  // Logical operators
  bool x = true;
  bool y = false;

  print("x && y : ${x && y}");

  // Ternary operator
  String result = a > b ? "a is bigger" : "b is bigger";

  print(result);

  // Set (unique values)
  Set<String> fruits = {"Apple", "Banana", "Apple"};

  print("Set values: $fruits");

  // Map
  Map<String, dynamic> student = {
    "name": "Duy",
    "age": 22,
    "gpa": 3.5
  };

  // Access map
  print("Student name: ${student["name"]}");
  print("Student GPA: ${student["gpa"]}");

  print("");
}

// ======================================================
// EXERCISE 3 - CONTROL FLOW & FUNCTIONS
// ======================================================

// Normal function
int addNumbers(int a, int b) {
  return a + b;
}

// Arrow function
int multiplyNumbers(int a, int b) => a * b;

void exercise3() {
  print("========== EXERCISE 3 ==========");

  // If else
  int score = 85;

  if (score >= 90) {
    print("Grade A");
  } else if (score >= 70) {
    print("Grade B");
  } else {
    print("Grade C");
  }

  // Switch case
  String day = "Monday";

  switch (day) {
    case "Monday":
      print("Start of week");
      break;

    case "Friday":
      print("Weekend coming");
      break;

    default:
      print("Normal day");
  }

  // For loop
  print("For loop:");

  for (int i = 1; i <= 5; i++) {
    print(i);
  }

  // For-in loop
  List<String> colors = ["Red", "Green", "Blue"];

  print("For-in loop:");

  for (String color in colors) {
    print(color);
  }

  // forEach loop
  print("forEach loop:");

  colors.forEach((color) {
    print(color);
  });

  // Function calls
  int sum = addNumbers(5, 3);

  print("Sum = $sum");

  int multiply = multiplyNumbers(4, 2);

  print("Multiply = $multiply");

  print("");
}

// ======================================================
// EXERCISE 4 - INTRO TO OOP
// ======================================================

// Parent class
class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named constructor
  Car.named() : brand = "Unknown";

  // Method
  void showInfo() {
    print("Car brand: $brand");
  }
}

// Child class
class ElectricCar extends Car {
  int battery;

  ElectricCar(String brand, this.battery) : super(brand);

  // Override method
  @override
  void showInfo() {
    print("Electric Car: $brand");
    print("Battery: $battery%");
  }
}

void exercise4() {
  print("========== EXERCISE 4 ==========");

  // Create object
  Car car1 = Car("Toyota");

  car1.showInfo();

  // Named constructor
  Car car2 = Car.named();

  car2.showInfo();

  // Subclass object
  ElectricCar tesla = ElectricCar("Tesla", 90);

  tesla.showInfo();

  print("");
}

// ======================================================
// EXERCISE 5 - ASYNC, FUTURE, NULL SAFETY & STREAMS
// ======================================================

// Async function
Future<void> loadData() async {
  print("Loading data...");

  // Simulate loading delay
  await Future.delayed(Duration(seconds: 2));

  print("Data loaded!");
}

// Stream function
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));

    yield i;
  }
}

Future<void> exercise5() async {
  print("========== EXERCISE 5 ==========");

  // Async await
  await loadData();

  // Null safety
  String? nullableName;

  // Null check operator
  print(nullableName ?? "No name");

  nullableName = "Duy";

  print(nullableName);

  // Non-null assertion operator
  print(nullableName!.length);

  // Stream
  print("Stream values:");

  await for (int value in numberStream()) {
    print(value);
  }

  print("");
}

// ======================================================
// MAIN FUNCTION
// ======================================================

Future<void> main() async {
  exercise1();

  exercise2();

  exercise3();

  exercise4();

  await exercise5();

  print("========== FINISHED ALL EXERCISES ==========");
}