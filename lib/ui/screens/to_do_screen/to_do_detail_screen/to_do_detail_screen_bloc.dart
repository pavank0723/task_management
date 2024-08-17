import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_management/model/model.dart';
import 'package:task_management/network/local/local.dart';
import 'package:task_management/repository/repository.dart';
import 'package:task_management/utils/utils.dart';

part 'to_do_detail_screen_event.dart';

part 'to_do_detail_screen_state.dart';

class ToDoDetailScreenBloc
    extends Bloc<ToDoDetailScreenEvent, ToDoDetailScreenState> {
  final ToDoRepository _toDoRepository;
  final LocalDBHelper _localDBHelper;

  ToDoDetailScreenBloc(this._toDoRepository, this._localDBHelper)
      : super(ToDoDetailScreenInitial()) {
    on<AddToDoDetail>(_onAddToDoDetail);
    on<UpdateToDoDetail>(_onUpdateToDoDetail);
  }

  Future<void> _onAddToDoDetail(
      AddToDoDetail event, Emitter<ToDoDetailScreenState> emit) async {
    try {
      bool isConnected = await UtilHelperMethods.isConnectedToInternet();
      if (isConnected) {
        await _toDoRepository.addToDo(event.toDo);
      }
      await _localDBHelper.insertToDo(event.toDo);
      emit(SuccessToDoDetail());
    } catch (e) {
      emit(ErrorToDoDetail('Failed to add to do'));
    }
  }

  Future<void> _onUpdateToDoDetail(
      UpdateToDoDetail event, Emitter<ToDoDetailScreenState> emit) async {
    try {
      bool isConnected = await UtilHelperMethods.isConnectedToInternet();
      if (isConnected) {
        await _toDoRepository.updateToDo(event.toDo);
      }
      await _localDBHelper.updateToDo(event.toDo);
      emit(SuccessToDoDetail());
    } catch (e) {
      emit(ErrorToDoDetail('Failed to update task'));
    }
  }
}
