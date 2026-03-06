import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/priority_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/repositories/entry_repository.dart';
import 'package:notas_equipo_app/features/entry/domain/usecases/create_list_entry.dart';
import 'package:notas_equipo_app/features/entry/domain/usecases/create_reminder_entry.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_event.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_state.dart';
import 'package:uuid/uuid.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final EntryRepository repository;
  final CreateListEntry createListEntry;
  final CreateReminderEntry createReminderEntry;

  EntryBloc({
    required this.repository,
    required this.createListEntry,
    required this.createReminderEntry,
  }) : super(EntryInitial()) {
    on<LoadEntries>(_onLoadEntries);
    on<CreateListEntryEvent>(_onCreateListEntry);
    on<CreateReminderEntryEvent>(_onCreateReminderEntry);
    on<UpdateEntryEvent>(_onUpdateEntry);
    on<DeleteEntryEvent>(_onDeleteEntry);
  }

  Future<void> _onLoadEntries(
    LoadEntries event,
    Emitter<EntryState> emit,
  ) async {
    if (kDebugMode) {
      print('Ejecutando LoadEntries');
    }
    emit(EntryLoading());
    try {
      final entries = await repository.getAll();
      if (kDebugMode) {
        print('onLoadEntriesBloc. Entradas cargadas: ${entries.length}');
      }
      emit(EntryLoaded(entries));
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }

  Future<void> _onCreateListEntry(
    CreateListEntryEvent event,
    Emitter<EntryState> emit,
  ) async {
    final uuid = Uuid();
    await createListEntry(
      id: uuid.v4(),
      title: event.title,
      categoryId: event.categoryId,
      priority: PriorityEntity.medium,
      items: event.items,
    );

    add(LoadEntries());
  }

  Future<void> _onCreateReminderEntry(
    CreateReminderEntryEvent event,
    Emitter<EntryState> emit,
  ) async {
    final uuid = Uuid();
    await createReminderEntry(
      id: uuid.v4(),
      title: event.title,
      body: event.body,
      categoryId: event.categoryId,
      priority: PriorityEntity.medium,
      scheduledAt: event.scheduledAt,
    );

    add(LoadEntries());
  }

  Future<void> _onUpdateEntry(
    UpdateEntryEvent event,
    Emitter<EntryState> emit,
  ) async {
    try {
      emit(EntryLoading());

      // Actualizamos la entry en el repository
      await repository.update(event.entry);

      // Recargamos TODAS las entradas desde el repository
      final entries = await repository.getAll();

      emit(EntryLoaded(entries));
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteEntry(
    DeleteEntryEvent event,
    Emitter<EntryState> emit,
  ) async {
    try {
      emit(EntryLoading());
      await repository.delete(event.entryId);
      final entries = await repository.getAll();

      emit(EntryLoaded(entries));
    } catch (e) {
      emit(EntryError(e.toString()));
    }
  }
}
