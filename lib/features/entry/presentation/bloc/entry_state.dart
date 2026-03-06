import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';

abstract class EntryState {}

class EntryInitial extends EntryState {}

class EntryLoading extends EntryState {}

class EntryLoaded extends EntryState {
  final List<EntryEntity> entries;

  EntryLoaded(this.entries);
}

class EntryError extends EntryState {
  final String message;

  EntryError(this.message);
}
