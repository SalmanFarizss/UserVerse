part of 'auth_bloc.dart';

sealed class AuthEvents {}

final class PhoneSignIn extends AuthEvents {
  String phoneNumber;
  PhoneSignIn({required this.phoneNumber});
}
final class OtpVerification extends AuthEvents {
  final String verificationId;
  final String otp;
  OtpVerification({required this.verificationId,required this.otp});
}
final class EmitAuthSuccess extends AuthEvents {
  String phone;
  String verificationId;
  EmitAuthSuccess({required this.phone,required this.verificationId});
}
final class EmitAuthFailure extends AuthEvents {
  String error;
  EmitAuthFailure(this.error);
}
final class EmitAuthReDo extends AuthEvents {}
