import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/buttons.dart';
import 'package:todo_app/ui/widgets/input_fields.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/theme_services.dart';
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController=Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime ="9:30 PM";
  String _startTime =DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedReminder = 5;
  List<int> reminderList  =[ 5,10,15,20,25  ];
  String _selectedRepeat = "None";
  List<String> repeatList  =["None","Daily","Weekly","Monthly"];
  int _selectedColor =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add New Task",style: headingStyle,),
              MyInputField(title: "Title",hint: "Enter your title",controller: _titleController,),
              MyInputField(title: "Note",hint: "Enter your note",controller: _noteController,),
              MyInputField(title: "Date",hint: DateFormat.yMMMd().format(_selectedDate),
                widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,color: Colors.grey,),
                onPressed: (){_getDateFromUser();},
              ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(title: "Start Date",hint: _startTime,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_filled_rounded,color: Colors.grey,),
                          onPressed: (){_getTimeFromUser(isStartTime: true);},
                        ),),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(title: "End Date",hint: _endTime,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_filled_rounded,color: Colors.grey,),
                          onPressed: (){_getTimeFromUser(isStartTime: false);},
                        ),),
                  ),
                ],
              ),
              MyInputField(title: "Remind",
                hint: "$_selectedReminder minutes early",
                widget: DropdownButton(
                  underline: Container(height: 0,),
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: reminderList.map<DropdownMenuItem<String>>((int value){
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString(),style: TextStyle(color: Colors.grey)),
                        );
                  } ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedReminder = int.parse(newValue!);

                    });
                    print(newValue);
                  },
                ),
              ),
              MyInputField(title: "Repeated",
                hint: "$_selectedRepeat ",
                widget: DropdownButton(
                  underline: Container(height: 0,),
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color: Colors.grey),),
                    );
                  } ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue! ;

                    });
                    print(newValue);
                  },
                ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Create Task",
                    onTap: ()=>_validateDate(),
                  )
                ],
              ),
              SizedBox(height: 18,),
            ],
          ),
        ),
      ),

    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      // add Data to database
      _insertTask();
      Get.back();
    }else if(_titleController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded,color: Colors.red,),

      );
    }
  }
  _insertTask() async {
  int value = await _taskController.addTask(
    task:   Task(
                note: _noteController.text,
                title: _titleController.text,
                date: DateFormat.yMd().format(_selectedDate),
                startTime: _startTime,
                endTime: _endTime,
                remind: _selectedReminder,
                repeat: _selectedRepeat,
                color: _selectedColor,
                isCompleted: 0,
              )
            );
          print(" my id is $value");
  }
  _colorPallete(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Color",style: titleStyle,),
          SizedBox(height: 8.0,),
          Wrap(
            children: List<Widget>.generate(
                3,
                    (int index) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColor = index;
                      });


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index==0 ? primaryClr: index==1 ? pinkClr:yellowClr,
                        child:  _selectedColor == index? Icon(Icons.done,color: Colors.white,size: 16,):Container(),
                      ),
                    ),
                  );
                }),
          ),
        ],
      );
  }
  _appBar(){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: context.theme.secondaryHeaderColor,
        ),


      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/circular-avatar.jpg"),
        ),
        SizedBox(width: 20,),
      ],
    );
  }
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025)
    );
    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });


    }else{
      print("null Date ");
    }
  }
  _getTimeFromUser({required bool isStartTime}) async{
    var pickedTime = await _showTimePicker();
    String _formatedTime =pickedTime!= null ? pickedTime.format(context) : "";
    if(pickedTime == null){
      print("null Time ");
    }else if(isStartTime == true){
      setState(() {
        _startTime = _formatedTime;

      });

    }else if(isStartTime == false){

      setState(() {
        _endTime = _formatedTime;

      });
    }
  }
  _showTimePicker(){
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: int.parse(DateFormat.H().format(DateTime.now())),
            minute: int.parse(DateFormat.m().format(DateTime.now()))),

    );
  }
}


