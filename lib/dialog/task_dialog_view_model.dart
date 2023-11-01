import 'package:flutter/material.dart';
import 'package:flutter_getx_test/model/task_model.dart';
import 'package:flutter_getx_test/services/auth_service.dart';
import 'package:flutter_getx_test/services/firestore_service.dart';
import 'package:get/get.dart';

class TaskDialogViewModel extends GetxController {
  TextEditingController taskController = TextEditingController();

  // Rx<TimeOfDay?> time = TimeOfDay.now().obs;
  // Rx<String> selectedTime = "".obs;
  Rx<TimeOfDay?> time = Rx<TimeOfDay?>(null);
  Rx<String?> selectedTime = Rx<String?>(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FirebaseService firestoreService = FirebaseService();
  final AuthService authService = AuthService();

  timePicker(BuildContext context) async {
    time.value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time.value != null) {
      selectedTime.value = time.value!.format(context).toString();
      print(selectedTime.value);
    }
  }

  onClickUpload() async {
    if (formKey.currentState!.validate()) {
      String taskText = taskController.text.toString();
      if (selectedTime.value != null) {
        TaskModel taskModel = TaskModel(
            task: taskText,
            date: selectedTime.value!,
            uId: authService.user?.uid ?? "abac");
        if (await firestoreService.addTask(taskModel)) {
          Get.back();
        }
      }
    }
  }

  onClickUpdate(TaskModel task) {
    if (formKey.currentState!.validate()) {
      String taskText = taskController.text.toString();

      TaskModel taskModel = TaskModel(
          task: taskText,
          date: selectedTime.value ?? time.value.toString(),
          uId: task.uId,
          docId: task.docId);

      firestoreService.updateTaskAndDate(taskModel);
      Get.back();
    }
  }

  String? taskValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Task is required";
    }

    return null;
  }
}
