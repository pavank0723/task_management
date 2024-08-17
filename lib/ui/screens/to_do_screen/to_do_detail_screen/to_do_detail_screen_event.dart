part of 'to_do_detail_screen_bloc.dart';

@immutable
sealed class ToDoDetailScreenEvent {}


class AddToDoDetail extends ToDoDetailScreenEvent {
  final ToDoModel toDo;

  AddToDoDetail(this.toDo);
}

class UpdateToDoDetail extends ToDoDetailScreenEvent {
  final ToDoModel toDo;

  UpdateToDoDetail(this.toDo);
}