// 故事模型

import 'package:json_annotation/json_annotation.dart';
part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends Object {
  final String id;
  final String author;
  final String img;
  final String title;
  final String text;

  StoryModel(this.id, this.author, this.img, this.title, this.text);

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}