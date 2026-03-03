part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState({
    required this.userData
  });

  final UserData userData;

  @override
  List<Object> get props => [
    userData
  ];
}

final class UserInitial extends UserState {

  final UserData userDataState;

  const UserInitial({
    required this.userDataState
  }) : super(userData: userDataState);
}
