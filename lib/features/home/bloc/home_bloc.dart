import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/core/constants/firebase_constants.dart';
import 'package:user_verse/core/globals.dart';
import 'package:user_verse/core/utils.dart';
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
    //add new user
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
        if (url == null) {
          return emit(HomeFailure(error: 'Image Upload Error'));
        }
        DocumentReference userDoc=_users.doc();
        UserModel user = UserModel(
          uid: userDoc.id,
            name: event.name,
            profile: url,
            phone: event.phone,
            age: event.age,
            searchKeys: setSearchParam('${event.name} ${event.phone}'));
        await userDoc.set(user.toMap());
        emit(HomeSuccess());
      } catch (error) {
        emit(HomeFailure(error: error.toString()));
      }
    });
    //fetchData
    on<GetInitialUsers>((event, emit) async {
      try {
        emit(HomeLoading());
        _users.where('searchKeys',arrayContains:event.search.isEmpty?null:event.search).orderBy('age', descending: event.radioValue == 1)
            .where('age', isLessThan: event.radioValue == 2 ? 60 : null)
            .where('age', isGreaterThan: event.radioValue == 1 ? 60 : null).limit(limit).snapshots().listen((value) {
          List<UserModel> users = value.docs
              .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          add(EmitFetchingComplete(users: users,lastDoc: value.docs.isEmpty?null:value.docs.last));
        });
      } catch (e) {
        emit(HomeFailure(error: e.toString()));
      }
    });
    on<GetMoreUsers>((event, emit) async {
      try {
        emit(HomeLoading());
        _users.where('searchKeys',arrayContains:event.search.isEmpty?null:event.search).orderBy('age', descending: event.radioValue == 1)
            .where('age', isLessThan: event.radioValue == 2 ? 60 : null)
            .where('age', isGreaterThan: event.radioValue == 1 ? 60 : null).startAfterDocument(event.lastDoc).limit(limit).snapshots().listen((value) {
          List<UserModel> users = value.docs
              .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          add(EmitFetchingComplete(users: users,lastDoc:value.docs.isEmpty?null:value.docs.last));
        });
      } catch (e) {
        emit(HomeFailure(error: e.toString()));
      }
    });
    on<EmitFetchingComplete>((event, emit) {
      emit(FetchingCompleted(users: event.users,lastDoc: event.lastDoc));
    });
  }
  Future<String?> uploadImage(File file) async {
    try {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      final uploadSnap = await _storage
          .ref()
          .child('images/profiles/${DateTime.now()}')
          .putData(file.readAsBytesSync(), metadata);
      return uploadSnap.ref.getDownloadURL();
    } catch (e) {
      print('image upload error:${e.toString()}..................');
      return null;
    }
  }
}
