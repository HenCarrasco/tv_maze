import 'package:json_annotation/json_annotation.dart';

part 'episode_model.g.dart';

@JsonSerializable()
class EpisodeModel {
  int id;
  String name;
  int number;
  int season;
  String summary;
  Map<String, dynamic> image;
  int runtime;

  EpisodeModel(
      {this.id,
      this.name,
      this.summary,
      this.image,
      this.number,
      this.season,
      this.runtime});

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  static List<EpisodeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => EpisodeModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);

  @override
  String toString() => name;

  @override
  operator ==(o) => o is EpisodeModel && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
