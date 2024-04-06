import '../../../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

sealed class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeFailure extends HomeState {
  String error;
  HomeFailure({required this.error});
}

final class HomeSuccess extends HomeState {}

final class FetchingCompleted extends HomeState {
  List<UserModel> users;
  DocumentSnapshot lastDoc;
  FetchingCompleted({required this.users,required this.lastDoc});
}

final class HomeLoading extends HomeState {}
