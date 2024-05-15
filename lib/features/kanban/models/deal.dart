import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal.freezed.dart';
part 'deal.g.dart';

@freezed
class Deal with _$Deal {
  factory Deal({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String date,
    @Default('') String manager,
  }) = _Deal;

  factory Deal.fromJson(Map<String, dynamic> json) => _$DealFromJson(json);
}
