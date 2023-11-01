import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_test/model/task_model.dart';
import 'package:flutter_getx_test/services/dialog_service.dart';
import 'package:flutter_getx_test/services/firestore_service.dart';
import 'package:get/get.dart';

class TodoViewModel extends GetxController {
  final DialogService dialogService = DialogService();
  final FirebaseService firebaseService = FirebaseService();

  RxList<TaskModel> taskList = <TaskModel>[].obs;
  StreamSubscription<QuerySnapshot<Object?>>? stream;

  getTaskList() {
    stream = firebaseService.todo.snapshots().listen((snapshot) {
      taskList.value.clear();
      taskList.value = List.generate(
          snapshot.size,
          (index) => TaskModel.fromMap(
              snapshot.docs[index] as DocumentSnapshot<Map<String, dynamic>>));
    });
  }

  disposeStream() {
    stream?.cancel();
  }

  TaskModel getTaskData(int index) {
    return taskList[index];
  }

  onclickFAB(BuildContext context) {
    dialogService.showAddDialog(context);
  }

  deleteTask(index) {
    firebaseService.deleteTask(getTaskData(index).docId);
  }

  editTask(
    BuildContext context,
    int index,
    bool isEdit,
  ) {
    print("edit task button is clicked");

    dialogService.showAddDialog(context,
        isEdit: isEdit, taskModel: getTaskData(index));
  }
}
