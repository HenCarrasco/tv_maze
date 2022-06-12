// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowModel _$ShowModelFromJson(Map<String, dynamic> json) {
  return ShowModel(
    id: json['id'] as int,
    name: json['name'] as String,
    genres: (json['genres'] as List)?.map((e) => e as String)?.toList(),
    image: json['image'] as Map<String, dynamic>,
    runtime: json['runtime'] as int,
    schedule: json['schedule'] as Map<String, dynamic>,
    averageRuntime: json['averageRuntime'] as int,
    summary: json['summary'] as String,
  );
}

Map<String, dynamic> _$ShowModelToJson(ShowModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'genres': instance.genres,
      'runtime': instance.runtime,
      'averageRuntime': instance.averageRuntime,
      'schedule': instance.schedule,
      'image': instance.image,
      'summary': instance.summary,
    };
