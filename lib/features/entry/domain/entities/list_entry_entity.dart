import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'list_item_entity.dart';

class ListEntryEntity extends EntryEntity {
  final List<ListItemEntity> items;

  const ListEntryEntity({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.priority,
    required super.createdAt,
    required this.items,
  });

  @override
  String get secondaryText {
    final checked = items.where((e) => e.isChecked).length;
    return '$checked/${items.length}';
  }

  @override
  bool? get totalCheckedList {
    final checked = items.where((e) => e.isChecked).length;
    if (checked == items.length) return true;
    return false;
  }
}
