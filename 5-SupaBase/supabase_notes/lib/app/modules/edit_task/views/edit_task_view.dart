// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/task_model.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

import '../controllers/edit_task_controller.dart';

class EditTaskView extends GetView<EditTaskController> {
  Task task = Get.arguments;
  HomeController homeC = Get.find();

  EditTaskView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.titleC.text = task.title!;
    controller.descC.text = task.description!;
    controller.dueDateC.text = task.dueDate ?? '';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Tarea'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.titleC,
              decoration: const InputDecoration(
                labelText: "Título de la tarea",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: controller.descC,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: controller.dueDateC,
              decoration: const InputDecoration(
                labelText: "Fecha de vencimiento (opcional)",
                border: OutlineInputBorder(),
                hintText: "ej: 2026-02-15",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    bool res = await controller.editTask(task.id!);
                    if (res == true) {
                      await homeC.getAllTasks();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Editar tarea" : "Cargando...")))
          ],
        ));
  }
}
