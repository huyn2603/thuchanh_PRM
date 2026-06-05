import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

abstract class PostsRepository {
  Future<List<Post>> fetchPosts();
  Future<Post> createPost({required String title, required String body});
}

class HttpPostsApiService implements PostsRepository {
  HttpPostsApiService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _postsUri = Uri.https(
    'jsonplaceholder.typicode.com',
    '/posts',
  );

  @override
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client
          .get(_postsUri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Server returned status ${response.statusCode}');
      }

      final decoded = json.decode(response.body) as List<dynamic>;
      return decoded
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw Exception('Something went wrong while loading posts: $error');
    }
  }

  @override
  Future<Post> createPost({required String title, required String body}) async {
    final response = await _client.post(
      _postsUri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'title': title, 'body': body, 'userId': 1}),
    );

    if (response.statusCode != 201) {
      throw Exception('Create failed with status ${response.statusCode}');
    }

    return Post.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
