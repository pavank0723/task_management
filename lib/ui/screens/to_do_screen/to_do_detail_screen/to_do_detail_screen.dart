import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/model/model.dart';
import 'package:task_management/ui/screens/to_do_screen/to_do_detail_screen/to_do_detail_screen_bloc.dart';

class ToDoDetailScreen extends StatefulWidget {
  final ToDoModel? task;

  const ToDoDetailScreen({super.key, this.task});

  @override
  _ToDoDetailScreenState createState() => _ToDoDetailScreenState();
}

class _ToDoDetailScreenState extends State<ToDoDetailScreen> {
  late ToDoDetailScreenBloc _bloc;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  DateTime? _dueDate;
  String? _priority;
  final List<String> _priorityOptions = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    _bloc = BlocProvider.of<ToDoDetailScreenBloc>(context);
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = DateTime.parse(widget.task!.dueDate);
      _priority = _priorityOptions[widget.task!.priority];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dueDate = selectedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                ),
                child: Text(
                    _dueDate == null ? 'Select Date' : _dueDate.toString()),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _priority,
              hint: const Text('Priority'),
              items: _priorityOptions.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            BlocConsumer<ToDoDetailScreenBloc, ToDoDetailScreenState>(
              listener: (context, state) {
                if (state is SuccessToDoDetail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task saved successfully')));
                  Navigator.pop(context, true);
                } else if (state is ErrorToDoDetail) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is LoadingToDoDetail) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () => _saveTask(context),
                  child: const Text('Save Task'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask(BuildContext context) {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final dueDate = _dueDate;
    final priority = _priority;

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        dueDate != null &&
        priority != null) {
      final task = ToDoModel(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: title,
        description: description,
        dueDate: dueDate.toString(),
        priority: _priorityOptions.indexOf(priority),
        isCompleted: 0,
        isSync: 0,
        email: user!.email.toString(),
      );

      if (widget.task != null) {
        context.read<ToDoDetailScreenBloc>().add(UpdateToDoDetail(task));
      } else {
        context.read<ToDoDetailScreenBloc>().add(AddToDoDetail(task));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }
  }
}
