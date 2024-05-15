import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_kanban/features/kanban/models/deal.dart';

part 'stage.freezed.dart';
part 'stage.g.dart';

@freezed
class Stage with _$Stage {
  factory Stage({
    @Default(0) int id,
    @Default('') String title,
    @Default([]) List<Deal> deals,
  }) = _Stage;

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
}
