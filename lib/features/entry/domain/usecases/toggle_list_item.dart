import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';

class ToggleListItem {
  final EntryRepository repository;

  ToggleListItem(this.repository);

  Future<void> call({required ListEntryEntity entry, required String itemId}) {
    final updateItems = entry.items
        .map((item) => item.id == itemId ? item.toggle() : item)
        .toList();

    final updateEntry = ListEntryEntity(
      id: entry.id,
      categoryId: entry.categoryId,
      title: entry.title,
      priority: entry.priority,
      createdAt: entry.createdAt,
      items: updateItems,
    );

    return repository.save(updateEntry);
  }
}
