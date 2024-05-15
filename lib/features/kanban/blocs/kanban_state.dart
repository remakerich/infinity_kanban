import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinity_kanban/core/models/async_state.dart';
import 'package:infinity_kanban/features/kanban/models/stage.dart';

part 'kanban_state.freezed.dart';

@freezed
class KanbanState with _$KanbanState {
  factory KanbanState({
    @Default([]) List<Stage> stages,
    @Default(AsyncData()) AsyncState loadingState,
  }) = _KanbanState;
}
