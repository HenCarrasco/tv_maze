import 'package:json_annotation/json_annotation.dart';
import 'package:tv_maze/models/show_model.dart';

part 'people_model.g.dart';

@JsonSerializable()
class PeopleModel {
  int id;
  String name;
  Map<String, dynamic> image;
  List<ShowModel> shows;

  PeopleModel({this.id, this.name, this.image, this.shows});

  factory PeopleModel.fromJson(Map<String, dynamic> json) =>
      _$PeopleModelFromJson(json);

  static List<PeopleModel> fromJsonList(List list) {
    if (list == null) return null;
    return list
        .map((item) => item['person'] != null
            ? PeopleModel.fromJson(item['person'])
            : PeopleModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() => _$PeopleModelToJson(this);

  @override
  String toString() => name;

  @override
  operator ==(o) => o is PeopleModel && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
