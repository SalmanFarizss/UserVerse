import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_verse/core/globals.dart';
import 'package:user_verse/core/utils.dart';
import 'package:user_verse/features/auth/screens/otp_screen.dart';
import '../../../core/constants/conatants.dart';
import '../../../core/theme/palette.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          failureSnackBar(context, state.error);
        }
        if (state is AuthSuccess) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => OtpScreen(
                  verificationId: state.verificationId,
                  phoneNumber: state.phoneNo,
                ),
              ));
        }
      },
      builder: (context1, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                SizedBox(
                  height: height * 0.18,
                  width: width,
                  child: Image.asset(Constants.loginImage),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Text(
                  'Enter Phone Number',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: RichText(
                          text:  TextSpan(
                              text: 'Enter Phone Number ',
                              style: TextStyle(
                                  fontSize: width * 0.035,
                                  color:  Palette.greyColor,),
                              children: [
                                TextSpan(
                                    text: '*', style: TextStyle(fontSize:width * 0.035,color: Palette.redColor))
                              ]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Palette.greyColor.shade100))),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "By Continuing, I agree to TotalX's",
                        style: TextStyle(
                            fontSize: width * 0.035,
                            color: Palette.greyColor.shade600)),
                    TextSpan(
                        text: ' Terms and conditions',
                        style: TextStyle(
                            fontSize: width * 0.035, color: Palette.blueColor),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                        text: '& ',
                        style: TextStyle(
                            fontSize: width * 0.035,
                            color: Palette.greyColor.shade600)),
                    TextSpan(
                        text: 'privacy policy',
                        style: TextStyle(
                            fontSize: width * 0.035, color: Palette.blueColor),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                  ]),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    context
                        .read<AuthBloc>()
                        .add(PhoneSignIn(phoneNumber: phoneController.text));
                  },
                  child: Container(
                    height: height * 0.06,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 0.25),
                        color: Palette.blackColor),
                    child: Center(
                        child: Text(
                      'Get OTP',
                      style: TextStyle(
                          fontSize: width * 0.05, color: Palette.whiteColor),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
