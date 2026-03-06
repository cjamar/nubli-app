import 'package:notas_equipo_app/features/entry/data/datasources/entry_local_datasource.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';

class EntryLocalRepositoryImpl implements EntryRepository {
  final EntryLocalDatasource localDataSource;

  EntryLocalRepositoryImpl({required this.localDataSource});

  @override
  Future<void> delete(String id) => localDataSource.delete(id);

  @override
  Future<List<EntryEntity>> getAll() => localDataSource.getAll();

  @override
  Future<List<EntryEntity>> getByCategory(String categoryId) =>
      localDataSource.getByCategory(categoryId);

  @override
  Future<EntryEntity?> getById(String id) => localDataSource.getById(id);

  @override
  Future<void> save(EntryEntity entry) => localDataSource.save(entry);

  @override
  Future<void> update(EntryEntity entry) async {
    // 1. Traemos todas las entries que tenemos
    final currentEntries = await localDataSource.getAll();

    // 2. Creamos una nueva lista reemplazando solo la entry editada
    final updatedEntries = currentEntries.map((e) {
      if (e.id == entry.id) return entry;

      return e;
    }).toList();

    // 3. Guardamos de nuevo todas las entries
    // asumimos que localDataSource.save() puede sobrescribir si la entry existe
    for (final e in updatedEntries) {
      await localDataSource.save(e);
    }
  }
}
