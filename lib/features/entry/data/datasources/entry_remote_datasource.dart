import 'package:notas_equipo_app/features/entry/data/models/entry_model.dart';

abstract class EntryRemoteDatasource {
  Future<void> save(EntryModel entry);
  Future<void> update(EntryModel entry);
  Future<EntryModel?> getById(String id);
  Future<List<EntryModel>> getAll();
  Future<List<EntryModel>> getByCategory(String categoryId);
  Future<void> delete(String id);
}
