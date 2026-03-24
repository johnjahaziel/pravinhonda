import 'package:bloc/bloc.dart';

class EnquiryState {
  final String? enquiryid;

  EnquiryState({this.enquiryid});

  EnquiryState copyWith({
    String? enquiryid,
  }) {
    return EnquiryState(
      enquiryid: enquiryid ?? this.enquiryid
    );
  }
}

class EnquiryCubit extends Cubit<EnquiryState> {
  EnquiryCubit(): super(EnquiryState(enquiryid: null));

  void setEnquiryid(String id) {
    emit(state.copyWith(enquiryid: id));
  }

  void clearEnquiryid() {
    emit(EnquiryState(enquiryid: null));
  }
}