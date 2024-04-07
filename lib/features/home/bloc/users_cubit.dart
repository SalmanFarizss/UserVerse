import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/models/user_model.dart';

class UsersCubit extends Cubit<List<UserModel>>{
  UsersCubit():super([]);
  void newUserBatch(List<UserModel> newUsers){
    // List<UserModel> ul=state;
    // for (UserModel doc in newUsers) {
    //   // Check if the document ID is already in the list
    //   if (!state.any((d) => d.uid == doc.uid)) {
    //     ul.add(doc);
    //   }
    // }
    return emit([...state,...newUsers]);
  }
  void clearState(){
    state.clear();
  }
}