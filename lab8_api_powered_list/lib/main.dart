import 'package:flutter/material.dart';

import 'screens/posts_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(PostListApp(repository: HttpPostsApiService()));
}

class PostListApp extends StatelessWidget {
  const PostListApp({super.key, required this.repository});

  final PostsRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 8 API List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: PostsScreen(repository: repository),
    );
  }
}
