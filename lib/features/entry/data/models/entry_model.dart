import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/priority_entity.dart';

abstract class EntryModel {
  final String id;
  final String categoryId;
  final String title;
  final PriorityEntity priority;
  final DateTime createdAt;

  EntryModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.priority,
    required this.createdAt,
  });

  // para mapear a entidad
  EntryEntity toEntity();
}
