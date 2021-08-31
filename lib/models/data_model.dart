import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  late String task;
   String? status;
  late String time;
  late String date;

  DataModel(
      {required this.task,
      required this.time,
      required this.date,
       this.status});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        task: json["task"],
        time: json["time"],
        date: json["date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {"task": task, "time": time, "date": date, "status": status};
}
