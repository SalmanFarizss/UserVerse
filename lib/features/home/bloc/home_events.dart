
part of 'home_bloc.dart';

sealed class HomeEvents {}

final class AddUser extends HomeEvents {
  String name;
  String phone;
  int age;
  File? profileImage;
  AddUser(
      {required this.name,
      required this.phone,
      required this.age,
      required this.profileImage});
}
final class GetInitialUsers extends HomeEvents{
  String search;
  int radioValue;
  GetInitialUsers({required this.search,required this.radioValue});
}
final class GetMoreUsers extends HomeEvents{
  String search;
  int radioValue;
  DocumentSnapshot lastDoc;
  GetMoreUsers({required this.search,required this.radioValue,required this.lastDoc});
}

final class EmitFetchingComplete extends HomeEvents{
 List<UserModel> users;
 DocumentSnapshot lastDoc;
 EmitFetchingComplete({required this.users,required this.lastDoc});
}

final class UploadImage extends HomeEvents {
  File image;
  UploadImage({required this.image});
}
