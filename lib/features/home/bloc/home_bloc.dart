import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/core/constants/firebase_constants.dart';
import 'package:user_verse/features/home/bloc/home_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:user_verse/models/user_model.dart';
part 'home_events.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  HomeBloc() : super(HomeInitialState()) {
    on<AddUser>((event, emit) async {
      try {
        emit(HomeLoading());
        if (event.profileImage == null) {
          return emit(HomeFailure(error: 'Please Select Image'));
        }
        if (event.name == '') {
          return emit(HomeFailure(error: 'Please Enter Name'));
        }
        if (event.phone.length != 10) {
          return emit(HomeFailure(error: 'Please Enter Valid Phone number'));
        }
        String? url = await uploadImage(event.profileImage!);
        if(url==null){
          return emit(HomeFailure(error: 'Image Upload Error'));
        }
        UserModel user = UserModel(
            name: event.name,
            profile: url,
            phone: event.phone,
            age: event.age,
            searchKeys: []);
        await _users.add(user.toMap());
        emit(HomeSuccess());
      } catch (error) {
        emit(HomeFailure(error: error.toString()));
      }
    });
  }
  Future<String?> uploadImage(File file) async {
    try{
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      final uploadSnap = await _storage
          .ref()
          .child('images/profiles/${DateTime.now()}')
          .putData(file.readAsBytesSync(), metadata);
      return uploadSnap.ref.getDownloadURL();
    }catch(e){
      print('image upload error:${e.toString()}..................');
      return null;
    }
  }

  final StreamController<List<UserModel>> _userController =
      StreamController<List<UserModel>>();

  Stream<List<UserModel>> get usersStream => _userController.stream;

  void fetchUsers() {
    _users.snapshots().listen((snapshot) {
      final List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      _userController.add(users);
    });
  }

  void dispose() {
    _userController.close();
  }
}
