import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/task_model.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TAREAS'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                Get.toNamed(Routes.PROFILE);
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: FutureBuilder(
            future: controller.getAllTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Obx(() => controller.allTasks.isEmpty
                  ? const Center(
                      child: Text("NO HAY TAREAS"),
                    )
                  : ListView.builder(
                      itemCount: controller.allTasks.length,
                      itemBuilder: (context, index) {
                        Task task = controller.allTasks[index];
                        return ListTile(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_TASK,
                            arguments: task,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: task.done! ? Colors.green : Colors.grey,
                            child: Text(task.done! ? "✓" : "${task.id}"),
                          ),
                          title: Text(
                            task.title ?? "Sin título",
                            style: TextStyle(
                              decoration: task.done! ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.description ?? "Sin descripción"),
                              if (task.dueDate != null)
                                Text(
                                  "Vence: ${task.dueDate}",
                                  style: const TextStyle(fontSize: 12, color: Colors.red),
                                ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: task.done ?? false,
                                  onChanged: (value) {
                                    controller.toggleTaskStatus(task.id!, value ?? false);
                                  },
                                ),
                                IconButton(
                                  onPressed: () async =>
                                      await controller.deleteTask(task.id!),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_TASK),
          child: const Icon(Icons.add),
        ));
  }
}
