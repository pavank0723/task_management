import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/route/route.dart';
import 'package:task_management/ui/screens/to_do_screen/all_to_do/to_do_screen_bloc.dart';
import 'package:task_management/utils/utils.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late ToDoScreenBloc _bloc;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    _bloc = BlocProvider.of<ToDoScreenBloc>(context);
    _bloc.add(LoadToDos()); // Add this line
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
            },
          ),
        ],
      ),
      body: BlocConsumer<ToDoScreenBloc, ToDoScreenState>(
        listener: (context, state) {
          if (state is SuccessfullyCompletedToDoDetail) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Task completely')));
          }
          if (state is SuccessfullyDeletedToDoDetail) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Task deleted')));
          }
        },
        builder: (context, state) {
          if (state is LoadingToDo) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ErrorToDo) {
            return Center(child: Text(state.message));
          } else if (state is LoadedToDo) {
            final toDos = state.toDos;
            if (toDos.isEmpty) {
              return Center(child: Text('No to-dos available.'));
            }
            return ListView.builder(
              itemCount: toDos.length,
              itemBuilder: (context, index) {
                final toDo = toDos[index];
                return ListTile(
                  title: Text(
                    toDo.title,
                    style: TextStyle(
                      decoration: toDo.isCompleted == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(toDo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          toDo.isCompleted == 1
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: toDo.isCompleted == 1
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          // Toggle completion status
                          _bloc.add(ToggleToDoCompletion(toDo.id));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Confirm deletion
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                    _bloc.add(DeleteToDo(toDo.id));
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  leading: Icon(
                    toDo.priority == 1
                        ? Icons.priority_high
                        : Icons.low_priority,
                    color: toDo.priority == 1 ? Colors.red : Colors.green,
                  ),
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context, AppRoute.addToDoScreen,
                        arguments: toDo);
                    if (result == true) {
                      _bloc.add(LoadToDos()); // Reload the to-do list
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No to-dos found.',
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, AppRoute.addToDoScreen);
          if (result == true) {
            _bloc.add(LoadToDos()); // Reload the to-do list
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
