import 'package:infinity_kanban/core/models/either.dart';
import 'package:infinity_kanban/core/models/failure.dart';
import 'package:infinity_kanban/features/kanban/data/mock.dart';
import 'package:infinity_kanban/features/kanban/models/stage.dart';

class Repository {
  Future<Either<Failure, List<Stage>>> getStages() async {
    return handleExceptions(
      () async {
        await Future.delayed(const Duration(seconds: 1));
        final response = mockData['stages'] as List;
        final parsedData = response.map((e) => Stage.fromJson(e)).toList();
        return parsedData;
      },
    );
  }
}
