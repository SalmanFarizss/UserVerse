import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_events.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitialState()) {
    //sending otp
    on<PhoneSignIn>((event, emit) async {
      try {
        emit(AuthLoading());
        if (event.phoneNumber.length < 10) {
          return emit(AuthFailure(error: 'Enter a Valid Phone Number'));
        }
        await _verifyPhone(event.phoneNumber);
      } on FirebaseAuthException catch (error) {
        throw error.message!;
      } catch (e) {
        return emit(AuthFailure(error: e.toString()));
      }
    });
    //otp verification
    on<OtpVerification>((event, emit) async {
      try {
        emit(AuthLoading());
        PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: event.verificationId, smsCode: event.otp);
        final res=await _auth.signInWithCredential(credential);
        if(res.user==null){
          return emit(AuthFailure(error: 'Invalid OTP'));
        }
        return emit(AuthCompleted());
      } on FirebaseAuthException catch (error) {
        throw error.message!;
      } catch (e) {
        return emit(AuthFailure(error: e.toString()));
      }
    });
    on<EmitAuthReDo>((event, emit)=> emit(AuthReDo()));
    on<EmitAuthSuccess>((event, emit) => emit(AuthSuccess(
        phoneNo: event.phone, verificationId: event.verificationId)));
    on<EmitAuthFailure>((event, emit) => emit(AuthFailure(error: event.error)));
  }
  Future<void> _verifyPhone(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (error) {
        add(EmitAuthFailure(error.code));
      },
      codeSent: (verificationId, forceResendingToken) {
        add(EmitAuthSuccess(phone: phone, verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
