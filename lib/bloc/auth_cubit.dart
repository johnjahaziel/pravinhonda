import 'package:bloc/bloc.dart';

class AuthState {
  final String? token;
  final bool isAuthenticated;

  AuthState({
    this.token,
    this.isAuthenticated = false
  });

  AuthState copyWith({
    String? token,
    bool? isAuthenticated,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(): super(AuthState());

  void setToken(String token) => emit(state.copyWith(token: token, isAuthenticated: true));
  void cleartoken() => emit(AuthState(token: null, isAuthenticated: false));

}