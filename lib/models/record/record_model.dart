// 音频模型

import 'package:json_annotation/json_annotation.dart';
part 'record_model.g.dart';

@JsonSerializable()
class RecordModel extends Object {
  final String id;
  final String user_id;
  final String story_id;
  final String recording;
  final String title;

  RecordModel(this.id, this.user_id, this.story_id, this.recording, this.title);

  factory RecordModel.fromJson(Map<String, dynamic> json) => _$RecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecordModelToJson(this);
}