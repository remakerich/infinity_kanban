import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

@freezed
class AsyncState with _$AsyncState {
  const AsyncState._();

  const factory AsyncState.loading() = AsyncLoading;
  const factory AsyncState.data() = AsyncData;
  const factory AsyncState.error() = AsyncError;
}
