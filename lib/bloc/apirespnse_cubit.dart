import 'package:flutter_bloc/flutter_bloc.dart';

class ApiresponseState {
  final Map<String, dynamic>? apiresponse;

  ApiresponseState({this.apiresponse});

  ApiresponseState copyWith({
    Map<String, dynamic>? apiresponse,
  }) {
    return ApiresponseState(
      apiresponse: apiresponse ?? this.apiresponse
    );
  }
}

class ApiresponseCubit extends Cubit<ApiresponseState>{
  ApiresponseCubit() : super(ApiresponseState(apiresponse: null));

  void setApiresponse(Map<String, dynamic> api) {
    emit(state.copyWith(apiresponse: api));
  }

  void clearApiresponse() {
    emit(ApiresponseState(apiresponse: null));
  }
}