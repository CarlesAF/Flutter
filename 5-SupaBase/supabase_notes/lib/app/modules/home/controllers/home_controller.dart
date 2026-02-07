import 'package:get/get.dart';
// Actualizado: Import de task_model en lugar de notes_model
import 'package:supabase_notes/app/data/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  // Actualizado: Renombrado de allNotes a allTasks
  RxList allTasks = List<Task>.empty().obs;
  SupabaseClient client = Supabase.instance.client;

  // Actualizado: Renombrado de getAllNotes() a getAllTasks()
  // Ahora consulta la tabla 'tasks' en lugar de 'notes'
  Future<void> getAllTasks() async {
    List<dynamic> res = await client
        .from("users")
        .select("id")
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    int id = user["id"];
    var tasks = await client.from("tasks").select().match(
      {"user_id": id},
    );
    List<Task> tasksData = Task.fromJsonList((tasks as List));
    allTasks(tasksData);
    allTasks.refresh();
  }

  // Actualizado: Renombrado de deleteNote() a deleteTask()
  Future<void> deleteTask(int id) async {
    await client.from("tasks").delete().match({
      "id": id,
    });
    getAllTasks();
  }

  // NUEVO: Método para marcar/desmarcar tareas como completadas
  Future<void> toggleTaskStatus(int id, bool isDone) async {
    await client.from("tasks").update({"done": isDone}).match({
      "id": id,
    });
    getAllTasks();
  }
}
