import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    // TODO: implement onReady
    selectTasksBydate();
    super.onReady();
  }
  var taskList =<Task>[].obs;
  String? selectedDate ;

  Future<int> addTask({Task? task})async {
    return await DBHelper.insert(task);
  }

  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll((tasks.map((data) => new Task.fromJson(data)).toList()));

  }
  void selectTasks(String where) async{
    List<Map<String, dynamic>> tasks = await DBHelper.select(where);
    taskList.assignAll((tasks.map((data) => new Task.fromJson(data)).toList()));
  }
  void selectTasksBydate() async{
    String? date = selectedDate ?? DateFormat.yMd().format(DateTime.now());
    List<Map<String, dynamic>> tasks = await DBHelper.select("date = '$date' OR ( repeat = 'Daily' AND isCompleted = 0 )");
    taskList.assignAll((tasks.map((data) => new Task.fromJson(data)).toList()));
  }
  void deleteTask(Task task){
     DBHelper.deleteTask(task);
     getTasks();
  }
  Future<void> markTaskAsCompleted(int id) async {
    await DBHelper.updateTaskCompleted(id);
    getTasks();
  }








}//TaskController