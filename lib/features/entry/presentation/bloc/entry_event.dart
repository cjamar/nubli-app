import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_item_entity.dart';

abstract class EntryEvent {}

class LoadEntries extends EntryEvent {}

class CreateListEntryEvent extends EntryEvent {
  final String title;
  final String categoryId;
  final List<ListItemEntity> items;

  CreateListEntryEvent({
    required this.title,
    required this.categoryId,
    required this.items,
  });
}

class CreateReminderEntryEvent extends EntryEvent {
  final String title;
  final String categoryId;
  final String body;
  final DateTime? scheduledAt;

  CreateReminderEntryEvent({
    required this.title,
    required this.categoryId,
    required this.body,
    this.scheduledAt,
  });
}

class UpdateEntryEvent extends EntryEvent {
  final EntryEntity entry;
  UpdateEntryEvent(this.entry);
}

class DeleteEntryEvent extends EntryEvent {
  final String entryId;
  DeleteEntryEvent(this.entryId);
}
