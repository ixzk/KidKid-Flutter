// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return StoryModel(
    json['id'] as String,
    json['author'] as String,
    json['img'] as String,
    json['title'] as String,
    json['text'] as String,
  );
}

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'img': instance.img,
      'title': instance.title,
      'text': instance.text,
    };
