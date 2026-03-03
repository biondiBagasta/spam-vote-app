import 'package:akane_vote/models/menu_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial(dataListState: []));

  void updateState(List<MenuData> dataList) {
    emit(MenuInitial(dataListState: dataList));
  }
}
