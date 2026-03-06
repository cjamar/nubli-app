import 'package:notas_equipo_app/features/entry/data/models/entry_model.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/recurrence_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/reminder_entry_entity.dart';

import '../../domain/entities/priority_entity.dart';

class ReminderEntryModel extends EntryModel {
  final String body;
  final DateTime? scheduledAt;
  final Recurrence? recurrence;

  ReminderEntryModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.priority,
    required super.createdAt,
    required this.body,
    required this.scheduledAt,
    required this.recurrence,
  });

  @override
  EntryEntity toEntity() => ReminderEntryEntity(
    id: id,
    categoryId: categoryId,
    title: title,
    priority: priority,
    createdAt: createdAt,
    body: body,
    scheduledAt: scheduledAt,
    recurrence: recurrence,
  );

  factory ReminderEntryModel.fromJson(Map<String, dynamic> json) =>
      ReminderEntryModel(
        id: json['id'],
        categoryId: json['categoryId'],
        title: json['title'],
        priority: PriorityEntity.values[json['priority']],
        createdAt: DateTime.parse(json['createdAt']),
        body: json['body'],
        scheduledAt: json['scheduled_at'] != null
            ? DateTime.parse(json['scheduled_at'])
            : null,
        recurrence: Recurrence.values[json['recurrence']],
      );

  factory ReminderEntryModel.fromSupabase({
    required Map<String, dynamic> base,
    required Map<String, dynamic> reminder,
  }) {
    return ReminderEntryModel(
      id: base['id'],
      categoryId: base['category_id'],
      title: base['title'],
      priority: PriorityEntity.values.firstWhere(
        (e) => e.name == base['priority'],
      ),
      createdAt: DateTime.parse(base['created_at']),
      body: reminder['body'],
      scheduledAt: reminder['scheduled_at'] != null
          ? DateTime.parse(reminder['scheduled_at'])
          : null,
      recurrence: reminder['recurrence'] != null
          ? Recurrence.values.firstWhere(
              (e) => e.name == reminder['recurrence'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'title': title,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'body': body,
    'scheduled_at': scheduledAt,
    'recurrence': recurrence,
  };

  factory ReminderEntryModel.fromEntity(ReminderEntryEntity entity) {
    return ReminderEntryModel(
      id: entity.id,
      categoryId: entity.categoryId,
      title: entity.title,
      priority: entity.priority,
      createdAt: entity.createdAt,
      body: entity.body,
      scheduledAt: entity.scheduledAt,
      recurrence: entity.recurrence,
    );
  }
}
