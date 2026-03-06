import 'package:notas_equipo_app/features/entry/data/models/entry_model.dart';
import 'package:notas_equipo_app/features/entry/data/models/list_item_model.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/priority_entity.dart';

class ListEntryModel extends EntryModel {
  final List<ListItemModel> items;

  ListEntryModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.priority,
    required super.createdAt,
    required this.items,
  });

  @override
  ListEntryEntity toEntity() => ListEntryEntity(
    id: id,
    categoryId: categoryId,
    title: title,
    priority: priority,
    createdAt: createdAt,
    items: items.map((e) => e.toEntity()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'title': title,
    'priority': priority,
    'created_at': createdAt.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory ListEntryModel.fromJson(Map<String, dynamic> json) => ListEntryModel(
    id: json['id'],
    categoryId: json['categoryId'],
    title: json['title'],
    priority: PriorityEntity.values[json['priority']],
    createdAt: DateTime.parse(json['created_at']),
    items: (json['items'] as List)
        .map((e) => ListItemModel.fromJson(e))
        .toList(),
  );

  factory ListEntryModel.fromSupabase({
    required Map<String, dynamic> base,
    required List<dynamic> itemsJson,
  }) {
    return ListEntryModel(
      id: base['id'],
      categoryId: base['category_id'],
      title: base['title'],
      priority: PriorityEntity.values.firstWhere(
        (e) => e.name == base['priority'],
      ),
      createdAt: DateTime.parse(base['created_at']),
      items: itemsJson
          .map(
            (e) => ListItemModel(
              id: e['id'],
              text: e['text'],
              isChecked: e['is_checked'],
            ),
          )
          .toList(),
    );
  }

  factory ListEntryModel.fromEntity(ListEntryEntity entity) {
    return ListEntryModel(
      id: entity.id,
      categoryId: entity.categoryId,
      title: entity.title,
      priority: entity.priority,
      createdAt: entity.createdAt,
      items: entity.items.map((e) => ListItemModel.fromEntity(e)).toList(),
    );
  }
}
