import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  RxList<Task> taskList = <Task>[
    /*Task(
      id: 1,  /////
      title: "Task 1",
      note: "This is note number 1",
      startTime: DateFormat("hh:mm a")
          .format(DateTime.now().add(const Duration(minutes: 1)))
          .toString(),
      endTime: "02:45",
      isCompleted: 0,
      color: 1,
    ),*/
  ].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(
      tasks.map(
        (data) => Task.fromJson(data),
      ).toList(),
    );
  }

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
