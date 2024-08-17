class ToDoModel {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final int priority;
  final int isCompleted;
  final int isSync;
  final String email; // Add email field

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.isSync,
    required this.email,
  });

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dueDate: json['dueDate'],
    priority: json['priority'],
    isCompleted: json['isCompleted'],
    isSync: json['isSync'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate,
    'priority': priority,
    'isCompleted': isCompleted,
    'isSync': isSync,
    'email': email,
  };

  ToDoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    int? priority,
    int? isCompleted,
    int? isSync,
    String? email,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSync: isSync ?? this.isSync,
      email: email ?? this.email,
    );
  }
}
