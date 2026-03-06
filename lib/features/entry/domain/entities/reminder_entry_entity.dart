import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/recurrence_entity.dart';

import '../../../../core/utils/helper_utils.dart';

class ReminderEntryEntity extends EntryEntity {
  final String body;
  final DateTime? scheduledAt;
  final Recurrence? recurrence;

  const ReminderEntryEntity({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.priority,
    required super.createdAt,
    required this.body,
    this.scheduledAt,
    this.recurrence,
  });

  String get formattedDate {
    if (scheduledAt == null) return '';
    return HelperUtils.formatDate(scheduledAt!);
  }

  @override
  String get secondaryText => formattedDate;

  @override
  bool? get totalCheckedList => false;
}
