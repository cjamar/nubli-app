import 'package:notas_equipo_app/features/entry/data/datasources/entry_local_datasource.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';

class InMemoryEntryDatasource implements EntryLocalDatasource {
  final List<EntryEntity> _entries = [];

  @override
  Future<void> delete(String id) async =>
      _entries.removeWhere((e) => e.id == id);

  @override
  Future<List<EntryEntity>> getAll() async => List.from(_entries);

  @override
  Future<List<EntryEntity>> getByCategory(String categoryId) async =>
      _entries.where((e) => e.categoryId == categoryId).toList();

  @override
  Future<EntryEntity?> getById(String id) async {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(EntryEntity entry) async {
    _entries.removeWhere((e) => e.id == entry.id);
    _entries.add(entry);
  }
}
