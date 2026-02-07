import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Actualizado: Renombrado de EditNoteController a EditTaskController
class EditTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  // NUEVO: TextEditingController para fecha de vencimiento
  TextEditingController dueDateC = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  // Actualizado: Renombrado de editNote() a editTask()
  // Ahora actualiza tabla 'tasks' con nuevos campos
  Future<bool> editTask(int id) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      // Actualizado: Tabla cambió de 'notes' a 'tasks'
      await client
          .from("tasks")
          .update({
            "title": titleC.text,
            "description": descC.text,
            // NUEVO: due_date ahora se puede actualizar
            "due_date": dueDateC.text.isNotEmpty ? dueDateC.text : null,
          }).match({
        "id": id,
      });
      return true;
    } else {
      return false;
    }
  }
}
