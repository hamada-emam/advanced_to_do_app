//// POJO CLASS

class Task {
  int? id;
  String? title;
  String? note; 
  String? date;
  String? startTime;
  String? statusofcomplete = "unCompleted";
  String? statusoffave ="favorite";
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.statusoffave,
    this.statusofcomplete,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'statusoffave': statusoffave,
      'statusofcomplete': statusofcomplete,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    statusoffave = json['statusoffave'];
    statusofcomplete = json['statusofcomplete'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }
}
