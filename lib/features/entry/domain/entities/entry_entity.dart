import 'priority_entity.dart';

abstract class EntryEntity {
  final String id;
  final String categoryId;
  final String title;
  final PriorityEntity priority;
  final DateTime createdAt;

  const EntryEntity({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.priority,
    required this.createdAt,
  });

  String? get secondaryText;
  bool? get totalCheckedList;
}
