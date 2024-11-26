class TaskModel {
  String title;
  String time;
  int dateBackgroundColor;
  bool isChecked;

  TaskModel({
    required this.title,
    required this.time,
    required this.dateBackgroundColor,
    this.isChecked = false,
  });

  // Convert TaskModel to Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'dateBackgroundColor': dateBackgroundColor,
      'isChecked': isChecked,
    };
  }

  // Create TaskModel from Map
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'],
      time: json['time'],
      dateBackgroundColor: json['dateBackgroundColor'],
      isChecked: json['isChecked'],
    );
  }
}
