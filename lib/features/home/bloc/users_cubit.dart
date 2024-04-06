import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/models/user_model.dart';

class UsersCubit extends Cubit<List<UserModel>>{
  UsersCubit():super([]);
  void newUserBatch(List<UserModel> newUsers){
    return emit(newUsers);
  }
}