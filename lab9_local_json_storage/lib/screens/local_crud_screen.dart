import 'package:flutter/material.dart';

import '../models/local_item.dart';
import '../services/json_storage_service.dart';

class LocalCrudScreen extends StatefulWidget {
  const LocalCrudScreen({super.key, required this.storageService});

  final JsonStorageService storageService;

  @override
  State<LocalCrudScreen> createState() => _LocalCrudScreenState();
}

class _LocalCrudScreenState extends State<LocalCrudScreen> {
  final _searchController = TextEditingController();
  List<LocalItem> _items = [];
  bool _isLoading = true;
  String _query = '';

  List<LocalItem> get _visibleItems {
    final query = _query.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.note.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final items = await widget.storageService.loadItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _saveItems() async {
    await widget.storageService.saveItems(_items);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON saved to device storage.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search local JSON database',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: _visibleItems.length,
              itemBuilder: (context, index) {
                final item = _visibleItems[index];
                return Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text('${item.category}\n${item.note}'),
                    isThreeLine: true,
                    trailing: Wrap(
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () => _openEditor(item),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => _confirmDelete(item),
                          icon: const Icon(Icons.delete),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(null),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
    );
  }

  Future<void> _openEditor(LocalItem? item) async {
    final result = await showDialog<LocalItem>(
      context: context,
      builder: (context) => ItemEditorDialog(item: item, nextId: _nextId()),
    );

    if (result == null) return;

    setState(() {
      if (item == null) {
        _items.add(result);
      } else {
        final index = _items.indexWhere((entry) => entry.id == item.id);
        _items[index] = result;
      }
    });
    await _saveItems();
  }

  Future<void> _confirmDelete(LocalItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Remove "${item.title}" from local JSON storage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    setState(() {
      _items.removeWhere((entry) => entry.id == item.id);
    });
    await _saveItems();
  }

  int _nextId() {
    if (_items.isEmpty) return 1;
    return _items.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}

class ItemEditorDialog extends StatefulWidget {
  const ItemEditorDialog({super.key, required this.item, required this.nextId});

  final LocalItem? item;
  final int nextId;

  @override
  State<ItemEditorDialog> createState() => _ItemEditorDialogState();
}

class _ItemEditorDialogState extends State<ItemEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _categoryController = TextEditingController(
      text: widget.item?.category ?? '',
    );
    _noteController = TextEditingController(text: widget.item?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Add item' : 'Edit item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final item = LocalItem(
              id: widget.item?.id ?? widget.nextId,
              title: _titleController.text.trim(),
              category: _categoryController.text.trim(),
              note: _noteController.text.trim(),
            );
            Navigator.pop(context, item);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
