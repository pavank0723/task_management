part of 'to_do_screen_bloc.dart';

@immutable
sealed class ToDoScreenEvent {}

class LoadToDos extends ToDoScreenEvent {}

class ToggleToDoCompletion extends ToDoScreenEvent {
  final String toDoId;

  ToggleToDoCompletion(this.toDoId);
}


class DeleteToDo extends ToDoScreenEvent {
  final String toDoId;

  DeleteToDo(this.toDoId);
}
