import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/buttons.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

import '../models/task.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';
import 'add_task_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  DatePickerController _datePickerController = DatePickerController();


  var notifyHelper;
  String? formateDate;

  @override
  void initState() {
    // TODO: implement initState
    print("initState");
    super.initState();

    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.isAndroidPermissionGranted();
    notifyHelper.requestPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickerController.animateToSelection(duration : const Duration(milliseconds: 2000));
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose");
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _datePicker(),
          _showTasks(),
        ],
      ),
    );
  }
  _datePicker(){
    return Container(
      margin: const EdgeInsets.only(top: 20,left: 20),
      child: DatePicker(
        // DateTime.now(),
        DateTime(DateTime.now().year, DateTime.now().month, 1, 0, 0),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: datePickerStyle(size: 16),
        dayTextStyle: datePickerStyle(size: 16),
        monthTextStyle: datePickerStyle(size: 14),
        controller: _datePickerController,
        onDateChange: (date){
          setState(() {
            _selectedDate = date;
            _taskController.selectedDate = DateFormat.yMd().format(_selectedDate);
            // _taskController.selectTasks("date = '$formateDate' OR ( repeat = 'Daily' AND isCompleted = 0 )");
            _taskController.selectTasksBydate();
          });

        },
      ),
    );
  }
  _addTaskBar(){
      return Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
        child: GestureDetector(
          onTap: () {

            setState(() {
              // _datePickerController._currentDate = selectedDate;
              _datePickerController.setDateAndAnimate(DateTime.now(),
                  duration: const Duration(milliseconds: 2000));
              _taskController.selectedDate = DateFormat.yMd().format(_selectedDate);
              _taskController.selectTasksBydate();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMd().format(DateTime.now()),style: subHeadingStyle,),

                         Text("Today",style: headingStyle,)

                  ],
                ),
              ),
              MyButton(
                label: "+ Add Task",
                onTap: () async {
                  await Get.to(const AddTaskPage());
                  // refresh after back
                  // print("back to home");
                  _taskController.getTasks();
                },
              )
            ],
          ),
        ),
      );
  }
  _appBar(){
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title : " Theme changed",
            body:ThemeService().iSDarkTheme()?"Light":"Dark"
          );
          print( ThemeService().iSDarkTheme());
          // notifyHelper.scheduledNotification(
          //   title : " theme changes 5 seconds ago",
          //   body: Get.isDarkMode?"Light":"Dark"
          // );
          },
        child: Icon(
           ThemeService().iSDarkTheme() ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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
  _showTasks(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
                Task task = _taskController.taskList[index];
                // DateTime date = DateFormat.jm().parse("06:51 PM");


                notifyHelper.scheduledTaskNotification(task);

                print(task.toJson());
                // print("myDate is $myDate");
                // print("Hour is $hour , Minute is $minute");
               return AnimationConfiguration.staggeredList(
                   position: index,
                   child: SlideAnimation(
                     child: FadeInAnimation(
                       child: Row(
                         children: [
                           GestureDetector(
                             onTap: (){
                               print("Tapped");
                               _showBottomSheet(context,task);
                             },
                             child: TaskTile(task),
                           )
                         ],
                       ),
                     ),
                   )
               );
              },
          );
        }),
    );
  }
  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1
            ? MediaQuery.of(context).size.height*0.32
            : MediaQuery.of(context).size.height*0.40,
        color: context.theme.bottomSheetTheme.backgroundColor,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: buttonBorderClr,

              ),
            ),
            Spacer(),
            task.isCompleted==1
                ?Container()
                :_showBottomSheetButtons(
                  label: "Task Completed",
                  onTap: (){
                    _taskController.markTaskAsCompleted(task.id!);
                     Get.back();
                  },
                  clr:primaryClr,
                  context: context
                ),
            SizedBox(height: 10,),
            _showBottomSheetButtons(
                label: "Delete Task",
                onTap: (){
                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr:(Colors.red[300])!,
                context: context
            ),
            SizedBox(height: 30,),
            _showBottomSheetButtons(
                label: "Close",
                onTap: (){
                  Get.back();
                },
                clr:Colors.transparent,
                context: context,
                isClose: true
            ),
            SizedBox(height: 10,),
          ],
        ),


      ),

    );
  }
  _showBottomSheetButtons({required String label,required Function()? onTap,required Color clr,bool isClose = false,required BuildContext context}){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 55,
          width: MediaQuery.of(context).size.width*0.9,

          decoration: BoxDecoration(
            color: clr,
            border: Border.all(
              width: 2,
              color: isClose == true ? (buttonBorderClr)! : clr
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: isClose ? titleStyle: titleStyle.copyWith(color: Colors.white),

            ),
          ),
        ),

      );
  }
}
