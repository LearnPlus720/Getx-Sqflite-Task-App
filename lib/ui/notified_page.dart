import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/theme.dart';


class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({super.key,required this.label});


  @override
  Widget build(BuildContext context) {
    print(label);
    var task_data = label.toString().split("::");

    int task_id = int.parse(task_data[0]);
    String task_title = task_data[1].toString();
    String task_note = task_data[2].toString();
    return  Scaffold(
      appBar: AppBar(
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
        title: Center(child: Text(task_title,style: TextStyle(color: Colors.black),)),
        
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: containerBackgroundClr
          ),
          child: Center(
            child: Text(
                task_title,
                style: verseTitleStyle(fontSize: 30)
            ),
          ),
        ),
      ),

    );
  }
}
