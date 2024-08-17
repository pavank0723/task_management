import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_management/model/model.dart';
import 'package:task_management/network/local/local.dart';
import 'package:task_management/repository/repository.dart';
import 'package:task_management/utils/util_helper_methods.dart';

part 'to_do_screen_event.dart';

part 'to_do_screen_state.dart';

class ToDoScreenBloc extends Bloc<ToDoScreenEvent, ToDoScreenState> {
  final ToDoRepository _toDoRepository;
  final LocalDBHelper _localDBHelper;

  ToDoScreenBloc(this._toDoRepository, this._localDBHelper)
      : super(LoadingToDo()) {
    on<LoadToDos>(_onLoadTasks);

    on<ToggleToDoCompletion>(_onToggleToDoCompletion);
    on<DeleteToDo>(_onDeleteToDo);
  }

  Future<void> _onLoadTasks(
      LoadToDos event, Emitter<ToDoScreenState> emit) async {
    emit(LoadingToDo());

    try {
      final localTasks = await _localDBHelper.getToDo();

      if (localTasks.isNotEmpty) {
        emit(LoadedToDo(localTasks));
      } else {
        bool isConnected = await UtilHelperMethods.isConnectedToInternet();
        if (isConnected) {
          Stream<List<ToDoModel>> firestoreStream = _toDoRepository.getToDo();

          await for (final tasks in firestoreStream) {
            for (var task in tasks) {
              await _localDBHelper.insertToDo(task);
            }
            emit(LoadedToDo(tasks));
          }
        } else {
          emit(ErrorToDo('No internet connection and no local data available'));
        }
      }
    } catch (e) {
      emit(ErrorToDo('Failed to load tasks: ${e.toString()}'));
    }
  }

  Future<void> _onToggleToDoCompletion(
      ToggleToDoCompletion event, Emitter<ToDoScreenState> emit) async {
    try {
      bool isConnected = await UtilHelperMethods.isConnectedToInternet();
      if (isConnected) {
        await _toDoRepository.toggleToDoCompletion(event.toDoId);
      }
      await _localDBHelper.toggleToDoCompletion(event.toDoId);
      emit(SuccessfullyCompletedToDoDetail());
    } catch (e) {
      emit(ErrorToDo(e.toString()));
    }
  }

  Future<void> _onDeleteToDo(
      DeleteToDo event, Emitter<ToDoScreenState> emit) async {
    try {
      bool isConnected = await UtilHelperMethods.isConnectedToInternet();
      if (isConnected) {
        await _toDoRepository.deleteToDo(event.toDoId);
      }
      await _localDBHelper.deleteToDo(event.toDoId);
      emit(SuccessfullyDeletedToDoDetail());
    } catch (e) {
      emit(ErrorToDo(e.toString()));
    }
  }
}
