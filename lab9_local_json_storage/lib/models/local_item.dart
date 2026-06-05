class LocalItem {
  const LocalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.note,
  });

  final int id;
  final String title;
  final String category;
  final String note;

  factory LocalItem.fromJson(Map<String, dynamic> json) {
    return LocalItem(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'category': category, 'note': note};
  }

  LocalItem copyWith({int? id, String? title, String? category, String? note}) {
    return LocalItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
