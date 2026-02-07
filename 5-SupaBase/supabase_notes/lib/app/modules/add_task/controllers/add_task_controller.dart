import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Actualizado: Renombrado de AddNoteController a AddTaskController
class AddTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  // NUEVO: TextEditingController para fecha de vencimiento
  TextEditingController dueDateC = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  // Actualizado: Renombrado de addNote() a addTask()
  // Ahora inserta en tabla 'tasks' con campos adicionales
  Future<bool> addTask() async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      List<dynamic> res = await client
          .from("users")
          .select("id")
          .match({"uid": client.auth.currentUser!.id});
      Map<String, dynamic> user = (res).first as Map<String, dynamic>;
      int id = user["id"];
      // Actualizado: Tabla cambió de 'notes' a 'tasks'
      await client.from("tasks").insert({
        "user_id": id,
        "title": titleC.text,
        "description": descC.text,
        "created_at": DateTime.now().toIso8601String(),
        // NUEVO: done siempre inicia como false
        "done": false,
        // NUEVO: due_date es opcional
        "due_date": dueDateC.text.isNotEmpty ? dueDateC.text : null,
      });
      return true;
    } else {
      return false;
    }
  }
}
