part of 'to_do_detail_screen_bloc.dart';

@immutable
sealed class ToDoDetailScreenState {}

final class ToDoDetailScreenInitial extends ToDoDetailScreenState {}

class LoadingToDoDetail extends ToDoDetailScreenState {}

class SuccessToDoDetail extends ToDoDetailScreenState {}

class ErrorToDoDetail extends ToDoDetailScreenState {
  final String message;

  ErrorToDoDetail(this.message);
}
