// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) {
  return EpisodeModel(
    id: json['id'] as int,
    name: json['name'] as String,
    summary: json['summary'] as String,
    image: json['image'] as Map<String, dynamic>,
    number: json['number'] as int,
    season: json['season'] as int,
    runtime: json['runtime'] as int,
  );
}

Map<String, dynamic> _$EpisodeModelToJson(EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'season': instance.season,
      'summary': instance.summary,
      'image': instance.image,
      'runtime': instance.runtime,
    };
