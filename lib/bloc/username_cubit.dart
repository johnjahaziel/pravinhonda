import 'package:bloc/bloc.dart';

class UsernameState {
  final String? username;

  UsernameState({this.username});

  UsernameState copyWith({
    String? username,
  }) {
    return UsernameState(
      username: username ?? this.username
    );
  }
}

class UsernameCubit extends Cubit<UsernameState> {
  UsernameCubit(): super(UsernameState(username: null));

  void setusername(String username) {
    emit(state.copyWith(username: username));
  }

  void clearusername() {
    emit(UsernameState(username: null));
  }
}