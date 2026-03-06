import 'package:notas_equipo_app/features/entry/data/models/list_entry_model.dart';
import 'package:notas_equipo_app/features/entry/data/models/list_item_model.dart';
import 'package:notas_equipo_app/features/entry/data/models/reminder_entry_model.dart';
import 'package:notas_equipo_app/features/entry/data/models/entry_model.dart';
import 'package:notas_equipo_app/features/entry/data/datasources/entry_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/priority_entity.dart';
import '../../domain/entities/recurrence_entity.dart';

class EntryRemoteDatasourceImpl implements EntryRemoteDatasource {
  final SupabaseClient _client;

  EntryRemoteDatasourceImpl(this._client);

  @override
  Future<void> save(EntryModel entry) async {
    if (entry is ListEntryModel) {
      // Guardar la lista en 'entries'
      await _client.from('entries').insert({
        'id': entry.id,
        'category_id': entry.categoryId,
        'title': entry.title,
        'priority': entry.priority.toString(),
        'created_at': entry.createdAt.toIso8601String(),
        'type': 'list',
      });

      // Guardar los items en 'list_items'
      for (final item in entry.items) {
        await _client.from('list_items').insert({
          'id': item.id,
          'entry_id': entry.id,
          'text': item.text,
          'is_checked': item.isChecked,
        });
      }
    } else if (entry is ReminderEntryModel) {
      // Guardar reminder en 'entries'
      await _client.from('entries').insert({
        'id': entry.id,
        'category_id': entry.categoryId,
        'title': entry.title,
        'priority': entry.priority.toString(),
        'created_at': entry.createdAt.toIso8601String(),
        'type': 'reminder',
        'body': entry.body,
        'scheduled_at': entry.scheduledAt?.toIso8601String(),
        'recurrence': entry.recurrence?.toString(),
      });
    }
  }

  @override
  Future<void> update(EntryModel entry) async {
    if (entry is ListEntryModel) {
      // Actualizar datos de la lista
      await _client
          .from('entries')
          .update({
            'title': entry.title,
            'priority': entry.priority.toString(),
            'category_id': entry.categoryId,
          })
          .eq('id', entry.id);

      // Para los items, borramos y reinsertamos (simplifica sincronización)
      await _client.from('list_items').delete().eq('entry_id', entry.id);
      for (final item in entry.items) {
        await _client.from('list_items').insert({
          'id': item.id,
          'entry_id': entry.id,
          'text': item.text,
          'is_checked': item.isChecked,
        });
      }
    } else if (entry is ReminderEntryModel) {
      await _client
          .from('entries')
          .update({
            'title': entry.title,
            'priority': entry.priority.toString(),
            'category_id': entry.categoryId,
            'body': entry.body,
            'scheduled_at': entry.scheduledAt?.toIso8601String(),
            'recurrence': entry.recurrence?.toString(),
          })
          .eq('id', entry.id);
    }
  }

  @override
  Future<EntryModel?> getById(String id) async {
    final entryData = await _client
        .from('entries')
        .select()
        .eq('id', id)
        .single();

    if (entryData == null) return null;

    final type = entryData['type'] as String;

    if (type == 'list') {
      final itemsData = await _client
          .from('list_items')
          .select()
          .eq('entry_id', id);
      final items = (itemsData as List)
          .map((json) => ListItemModel.fromJson(json))
          .toList();

      return ListEntryModel(
        id: entryData['id'],
        categoryId: entryData['category_id'],
        title: entryData['title'],
        priority: PriorityEntity.values.firstWhere(
          (e) => e.toString() == entryData['priority'],
        ),
        createdAt: DateTime.parse(entryData['created_at']),
        items: items,
      );
    } else if (type == 'reminder') {
      return ReminderEntryModel(
        id: entryData['id'],
        categoryId: entryData['category_id'],
        title: entryData['title'],
        priority: PriorityEntity.values.firstWhere(
          (e) => e.toString() == entryData['priority'],
        ),
        createdAt: DateTime.parse(entryData['created_at']),
        body: entryData['body'],
        scheduledAt: entryData['scheduled_at'] != null
            ? DateTime.parse(entryData['scheduled_at'])
            : null,
        recurrence: entryData['recurrence'] != null
            ? Recurrence.values.firstWhere(
                (e) => e.toString() == entryData['recurrence'],
              )
            : null,
      );
    }

    return null;
  }

