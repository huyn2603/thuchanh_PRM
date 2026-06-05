import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, required this.repository});

  final PostsRepository repository;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.repository.fetchPosts();
  }

  void _reload() {
    setState(() {
      _postsFuture = widget.repository.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Something went wrong. Please try again.',
              onRetry: _reload,
            );
          }

          final posts = snapshot.data ?? const <Post>[];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${post.id}')),
                    title: Text(post.title),
                    subtitle: Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePostSheet,
        icon: const Icon(Icons.add),
        label: const Text('POST'),
      ),
    );
  }

  Future<void> _openCreatePostSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CreatePostSheet(repository: widget.repository);
      },
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key, required this.repository});

  final PostsRepository repository;

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Create Post', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              labelText: 'Body',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Send POST request'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final post = await widget.repository.createPost(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Created post #${post.id}')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not create post.')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
