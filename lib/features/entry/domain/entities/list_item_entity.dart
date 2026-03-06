class ListItemEntity {
  final String id;
  final String text;
  final bool isChecked;

  const ListItemEntity({
    required this.id,
    required this.text,
    required this.isChecked,
  });

  ListItemEntity toggle() =>
      ListItemEntity(id: id, text: text, isChecked: !isChecked);

  // ListItemEntity copyWith({String? id, String? text, bool? isChecked}) {
  //   return ListItemEntity(
  //     id: id ?? this.id,
  //     text: text ?? this.text,
  //     isChecked: isChecked ?? this.isChecked,
  //   );
  // }
}
