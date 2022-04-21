import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';

import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  final List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  final List<String> _repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appPar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Add title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Add note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind Minutes Early",
                widget: Row(
                  children: [
                    DropdownButton(
                      items: _remindList
                          .map<DropdownMenuItem<String>>(
                            (int e) => DropdownMenuItem<String>(
                              value: e.toString(),
                              child: Text(
                                "$e",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 30,
                      elevation: 4,
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      items: _repeatList
                          .map<DropdownMenuItem<String>>(
                            (String e) => DropdownMenuItem<String>(
                              value: e.toString(),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 30,
                      elevation: 4,
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      label: "Create Task",
                      onTap: () {
                        _validateDate();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appPar() => AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            //child: AssetImage("images/person.jpeg"),
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 15,
          ),
          SizedBox(width: 15),
        ],
      );

  _validateDate() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required!",
        "You need to fill the missed fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
    } else {
      print("Something Wrong!");
    }
  }

  _addTasksToDB() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      print(value);   // the id
    }
    catch(e){
      print("Error While Adding Task!");
    }
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10 , bottom: 10,),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 15,
                          color: Colors.white,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {
      print("Date is not selected!");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,  // the default
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );

    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(
        () => _startTime = _formattedTime,
      );
    }
    else if (!isStartTime) {
      setState(
        () => _endTime = _formattedTime,
      );
    } else {
      print("Time may be cancelled");
    }

  }
}
