import 'package:notas_equipo_app/features/entry/domain/entities/list_item_entity.dart';

class ListItemModel {
  final String id;
  final String text;
  final bool isChecked;

  ListItemModel({
    required this.id,
    required this.text,
    required this.isChecked,
  });

  ListItemEntity toEntity() =>
      ListItemEntity(id: id, text: text, isChecked: isChecked);

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'is_checked': isChecked,
  };

  factory ListItemModel.fromJson(Map<String, dynamic> json) => ListItemModel(
    id: json['id'],
    text: json['text'],
    isChecked: json['is_checked'],
  );

  factory ListItemModel.fromEntity(ListItemEntity entity) => ListItemModel(
    id: entity.id,
    text: entity.text,
    isChecked: entity.isChecked,
  );
}
