import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageCubit extends Cubit<File?>{
  ImageCubit():super(null);
  Future<void> pickImage() async {
    var pickedFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      return emit(File(pickedFile.path));
    }
  }
}