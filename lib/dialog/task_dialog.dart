import 'package:flutter/material.dart';
import 'package:flutter_getx_test/dialog/task_dialog_view_model.dart';
import 'package:flutter_getx_test/model/task_model.dart';
import 'package:get/get.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({super.key, this.isEdit = false, this.taskModel});

  final bool isEdit;
  final TaskModel? taskModel;

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  TaskDialogViewModel viewModel = TaskDialogViewModel();

  @override
  void initState() {
    super.initState();
    if (widget.taskModel != null) {
      viewModel.selectedTime.value = widget.taskModel!.date.toString();
      viewModel.taskController.text = widget.taskModel!.task;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          height: 300,
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildTextField(viewModel.taskController, "Enter Task",
                    "Enter Task Todo here",
                    validator: viewModel.taskValidator),
                Row(
                  children: [
                    const Text(
                      "Time : ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          children: [
                            viewModel.time.value != null ||
                                    viewModel.selectedTime.value != null
                                ? TextSpan(
                                    text: viewModel.selectedTime.value,
                                    style: const TextStyle(color: Colors.black),
                                  )
                                : TextSpan(
                                    text: '"Please Select Date "',
                                    style: TextStyle(
                                        color: Colors.red.withOpacity(0.4),
                                        fontWeight: FontWeight.bold),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () => viewModel.timePicker(context),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent.withOpacity(0.6),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => widget.isEdit
                          ? viewModel.onClickUpdate(widget.taskModel!)
                          : viewModel.onClickUpload(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.lightGreenAccent.withOpacity(0.6))),
                      child: Text(
                        widget.isEdit ? 'Update' : "Upload",
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController emailController, String label, String hint,
      {String? Function(String?)? validator}) {
    return TextFormField(
      validator: validator,
      controller: emailController,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        fillColor: Colors.black12,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
}
