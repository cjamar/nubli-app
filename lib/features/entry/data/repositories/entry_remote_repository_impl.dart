import 'package:notas_equipo_app/features/entry/data/datasources/entry_remote_datasource.dart';
import 'package:notas_equipo_app/features/entry/data/models/list_entry_model.dart';
import 'package:notas_equipo_app/features/entry/data/models/reminder_entry_model.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/reminder_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';

import '../models/entry_model.dart';

class EntryRemoteRepositoryImpl implements EntryRepository {
  final EntryRemoteDatasource remoteDatasource;

  EntryRemoteRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> delete(String id) async {
    await remoteDatasource.delete(id);
  }

  @override
  Future<List<EntryEntity>> getAll() async {
    final models = await remoteDatasource.getAll(); // List<EntryModel>
    return models.map((m) => m.toEntity()).toList(); // Convertir a EntryEntity
  }

  @override
  Future<EntryEntity?> getById(String id) async {
    final model = await remoteDatasource.getById(id); // EntryModel?
    return model?.toEntity(); // EntryEntity?
  }

  @override
  Future<void> save(EntryEntity entry) async {
    EntryModel model;

    if (entry is ListEntryEntity) {
      model = ListEntryModel.fromEntity(entry);
    } else if (entry is ReminderEntryEntity) {
      model = ReminderEntryModel.fromEntity(entry);
    } else {
      throw Exception('Tipo de Entry no soportado');
    }

    await remoteDatasource.save(model);
  }

  @override
  Future<void> update(EntryEntity entry) async {
    EntryModel model;

    if (entry is ListEntryEntity) {
      model = ListEntryModel.fromEntity(entry);
    } else if (entry is ReminderEntryEntity) {
      model = ReminderEntryModel.fromEntity(entry);
    } else {
      throw Exception('Tipo de Entry no soportado');
    }

    await remoteDatasource.update(model);
  }

  @override
  Future<List<EntryEntity>> getByCategory(String categoryId) async {
    final models = await remoteDatasource.getByCategory(categoryId);
    return models.map((m) => m.toEntity()).toList();
  }
}
