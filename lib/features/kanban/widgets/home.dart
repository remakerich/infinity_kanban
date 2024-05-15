import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_kanban/core/models/async_state.dart';
import 'package:infinity_kanban/features/kanban/blocs/kanban_cubit.dart';
import 'package:infinity_kanban/features/kanban/models/deal.dart';
import 'package:infinity_kanban/features/kanban/models/stage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => KanbanCubit()..init(),
        ),
      ],
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            const _Title(),
            const Expanded(child: _Body()),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 30),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final loadingState = context.select<KanbanCubit, AsyncState>(
      (cubit) => cubit.state.loadingState,
    );

    return loadingState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: () => const _Kanban(),
      error: () => const Center(child: Text('Что-то пошло не так...')),
    );
  }
}

class _Kanban extends StatefulWidget {
  const _Kanban();

  @override
  State<_Kanban> createState() => _KanbanState();
}

class _KanbanState extends State<_Kanban> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final stages = context.select<KanbanCubit, List<Stage>>(
      (cubit) => cubit.state.stages,
    );

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDCDDE4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: RawScrollbar(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            thumbColor: const Color(0xFF1648D8),
            radius: const Radius.circular(4),
            thickness: 4,
            thumbVisibility: true,
            child: ListView.builder(
              shrinkWrap: false,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 4),
              scrollDirection: Axis.horizontal,
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];

                return DragTarget<Deal>(
                  onAcceptWithDetails: (details) {
                    context.read<KanbanCubit>().moveDeal(details.data, stage);
                  },
                  builder: (context, candidateItems, rejectedData) {
                    return Container(
                      decoration: BoxDecoration(
                        color: candidateItems.isNotEmpty ? const Color(0xFFE4F2FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          _StageTitle(stage),
                          Expanded(child: _StageDeals(stage)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard(this.deal);

  final Deal deal;

  @override
  Widget build(BuildContext context) {
    const subtitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF85878E),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deal.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            deal.date,
            style: subtitleStyle,
          ),
          const SizedBox(height: 12),
          Text(
            'Менеджер: ${deal.manager}',
            style: subtitleStyle,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Дела',
                style: subtitleStyle,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F2FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Запланировать',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1648D8),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _StageDeals extends StatelessWidget {
  const _StageDeals(this.stage);

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, bottom: 30),
      itemCount: stage.deals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final deal = stage.deals[index];

        return LongPressDraggable<Deal>(
          onDragStarted: HapticFeedback.mediumImpact,
          data: deal,
          feedback: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Material(
              color: Colors.transparent,
              child: _DealCard(deal),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _DealCard(deal),
          ),
          child: _DealCard(deal),
        );
      },
    );
  }
}

class _StageTitle extends StatelessWidget {
  const _StageTitle(this.stage);

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF009EDF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              stage.title,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            stage.deals.length.toString(),
            style: style.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text(
        'Сделки',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
