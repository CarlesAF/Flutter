import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TextEditingController dueDateC = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  Future<bool> editTask(int id) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      await client
          .from("tasks")
          .update({
            "title": titleC.text,
            "description": descC.text,
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
