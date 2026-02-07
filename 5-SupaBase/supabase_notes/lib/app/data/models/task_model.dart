// Modelo actualizado para tareas (anteriormente Notes)
class Task {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? createdAt;
  // NUEVO: Campo para marcar tareas como completadas
  bool? done;
  // NUEVO: Campo para fecha de vencimiento
  String? dueDate;

  Task({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.createdAt,
    this.done = false,
    this.dueDate,
  });

  // Actualizado: Ahora mapea done y due_date
  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    done = json['done'] ?? false;
    dueDate = json['due_date'];
  }

  // Actualizado: Incluye done y due_date en la serialización
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['done'] = done;
    data['due_date'] = dueDate;
    return data;
  }

  static List<Task> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Task.fromJson(e)).toList();
  }
}
