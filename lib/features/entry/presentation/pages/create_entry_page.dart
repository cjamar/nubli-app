import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';
import 'package:notas_equipo_app/core/utils/helper_utils.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_form_mode_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/entry_type_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/list_item_entity.dart';
import 'package:notas_equipo_app/features/entry/domain/entities/reminder_entry_entity.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_bloc.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_event.dart';
import 'package:uuid/uuid.dart';

class CreateEntryPage extends StatefulWidget {
  const CreateEntryPage({
    super.key,
    required this.type,
    required this.mode,
    this.entry,
  });
  final EntryTypeEntity type;
  final EntryFormModeEntity mode;
  final EntryEntity? entry;

  bool get isEdit => entry != null;

  @override
  State<CreateEntryPage> createState() => _CreateEntryPageState();

  const CreateEntryPage.create({super.key, required this.type})
    : mode = EntryFormModeEntity.create,
      entry = null;

  const CreateEntryPage.edit({super.key, required this.entry})
    : mode = EntryFormModeEntity.edit,
      type = entry is ListEntryEntity
          ? EntryTypeEntity.list
          : EntryTypeEntity.note;
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textAreaController = TextEditingController();
  final TextEditingController _itemListController = TextEditingController();
  bool get isList => widget.type == EntryTypeEntity.list;
  List<ListItemEntity> itemList = [];
  EntryEntity? entry;
  bool _enabledAddButton = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
    _editMode();
    _titleController.addListener(_revalidateForm);
    _textAreaController.addListener(_revalidateForm);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textAreaController.dispose();
    super.dispose();
  }

  int get checkedCountList => itemList.where((item) => item.isChecked).length;
  bool get completedList =>
      checkedCountList == itemList.length && itemList.isNotEmpty;

  Color get _darkColorListOrNote {
    return widget.type == EntryTypeEntity.list
        ? AppStyles.secondaryColorDark
        : AppStyles.primaryColor;
  }

  Color get _lightColorListOrNote {
    return widget.type == EntryTypeEntity.list
        ? AppStyles.secondaryColorLight
        : AppStyles.primaryColorLight;
  }

  _editMode() {
    if (widget.isEdit && entry != null) {
      _titleController.text = entry!.title;

      if (entry is ReminderEntryEntity) {
        final note = entry as ReminderEntryEntity;
        _textAreaController.text = note.body;
        _selectedDate = note.scheduledAt;
      }

      if (entry is ListEntryEntity) {
        final list = entry as ListEntryEntity;

        itemList = list.items
            .map(
              (e) => ListItemEntity(
                id: e.id,
                text: e.text,
                isChecked: e.isChecked,
              ),
            )
            .toList();
      }
    }
    _revalidateForm();
  }

  bool _hasChanges() {
    if (!widget.isEdit || entry == null) return true;

    final titleChanged = _titleController.text.trim() != entry!.title;

    if (entry is ReminderEntryEntity) {
      final note = entry as ReminderEntryEntity;

      final bodyChanged = _textAreaController.text.trim() != note.body;

      final dateChanged = _selectedDate != note.scheduledAt;

      return titleChanged || bodyChanged || dateChanged;
    }

    if (entry is ListEntryEntity) {
      final list = entry as ListEntryEntity;

      final itemsChanged =
          itemList.length != list.items.length ||
          !itemList.asMap().entries.every((e) {
            final original = list.items[e.key];
            return e.value.text == original.text &&
                e.value.isChecked == original.isChecked;
          });

      return titleChanged || itemsChanged;
    }

    return false;
  }

  _revalidateForm() {
    final hasTitle = _titleController.text.trim().isNotEmpty;

    final isValid = isList
        ? hasTitle && itemList.isNotEmpty
        : hasTitle && _textAreaController.text.trim().isNotEmpty;

    if (widget.isEdit) {
      _isFormValid.value = isValid && _hasChanges();
    } else {
      _isFormValid.value = isValid;
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appbarWidget(size),
        backgroundColor: _lightColorListOrNote,
        body: _bodyFormEntry(size, context),
      ),
    );
  }

  _appbarWidget(Size size) => AppBar(
    leading: TextButton(
      onPressed: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back, color: _darkColorListOrNote, size: 30),
    ),
    actionsPadding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
    backgroundColor: Colors.transparent,
    actions: [
      isList ? _checkedItemsCount(size) : SizedBox.shrink(),
      _deleteItemButton(size),
    ],
  );

  _deleteItemButton(Size size) => IconButton(
    onPressed: () {},
    icon: Icon(Icons.delete, color: _darkColorListOrNote),
  );

  _checkedItemsCount(Size size) => Container(
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: checkedCountList == itemList.length && itemList.isNotEmpty
          ? AppStyles.secondaryColorDark
          : null,
      borderRadius: BorderRadius.circular(size.width * 0.06),
    ),
    child: Text(
      '$checkedCountList / ${itemList.length}',
      style: AppStyles.mainTextStyle.copyWith(
        color: completedList ? AppStyles.primaryWhite : AppStyles.primaryDark,
      ),
    ),
  );

  _bodyFormEntry(Size size, BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
    width: size.width,
    height: size.height * 0.8,
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _titleField(size),
              isList ? _listArea(size) : _noteArea(size),
            ],
          ),
          _submitButton(size, context),
        ],
      ),
    ),
  );

  _titleField(Size size) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: _titleController,
    builder: (context, value, _) => TextFormField(
      controller: _titleController,
      style: AppStyles.h1TextStyle,
      validator: (value) => value == null || value.trim().isEmpty
          ? AppStyles.errorTextfield
          : null,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        fillColor: _lightColorListOrNote,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _darkColorListOrNote, width: 2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppStyles.alertColor, width: 2),
        ),
        hintText: isList ? AppStyles.listTextfield : AppStyles.noteTextfield,
        hintStyle: AppStyles.h1TextStyle,
        labelStyle: AppStyles.mainTextStyle,
        suffixIcon: value.text.isNotEmpty
            ? _clearButtonTextField(
                controller: _titleController,
                mustToEnableAddButton: false,
              )
            : null,
      ),
    ),
  );

  _noteArea(Size size) =>
      Column(children: [_textArea(size), _pickDateField(size, context)]);

  _textArea(Size size) => Container(
    margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textAreaController,
      builder: (context, value, child) => TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        controller: _textAreaController,
        style: AppStyles.bigTextFieldStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: _lightColorListOrNote,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppStyles.alertColor, width: 2),
          ),
          hintText: AppStyles.writeYourNoteText,
          hintStyle: AppStyles.bigTextFieldStyle,
          labelStyle: AppStyles.mainTextStyle,
        ),
      ),
    ),
  );

  _listArea(Size size) => Container(
    margin: EdgeInsets.only(top: size.height * 0.02),
    height: size.height * 0.65,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_itemListTextField(size), _addButton(size)],
        ),
        _itemList(size),
      ],
    ),
  );

  _pickDateField(Size size, BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: _titleController,
        builder: (context, value, _) {
          return SizedBox(
            width: size.width * 0.95,
            height: size.height * 0.05,
            child: ElevatedButton(
              onPressed: () => _pickDate(context),

              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppStyles.primaryWhite,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _selectedDate == null
                        ? AppStyles.chooseReminderDate
                        : HelperUtils.formatDate(_selectedDate!),
                    style: AppStyles.formTextStyle.copyWith(
                      color: AppStyles.primaryDark,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: AppStyles.primaryDark,
                    size: 25,
                  ),
                ],
              ),
            ),
          );
        },
      );

  _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      barrierColor: AppStyles.primaryColor,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      barrierColor: AppStyles.primaryColor,
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Guardamos fecha+hora en el estado
    setState(() => _selectedDate = scheduledAt);

    _revalidateForm();
  }

  _submitButton(Size size, BuildContext context) =>
      ValueListenableBuilder<bool>(
        valueListenable: _isFormValid,
        builder: (context, isValid, _) {
          return SizedBox(
            width: size.width * 0.95,
            height: size.height * 0.05,
            child: ElevatedButton(
              onPressed: isValid ? _typeOfSubmit : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: widget.type == EntryTypeEntity.list
                    ? AppStyles.secondaryColorLightDarker
                    : AppStyles.primaryColorLightDarker,
                backgroundColor: _darkColorListOrNote,
              ),
              child: Text(
                widget.mode == EntryFormModeEntity.create
                    ? AppStyles.createText
                    : AppStyles.updateText,
                style: AppStyles.formTextStyle,
              ),
            ),
          );
        },
      );

  _itemListTextField(Size size) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: _itemListController,
    builder: (context, value, _) => SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        onChanged: (value) => setState(() {
          value.isNotEmpty
              ? _enabledAddButton = true
              : _enabledAddButton = false;
        }),
        controller: _itemListController,
        style: AppStyles.bigTextFieldStyle,
        validator: (value) => value == null || value.trim().isEmpty
            ? AppStyles.errorTextfield
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: _lightColorListOrNote,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _darkColorListOrNote, width: 2),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppStyles.alertColor, width: 2),
          ),
          hintText: AppStyles.addItemToListText,
          hintStyle: AppStyles.bigTextFieldStyle,
          labelStyle: AppStyles.mainTextStyle,
          suffixIcon: value.text.isNotEmpty
              ? _clearButtonTextField(
                  controller: _itemListController,
                  mustToEnableAddButton: true,
                )
              : null,
        ),
      ),
    ),
  );

  _itemList(Size size) => Container(
    width: size.width * 0.95,
    height: size.height * 0.57,
    margin: EdgeInsets.only(top: size.height * 0.02),
    child: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) => _itemTile(size, index),
          ),
        ),
      ],
    ),
  );

  _itemTile(Size size, int index) => Dismissible(
    key: ValueKey(itemList[index].id),
    direction: DismissDirection.endToStart,
    background: Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      color: AppStyles.primaryWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Icon(Icons.delete, size: 30, color: AppStyles.alertColor)],
      ),
    ),
    onDismissed: (direction) => setState(() {
      itemList.removeAt(index);
      _revalidateForm();
    }),
    child: Container(
      decoration: BoxDecoration(
        color: itemList[index].isChecked
            ? AppStyles.secondaryColorLightDarker
            : Colors.transparent,
        borderRadius: AppStyles.tileBorderRadius(size),
      ),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: size.width * 0.05),
        title: Text(itemList[index].text, style: AppStyles.mainTextStyle),
        trailing: _checkBoxItemTile(index),
      ),
    ),
  );

  _checkBoxItemTile(int index) => Transform.scale(
    scale: 1.4,
    child: Checkbox(
      side: BorderSide(color: Colors.transparent),
      value: itemList[index].isChecked,
      onChanged: (value) {
        setState(() {
          itemList[index] = itemList[index].toggle();
        });
        _revalidateForm();
      },
      fillColor: WidgetStatePropertyAll(AppStyles.primaryWhite),
      activeColor: AppStyles.primaryWhite,
      checkColor: AppStyles.secondaryColorDark,
    ),
  );

  _addButton(Size size) => Container(
    width: size.width * 0.2,
    height: size.height * 0.05,
    decoration: BoxDecoration(
      color: _enabledAddButton
          ? AppStyles.secondaryColorDark
          : AppStyles.secondaryColorLightDarker,
      borderRadius: BorderRadius.circular(size.width * 0.08),
    ),
    child: IconButton(
      onPressed: () => _enabledAddButton ? _addItemToList(context) : null,
      icon: Icon(Icons.add, size: 28, color: AppStyles.primaryWhite),
    ),
  );

  _clearButtonTextField({
    required TextEditingController controller,
    required bool mustToEnableAddButton,
  }) => IconButton(
    onPressed: () => setState(() {
      controller.clear();
      if (mustToEnableAddButton) _enabledAddButton = false;
    }),
    icon: Icon(Icons.close, color: _darkColorListOrNote),
  );

  _typeOfSubmit() => widget.mode == EntryFormModeEntity.edit
      ? _updateEntry()
      : (isList ? _createEntryList() : _createEntryNote());

  _createEntryList() {
    context.read<EntryBloc>().add(
      CreateListEntryEvent(
        title: _titleController.text.trim(),
        categoryId: AppStyles.listText,
        items: itemList,
      ),
    );
    Navigator.pop(context);
  }

  _createEntryNote() {
    context.read<EntryBloc>().add(
      CreateReminderEntryEvent(
        title: _titleController.text.trim(),
        categoryId: AppStyles.noteText,
        body: _textAreaController.text.trim(),
        scheduledAt: _selectedDate,
      ),
    );
    Navigator.pop(context);
  }

  _updateEntry() {
    if (entry == null) return;

    final updatedEntry = isList
        ? ListEntryEntity(
            id: entry!.id,
            categoryId: entry!.categoryId,
            title: _titleController.text.trim(),
            priority: entry!.priority,
            createdAt: entry!.createdAt,
            items: List.from(itemList),
          )
        : ReminderEntryEntity(
            id: entry!.id,
            categoryId: entry!.categoryId,
            title: _titleController.text.trim(),
            priority: entry!.priority,
            createdAt: entry!.createdAt,
            body: _textAreaController.text.trim(),
            scheduledAt: _selectedDate,
          );

    context.read<EntryBloc>().add(UpdateEntryEvent(updatedEntry));
    Navigator.pop(context);
  }

  _addItemToList(BuildContext context) {
    final text = _itemListController.text.trim();
    if (text.isEmpty) return;

    final uuid = Uuid();

    setState(() {
      itemList.add(ListItemEntity(id: uuid.v4(), text: text, isChecked: false));
      _itemListController.clear();
    });
    _enabledAddButton = false;
    _revalidateForm();
  }
}
