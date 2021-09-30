class Task {
  Task(this.title, this.desc, {this.isDone = false});
  String title;
  String desc;
  bool isDone;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(json["title"], json["desc"], isDone: json["isDone"]);
  }

  static Map<String, dynamic> toJson(Task task) {
    return {
      "title": task.title,
      "desc": task.desc,
      "isDone": task.isDone,
    };
  }
}
