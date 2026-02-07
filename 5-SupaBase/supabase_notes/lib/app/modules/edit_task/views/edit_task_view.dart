// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/task_model.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

import '../controllers/edit_task_controller.dart';

// Actualizado: Renombrado de EditNoteView a EditTaskView
class EditTaskView extends GetView<EditTaskController> {
  // Actualizado: Variable renombrada de 'note' a 'task'
  Task task = Get.arguments;
  HomeController homeC = Get.find();

  EditTaskView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.titleC.text = task.title!;
    controller.descC.text = task.description!;
    // NUEVO: Carga la fecha de vencimiento si existe
    controller.dueDateC.text = task.dueDate ?? '';
    return Scaffold(
        appBar: AppBar(
          // Actualizado: Título cambió a 'Editar Tarea'
          title: const Text('Editar Tarea'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.titleC,
              decoration: const InputDecoration(
                // Actualizado: Label más descriptivo
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
            // NUEVO: Campo para editar fecha de vencimiento
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
                    // Actualizado: Llama editTask() en lugar de editNote()
                    bool res = await controller.editTask(task.id!);
                    if (res == true) {
                      // Actualizado: Llama getAllTasks() en lugar de getAllNotes()
                      await homeC.getAllTasks();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                // Actualizado: Texto del botón actualizado
                child: Text(
                    controller.isLoading.isFalse ? "Editar tarea" : "Cargando...")))
          ],
        ));
  }
}
