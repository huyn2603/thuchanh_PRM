import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_api_powered_list/main.dart';
import 'package:lab8_api_powered_list/models/post.dart';
import 'package:lab8_api_powered_list/services/api_service.dart';

class FakePostsRepository implements PostsRepository {
  @override
  Future<Post> createPost({required String title, required String body}) async {
    return Post(userId: 1, id: 101, title: title, body: body);
  }

  @override
  Future<List<Post>> fetchPosts() async {
    return const [
      Post(userId: 1, id: 1, title: 'First API post', body: 'Loaded from fake'),
    ];
  }
}

void main() {
  testWidgets('renders posts from repository', (tester) async {
    await tester.pumpWidget(PostListApp(repository: FakePostsRepository()));
    await tester.pumpAndSettle();

    expect(find.text('API Posts'), findsOneWidget);
    expect(find.text('First API post'), findsOneWidget);
  });
}
