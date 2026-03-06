import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_item_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';

class AddItemToList {
  final EntryRepository repository;

  AddItemToList(this.repository);

  Future<void> call({
    required ListEntryEntity entry,
    required String itemId,
    required String text,
  }) {
    final updatedEntry = ListEntryEntity(
      id: entry.id,
      categoryId: entry.categoryId,
      title: entry.title,
      priority: entry.priority,
      createdAt: entry.createdAt,
      items: [
        ...entry.items,
        ListItemEntity(id: itemId, text: text, isChecked: false),
      ],
    );

    return repository.save(updatedEntry);
  }
}
