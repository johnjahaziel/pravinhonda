import 'package:bloc/bloc.dart';

class NumberState {
  final String? number;

  NumberState({this.number});

  NumberState copyWith({
    String? number,
  }) {
    return NumberState(
      number: number ?? this.number
    );
  }
}

class NumberCubit extends Cubit<NumberState> {
  NumberCubit(): super(NumberState(number: null));

  void setnumber(String number) {
    emit(state.copyWith(number: number));
  }

  void clearnumber() {
    emit(NumberState(number: null));
  }
}