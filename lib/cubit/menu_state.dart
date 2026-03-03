part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState({ required this.dataList });

  final List<MenuData> dataList;

  @override
  List<Object> get props => [
    dataList
  ];
}

final class MenuInitial extends MenuState {

  final List<MenuData> dataListState;

  const MenuInitial({
    required this.dataListState
  }) : super(dataList: dataListState);
}
