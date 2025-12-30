import 'package:bloc/bloc.dart';

class EnquiryState {
  final int? enquiryid;

  EnquiryState({this.enquiryid});

  EnquiryState copyWith({
    int? enquiryid,
  }) {
    return EnquiryState(
      enquiryid: enquiryid ?? this.enquiryid
    );
  }
}

class EnquiryCubit extends Cubit<EnquiryState> {
  EnquiryCubit(): super(EnquiryState(enquiryid: null));

  void setEnquiryid(int id) {
    emit(state.copyWith(enquiryid: id));
  }

  void clearEnquiryid() {
    emit(EnquiryState(enquiryid: null));
  }
}