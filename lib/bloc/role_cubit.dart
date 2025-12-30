import 'package:bloc/bloc.dart';

class RoleState {
  final String? role;

  RoleState({this.role});

  RoleState copyWith({
    String? role,
  }) {
    return RoleState(
      role: role ?? this.role
    );
  }
}

class RoleCubit extends Cubit<RoleState> {
  RoleCubit(): super(RoleState(role: null));

  void setrole(String role) {
    emit(state.copyWith(role: role));
  }

  void clearrole() {
    emit(RoleState(role: null));
  }
}