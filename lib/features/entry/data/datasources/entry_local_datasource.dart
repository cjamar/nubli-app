import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';

abstract class EntryLocalDatasource {
  Future<void> save(EntryEntity entry);
  Future<EntryEntity?> getById(String id);
  Future<List<EntryEntity>> getAll();
  Future<List<EntryEntity>> getByCategory(String categoryId);
  Future<void> delete(String id);
}
