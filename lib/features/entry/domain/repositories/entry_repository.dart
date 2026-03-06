import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';

abstract class EntryRepository {
  Future<void> save(EntryEntity entry);
  Future<List<EntryEntity>> getAll();
  Future<List<EntryEntity>> getByCategory(String categoryId);
  Future<EntryEntity?> getById(String id);
  Future<void> update(EntryEntity entry);
  Future<void> delete(String id);
}
