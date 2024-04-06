sealed class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeFailure extends HomeState {
  String error;
  HomeFailure({required this.error});
}

final class HomeSuccess extends HomeState {}

final class HomeLoading extends HomeState {}
