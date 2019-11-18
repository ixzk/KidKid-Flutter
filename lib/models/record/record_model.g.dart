// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) {
  return RecordModel(
    json['id'] as String,
    json['user_id'] as String,
    json['story_id'] as String,
    json['recording'] as String,
    json['title'] as String,
  );
}

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'story_id': instance.story_id,
      'recording': instance.recording,
      'title': instance.title,
    };
