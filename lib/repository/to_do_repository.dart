import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management/model/model.dart';

class ToDoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToDo(ToDoModel task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc =
          _firestore.collection('todos').doc(user.email);

      await userDoc.set({'exists': true}, SetOptions(merge: true));

      await userDoc.collection('tasks').doc(task.id).set(task.toJson());
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<void> updateToDo(ToDoModel task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc =
          _firestore.collection('todos').doc(user.email);

      // Ensure the collection and document structure exists
      await userDoc.set({'exists': true}, SetOptions(merge: true));

      await userDoc.collection('tasks').doc(task.id).update(task.toJson());
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<void> toggleToDoCompletion(String toDoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference taskDoc = _firestore
          .collection('todos')
          .doc(user.email)
          .collection('tasks')
          .doc(toDoId);

      DocumentSnapshot docSnapshot = await taskDoc.get();
      if (docSnapshot.exists) {
        ToDoModel task =
            ToDoModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

        task = task.copyWith(isCompleted: task.isCompleted == 0 ? 1 : 0);

        await taskDoc.update(task.toJson());
      } else {
        throw Exception('Task not found');
      }
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<void> deleteToDo(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('todos')
          .doc(user.email)
          .collection('tasks')
          .doc(id)
          .delete();
    } else {
      throw Exception('User is not logged in');
    }
  }

  Stream<List<ToDoModel>> getToDo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestore
          .collection('todos')
          .doc(user.email)
          .collection('tasks')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ToDoModel.fromJson(doc.data()))
            .toList();
      });
    } else {
      throw Exception('User is not logged in');
    }
  }
}