  @override
  Future<List<EntryModel>> getAll() async {
    final entriesData = await _client
        .from('entries')
        .select()
        .order('created_at', ascending: true);

    final List<EntryModel> entries = [];

    for (final entryData in entriesData as List) {
      final type = entryData['type'] as String;

      if (type == 'list') {
        final itemsData = await _client
            .from('list_items')
            .select()
            .eq('entry_id', entryData['id']);
        final items = (itemsData as List)
            .map((json) => ListItemModel.fromJson(json))
            .toList();

        entries.add(
          ListEntryModel(
            id: entryData['id'],
            categoryId: entryData['category_id'],
            title: entryData['title'],
            priority: PriorityEntity.values.firstWhere(
              (e) => e.toString() == entryData['priority'],
            ),
            createdAt: DateTime.parse(entryData['created_at']),
            items: items,
          ),
        );
      } else if (type == 'reminder') {
        entries.add(
          ReminderEntryModel(
            id: entryData['id'],
            categoryId: entryData['category_id'],
            title: entryData['title'],
            priority: PriorityEntity.values.firstWhere(
              (e) => e.toString() == entryData['priority'],
            ),
            createdAt: DateTime.parse(entryData['created_at']),
            body: entryData['body'],
            scheduledAt: entryData['scheduled_at'] != null
                ? DateTime.parse(entryData['scheduled_at'])
                : null,
            recurrence: entryData['recurrence'] != null
                ? Recurrence.values.firstWhere(
                    (e) => e.toString() == entryData['recurrence'],
                  )
                : null,
          ),
        );
      }
    }

    return entries;
  }

  @override
  Future<List<EntryModel>> getByCategory(String categoryId) async {
    final entriesData = await _client
        .from('entries')
        .select()
        .eq('category_id', categoryId);

    final List<EntryModel> entries = [];

    for (final entryData in entriesData as List) {
      final type = entryData['type'] as String;

      if (type == 'list') {
        final itemsData = await _client
            .from('list_items')
            .select()
            .eq('entry_id', entryData['id']);
        final items = (itemsData as List)
            .map((json) => ListItemModel.fromJson(json))
            .toList();

        entries.add(
          ListEntryModel(
            id: entryData['id'],
            categoryId: entryData['category_id'],
            title: entryData['title'],
            priority: PriorityEntity.values.firstWhere(
              (e) => e.toString() == entryData['priority'],
            ),
            createdAt: DateTime.parse(entryData['created_at']),
            items: items,
          ),
        );
      } else if (type == 'reminder') {
        entries.add(
          ReminderEntryModel(
            id: entryData['id'],
            categoryId: entryData['category_id'],
            title: entryData['title'],
            priority: PriorityEntity.values.firstWhere(
              (e) => e.toString() == entryData['priority'],
            ),
            createdAt: DateTime.parse(entryData['created_at']),
            body: entryData['body'],
            scheduledAt: entryData['scheduled_at'] != null
                ? DateTime.parse(entryData['scheduled_at'])
                : null,
            recurrence: entryData['recurrence'] != null
                ? Recurrence.values.firstWhere(
                    (e) => e.toString() == entryData['recurrence'],
                  )
                : null,
          ),
        );
      }
    }

    return entries;
  }

  @override
  Future<void> delete(String id) async {
    // Si es lista, los items se borran automáticamente por ON DELETE CASCADE
    await _client.from('entries').delete().eq('id', id);
  }
}
