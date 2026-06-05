import 'package:flutter_test/flutter_test.dart';
import 'package:lab9_local_json_storage/models/local_item.dart';

void main() {
  test('LocalItem converts to and from JSON', () {
    const item = LocalItem(
      id: 7,
      title: 'JSON task',
      category: 'Study',
      note: 'Test mapping',
    );

    final mapped = LocalItem.fromJson(item.toJson());

    expect(mapped.id, 7);
    expect(mapped.title, 'JSON task');
    expect(mapped.category, 'Study');
    expect(mapped.note, 'Test mapping');
  });
}
