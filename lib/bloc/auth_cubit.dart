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
  AuthCubit() : super(AuthState());

  void setToken(String? token) {
    if (token == null || token.isEmpty) {
      emit(AuthState(token: null, isAuthenticated: false));
    } else {
      emit(AuthState(token: token, isAuthenticated: true));
    }
  }

  void cleartoken() {
    emit(AuthState(token: null, isAuthenticated: false));
  }
}
