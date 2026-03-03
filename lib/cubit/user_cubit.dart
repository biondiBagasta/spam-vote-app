import 'package:akane_vote/models/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial(userDataState: UserData(username: "")));

  void updateState(UserData userData) {
    emit(UserInitial(userDataState: userData));
  }
}
