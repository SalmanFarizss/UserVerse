import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/core/constants/conatants.dart';
import 'package:user_verse/core/globals.dart';
import 'package:user_verse/core/utils.dart';
import 'package:user_verse/features/home/bloc/home_bloc.dart';
import 'package:user_verse/features/home/bloc/home_state.dart';
import 'package:user_verse/features/home/bloc/image_cubit.dart';
import 'package:user_verse/features/home/screens/home_screen.dart';

import '../../../core/theme/palette.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final imageCubit=ImageCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor,
      ),
      backgroundColor: Palette.blackColor,
      body: BlocConsumer<HomeBloc,HomeState>(listener: (context, state) {
        if(state is HomeFailure){
          failureSnackBar(context, state.error);
        }
        if(state is HomeSuccess){
          successSnackBar(context, 'User Added...');
          Navigator.pushAndRemoveUntil(context,CupertinoPageRoute(builder: (context) => HomeScreen(),),(route) => false,);
        }
      },
        builder: (context, state) {
          if(state is HomeLoading){
            return const Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.1),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.05),
                      color: Palette.whiteColor),
                  height: height * 0.62,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.03),
                    child: BlocBuilder<ImageCubit,File?>(
                      bloc: imageCubit,
                      builder: (context,image) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add A New User',
                              style: TextStyle(
                                  fontSize: width * 0.05, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            SizedBox(
                              height: height * 0.12,
                              width: width,
                              child: InkWell(
                                  onTap: () {
                                    imageCubit.pickImage();
                                  },
                                  child:image==null?
                                  Image.asset(Constants.defaultAvatar):CircleAvatar(radius:width*0.2,backgroundImage:FileImage(image,))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '  Name',
                              style: TextStyle(
                                  color: Palette.greyColor, fontSize: width * 0.035),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: height * 0.06,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: TextStyle(
                                        fontSize: width * 0.04, color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                        BorderSide(color:Palette.greyColor.shade100))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '  Age',
                              style: TextStyle(
                                  color: Palette.greyColor, fontSize: width * 0.035),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: height * 0.06,
                              child: TextFormField(
                                inputFormatters: [LengthLimitingTextInputFormatter(3)],
                                controller: ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Age',
                                    hintStyle: TextStyle(
                                        fontSize: width * 0.04, color:Palette.blackColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                        BorderSide(color: Palette.greyColor.shade100))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '  Phone',
                              style: TextStyle(
                                  color: Palette.greyColor, fontSize: width * 0.038),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: height * 0.06,
                              child: TextFormField(
                                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: 'Phone',
                                    hintStyle: TextStyle(
                                        fontSize: width * 0.04, color: Palette.blackColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                        BorderSide(color: Palette.greyColor.shade100))),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Palette.greyColor.shade300),
                                    height: height * 0.042,
                                    width: width * 0.28,
                                    child: const Center(
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    context.read<HomeBloc>().add(AddUser(
                                      phone: phoneController.text.trim(),
                                      name: nameController.text.trim(),
                                      age: int.tryParse(ageController.text.trim()) ?? 0,
                                      profileImage: image,
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Palette.greyColor),
                                    height: height * 0.042,
                                    width: width * 0.28,
                                    child: const Center(
                                      child: Text('Save'),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
