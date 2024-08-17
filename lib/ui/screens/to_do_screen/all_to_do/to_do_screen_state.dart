part of 'to_do_screen_bloc.dart';

@immutable
sealed class ToDoScreenState {}

final class ToDoScreenInitial extends ToDoScreenState {}

class LoadingToDo extends ToDoScreenState {}

class LoadedToDo extends ToDoScreenState {
  final List<ToDoModel> toDos;

  LoadedToDo(this.toDos);
}

class SuccessfullyCompletedToDoDetail extends ToDoScreenState {}

class SuccessfullyDeletedToDoDetail extends ToDoScreenState {}

class ErrorToDo extends ToDoScreenState {
  final String message;

  ErrorToDo(this.message);
}
