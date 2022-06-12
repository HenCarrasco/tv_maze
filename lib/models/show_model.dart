import 'package:json_annotation/json_annotation.dart';
import 'episode_model.dart';
import 'package:collection/collection.dart';

part 'show_model.g.dart';

@JsonSerializable()
class ShowModel {
  int id;
  String name;
  List<String> genres;
  int runtime;
  int averageRuntime;
  Map<String, dynamic> schedule;
  Map<String, dynamic> image;
  String summary;

  @JsonKey(ignore: true, defaultValue: [])
  List<EpisodeModel> episodes;

  ShowModel(
      {this.id,
      this.name,
      this.episodes,
      this.genres,
      this.image,
      this.runtime,
      this.schedule,
      this.averageRuntime,
      this.summary});

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    ShowModel show = _$ShowModelFromJson(json);
    show.episodes =
        json['_embedded'] != null ? json['_embedded']['episodes'] : null;
    return show;
  }

  static List<ShowModel> fromJsonList(List list) {
    if (list == null) return null;
    return list
        .map((item) => item['show'] != null
            ? ShowModel.fromJson(item['show'])
            : item['_embedded'] != null && item['_embedded']['show'] != null
                ? ShowModel.fromJson(item['_embedded']['show'])
                : ShowModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() => _$ShowModelToJson(this);

  @override
  String toString() => '$id - $name';

  @override
  operator ==(o) => o is ShowModel && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  String getSchedule() {
    String scheduleStr;
    List days = schedule['days'];
    String time = schedule['time'];
    String runtime = this.runtime == null
        ? '${averageRuntime.toString()} min'
        : '${this.runtime.toString()} min';
    if (days.isEmpty && averageRuntime != null) {
      scheduleStr = runtime;
    } else if (days.isNotEmpty) {
      if (days.length > 1) {
        if (ListEquality().equals(
            days, ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])) {
          scheduleStr = 'Weekdays at $time ($runtime)';
        } else {
          String daysLst = "";
          days.forEach((day) {
            daysLst += '${day.substring(0, 2)}, ';
          });
          daysLst = daysLst.substring(0, daysLst.length - 2);
          scheduleStr = '$daysLst at $time ($runtime)';
        }
      } else {
        scheduleStr = '${days[0]} at $time ($runtime)';
      }
    }

    return scheduleStr;
  }

  String getGenres() {
    String genresStr = "";
    genres.forEach((genre) {
      genresStr += '$genre | ';
    });

    genresStr = genresStr.substring(0, genresStr.length - 3);

    return genresStr;
  }
}
