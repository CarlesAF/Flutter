import 'package:get/get.dart';

import '../controllers/edit_task_controller.dart';

// Actualizado: Renombrado de EditNoteBinding a EditTaskBinding
class EditTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTaskController>(
      () => EditTaskController()
    );
  }
}
