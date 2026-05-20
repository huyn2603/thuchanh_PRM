import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab 1',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First Flutter UI'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 80,
              ),

              SizedBox(height: 20),

              Text(
                'Hello Flutter!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  print("Button clicked");
                },
                child: Text('Click Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}