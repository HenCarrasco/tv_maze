// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeopleModel _$PeopleModelFromJson(Map<String, dynamic> json) {
  return PeopleModel(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as Map<String, dynamic>,
    shows: (json['shows'] as List)
        ?.map((e) =>
            e == null ? null : ShowModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PeopleModelToJson(PeopleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'shows': instance.shows,
    };
