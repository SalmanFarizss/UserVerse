sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthFailure extends AuthState {
  String error;
  AuthFailure({required this.error});
}

final class AuthSuccess extends AuthState {
  String phoneNo;
  String verificationId;
  AuthSuccess({required this.phoneNo, required this.verificationId});
}

final class AuthLoading extends AuthState {}

final class AuthCompleted extends AuthState {}

final class AuthReDo extends AuthState {}
