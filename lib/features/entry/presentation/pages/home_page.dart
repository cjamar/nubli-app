import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';
import 'package:notas_equipo_app/core/utils/widgets_utils.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_filter_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_form_mode_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_type_entity.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_bloc.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_event.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_state.dart';
import 'package:notas_equipo_app/features/entry/presentation/pages/create_entry_page.dart';
import 'package:notas_equipo_app/core/app/drawer.dart';
import 'package:notas_equipo_app/features/entry/presentation/widgets/simple_widgets.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  EntryFilterEntity _activeFilter = EntryFilterEntity.all;

  List<EntryEntity> _getFilteredEntries(List<EntryEntity> entries) {
    switch (_activeFilter) {
      case EntryFilterEntity.notes:
        return _categoryFiltered(entries, AppStyles.noteText);
      case EntryFilterEntity.lists:
        return _categoryFiltered(entries, AppStyles.listText);
      case EntryFilterEntity.all:
        return entries;
    }
  }

  _categoryFiltered(List<EntryEntity> entries, String category) =>
      entries.where((e) => e.categoryId == category).toList();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/images/logo1.png'),
              width: size.width * 0.22,
            ),
          ],
        ),
        scrolledUnderElevation: 0,
        backgroundColor: AppStyles.primaryWhite,
        actions: [_userArea(context, size)],
      ),
      endDrawer: AppDrawer(),
      body: _bodyHome(size),
      backgroundColor: AppStyles.primaryWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.05),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () => _showEntryTypeSelector(context, size),
          backgroundColor: AppStyles.primaryColor,
          foregroundColor: AppStyles.primaryWhite,
          child: Icon(Icons.add, size: 40),
        ),
      ),
    );
  }

  _userArea(BuildContext context, Size size) => Builder(
    builder: (context) => IconButton(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      icon: CircleAvatar(
        backgroundColor: AppStyles.primaryColorLight,
        child: Icon(
          Icons.person_2_rounded,
          color: AppStyles.primaryColor,
          size: 30,
        ),
      ),
    ),
  );

  _bodyHome(Size size) => SizedBox(
    width: size.width,
    height: size.height,
    // padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
    child: BlocBuilder<EntryBloc, EntryState>(
      builder: (context, state) {
        if (state is EntryLoading) {
          return WidgetsUtils.loader(AppStyles.secondaryColorDark);
        }
        if (state is EntryLoaded) {
          if (state.entries.isEmpty) {
            return SimpleWidgets.emptyList(size);
          } else {
            final filteredEntries = _getFilteredEntries(state.entries);
            return _entryList(size, state, filteredEntries, context);
          }
        }

        if (state is EntryError) {
          return SimpleWidgets.errorContainer(size, state.message);
        }
        return const SizedBox.shrink();
      },
    ),
  );

  _entryList(
    Size size,
    EntryLoaded state,
    List<EntryEntity> filteredEntries,
    BuildContext context,
  ) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.only(top: size.height * 0.01),
      child: Column(
        children: [
          _filterList(size, state.entries),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == filteredEntries.length - 1
                      ? size.height * 0.15
                      : 0,
                ),
                child: _entryTile(size, filteredEntries, index, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _filterList(Size size, List<EntryEntity> entries) => SizedBox(
    width: size.width * 0.95,
    height: size.height * 0.05,
    child: Row(
      children: EntryFilterEntity.values
          .map<Widget>(
            (filter) => _filterListButton(size, filter.label, filter),
          )
          .toList(),
    ),
  );

  _filterListButton(Size size, String title, EntryFilterEntity filter) {
    final isActive = _activeFilter == filter;

    return GestureDetector(
      onTap: () => setState(() {
        _activeFilter = filter;
      }),
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.004,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.05),
          color: isActive
              ? AppStyles.primaryColor
              : AppStyles.primaryColorLight,
        ),
        child: Text(
          title,
          style: isActive
              ? AppStyles.mainTextStyleWhite
              : AppStyles.mainTextStylePrimary,
        ),
      ),
    );
  }

  _deleteItem(Size size, BuildContext context, EntryEntity entry) async {
    final shouldDelete = await _showModalDeleteItem(size, context, entry.title);
    // ignore: use_build_context_synchronously
    if (shouldDelete == true) {
      if (!context.mounted) return;

      // ignore: use_build_context_synchronously
      context.read<EntryBloc>().add(DeleteEntryEvent(entry.id));
    }
  }

  _entryTile(
    Size size,
    List<EntryEntity> entries,
    int index,
    BuildContext context,
  ) => InkWell(
    onLongPress: () => _deleteItem(size, context, entries[index]),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      // margin: EdgeInsets.symmetric(
      //   horizontal: size.width * 0.025,
      //   vertical: size.width * 0.015,
      // ),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(size.width * 0.025),
        // border: Border.all(color: AppStyles.primaryColorLight),
        border: Border(
          bottom: BorderSide(color: AppStyles.secondaryWhite, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          entries[index].title,
          style: AppStyles.tileTextStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: entries[index].secondaryText!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.01),
                    decoration: BoxDecoration(
                      color: entries[index].totalCheckedList!
                          ? AppStyles.secondaryColorDark
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Text(
                      entries[index].secondaryText!,
                      style: TextStyle(
                        color: entries[index].totalCheckedList!
                            ? AppStyles.primaryWhite
                            : AppStyles.primaryGrey,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        leading: Container(
          padding: EdgeInsets.all(size.width * 0.012),
          decoration: BoxDecoration(
            color: entries[index].categoryId == AppStyles.noteText
                ? AppStyles.primaryColorLight
                : AppStyles.secondaryColorLight,
            borderRadius: BorderRadius.circular(size.width * 0.02),
          ),
          child: Icon(
            entries[index].categoryId == AppStyles.noteText
                ? Icons.alarm_add_outlined
                : Icons.check_box_outlined,
            color: entries[index].categoryId == AppStyles.noteText
                ? AppStyles.primaryColor
                : AppStyles.secondaryColor,
            size: 24,
          ),
        ),
        // trailing: IconButton(
        //   onPressed: () => _deleteItem(size, context, entries[index]),
        //   icon: Icon(Icons.close, color: AppStyles.primaryGrey, size: 18),
        // ),
        onLongPress: () => _deleteItem(size, context, entries[index]),
        onTap: () => _goToEntryDetail(context, entries[index]),
      ),
    ),
  );

  _goToEntryDetail(BuildContext context, EntryEntity entry) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CreateEntryPage.edit(entry: entry)),
  );

  _showEntryTypeSelector(BuildContext context, Size size) =>
      showModalBottomSheet(
        context: context,
        builder: (context) => _modalBottomSheet(context, size),
      );

  _modalBottomSheet(BuildContext context, size) => Container(
    color: AppStyles.primaryColor,
    height: size.height * 0.5,
    padding: EdgeInsets.symmetric(
      vertical: size.height * 0.025,
      horizontal: size.width * 0.05,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          AppStyles.chooseEntryText,
          textAlign: TextAlign.center,
          style: AppStyles.h2TextStyleWhite,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _entryTypeCard(
              context,
              size,
              textIcon: '⏰',
              backgroundColor: AppStyles.primaryColorLightDarker,
              label: AppStyles.noteText,
              type: EntryTypeEntity.note,
            ),
            _entryTypeCard(
              context,
              size,
              textIcon: '📋',
              backgroundColor: AppStyles.secondaryColorLightDarker,
              label: AppStyles.listText,
              type: EntryTypeEntity.list,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _entryTypeCard(
    BuildContext context,
    Size size, {
    required String textIcon,
    required Color backgroundColor,
    required String label,
    required EntryTypeEntity type,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _openCreateEntry(context, type);
      },
      child: Card(
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.cardBorderRadius(size),
        ),
        child: SizedBox(
          width: size.width * 0.4,
          height: size.height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textIcon, style: TextStyle(fontSize: size.width * 0.12)),
              const SizedBox(height: 8),
              Text(label, style: AppStyles.cardTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  _openCreateEntry(BuildContext context, EntryTypeEntity type) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CreateEntryPage(type: type, mode: EntryFormModeEntity.create),
        ),
      );

  Future<bool?> _showModalDeleteItem(
    Size size,
    BuildContext context,
    String title,
  ) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      // title: Text(AppStyles.deleteEntryText),
      titlePadding: EdgeInsets.zero,
      content: Text(
        '${AppStyles.doYoWantDeleteText} "$title"?',
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        style: AppStyles.h1TextStyle,
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.width * 0.05,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.alertColor,
              ),
              child: Text(AppStyles.deleteText, style: AppStyles.formTextStyle),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.creamWhite,
              ),
              child: Text(
                AppStyles.cancelText,
                style: AppStyles.formTextStyle.copyWith(
                  color: AppStyles.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ],
      actionsPadding: EdgeInsets.only(
        top: size.height * 0.1,
        bottom: size.width * 0.05,
        left: size.width * 0.05,
        right: size.width * 0.05,
      ),
      backgroundColor: AppStyles.primaryWhite,
    ),
  );
}
