import 'package:notas_equipo_app/features/entry/domain/entities/reminder_entry_entity.dart';

import '../entities/priority_entity.dart';
import '../entities/recurrence_entity.dart';
import '../repositories/entry_repository.dart';

class CreateReminderEntry {
  final EntryRepository repository;

  CreateReminderEntry(this.repository);

  Future<void> call({
    required String id,
    required String categoryId,
    required String title,
    required String body,
    required PriorityEntity priority,
    required DateTime? scheduledAt,
    Recurrence? recurrence,
  }) {
    final entry = ReminderEntryEntity(
      id: id,
      categoryId: categoryId,
      title: title,
      body: body,
      priority: priority,
      createdAt: DateTime.now(),
      scheduledAt: scheduledAt,
      recurrence: recurrence,
    );

    return repository.save(entry);
  }
}
