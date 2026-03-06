import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_item_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/priority_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';

class CreateListEntry {
  final EntryRepository repository;

  CreateListEntry(this.repository);

  Future<void> call({
    required String id,
    required String categoryId,
    required String title,
    required PriorityEntity priority,
    required List<ListItemEntity> items,
  }) {
    final entry = ListEntryEntity(
      id: id,
      categoryId: categoryId,
      title: title,
      priority: priority,
      createdAt: DateTime.now(),
      items: items,
    );

    return repository.save(entry);
  }
}
