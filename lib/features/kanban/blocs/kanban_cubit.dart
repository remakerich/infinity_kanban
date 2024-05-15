import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_kanban/core/models/async_state.dart';
import 'package:infinity_kanban/features/kanban/blocs/kanban_state.dart';
import 'package:infinity_kanban/features/kanban/data/repository.dart';
import 'package:infinity_kanban/features/kanban/models/deal.dart';
import 'package:infinity_kanban/features/kanban/models/stage.dart';

class KanbanCubit extends Cubit<KanbanState> {
  KanbanCubit() : super(KanbanState());

  final repository = Repository();

  init() async {
    emit(state.copyWith(loadingState: const AsyncLoading()));

    final result = await repository.getStages();

    result.when(
      left: (failure) {
        emit(state.copyWith(loadingState: const AsyncError()));
      },
      right: (data) {
        emit(state.copyWith(loadingState: const AsyncData(), stages: data));
      },
    );
  }

  moveDeal(Deal deal, Stage toStage) {
    final fromStage = state.stages.firstWhere((stage) => stage.deals.map((e) => e.id).contains(deal.id));

    if (fromStage == toStage) {
      return;
    }

    final updatedStages = state.stages.toList();
    final fromStageIndex = state.stages.indexOf(fromStage);
    final fromStageDeals = fromStage.deals.toList();
    fromStageDeals.remove(deal);
    final updatedFromStage = fromStage.copyWith(deals: fromStageDeals);
    updatedStages[fromStageIndex] = updatedFromStage;

    final toStageIndex = state.stages.indexOf(toStage);
    final toStageDeals = toStage.deals.toList();
    toStageDeals.add(deal);
    final updatedToStage = toStage.copyWith(deals: toStageDeals);
    updatedStages[toStageIndex] = updatedToStage;

    emit(state.copyWith(stages: updatedStages));
  }
}
