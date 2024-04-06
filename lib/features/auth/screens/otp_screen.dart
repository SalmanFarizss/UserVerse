import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:user_verse/bloc/auth_bloc.dart';
import 'package:user_verse/bloc/auth_state.dart';
import 'package:user_verse/features/auth/screens/login_screen.dart';
import 'package:user_verse/features/home/home_screen.dart';
import '../../../core/globals.dart';
import '../../../core/utils.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OtpScreen({super.key,required this.phoneNumber,required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            failureSnackBar(context, state.error);
          }
          if (state is AuthCompleted) {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          }
          if (state is AuthReDo) {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                    child: Image.asset('assets/images/otp_image.png'),
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                        fontSize: width * 0.045, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: height * 0.035,
                  ),
                  Text(
                    'Enter the verification code we just sent to your number +91 ********${widget.phoneNumber.substring(8, 10)}',
                    style: TextStyle(
                        fontSize: width * 0.04, color: Colors.grey.shade600),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Pinput(
                        cursor: Container(),
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        length: 6,
                        defaultPinTheme: PinTheme(
                            height: width * 0.13,
                            width: width * 0.13,
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 1))),
                        submittedPinTheme: PinTheme(
                            height: width * 0.13,
                            width: width * 0.13,
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1))
                        ),
                        errorPinTheme: PinTheme(
                            height: width * 0.13,
                            width: width * 0.13,
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: Colors.red.shade400, width: 1))
                        ),
                        validator: (value) {
                          if(value!.trim().length!=6){
                            return 'Please Enter Valid Pin';
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Get OTP?",
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(EmitAuthReDo());
                          },
                          child: Text(
                            'Resend',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.035),
                          ))
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      if(_formKey.currentState!.validate()){
                        context.read<AuthBloc>().add(OtpVerification(verificationId: widget.verificationId,otp: otpController.text.trim()));
                      }
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.25),
                          color: Colors.black),
                      child: Center(
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: width * 0.04, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
