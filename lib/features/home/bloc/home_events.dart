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
final class GetUsers extends HomeEvents{}
final class UploadImage extends HomeEvents {
  File image;
  UploadImage({required this.image});
}
