// main.dart

import 'dart:convert';

import 'package:backss/noticontroller.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:get/get.dart";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Perform API call or any background task here
    try {
      // Make API call using getx
      var data= {
        "cp__member_first_name":"jad",
        "cp__member_last_name":"shaheen",
        "cp__member_phone":"4444444",
        "cp__member_name":"jad121",
        "cp__member_password":"123456789",
        "cp__member_email":"ruba.s.opentech@gmail.com"
      };



      //when you this code is to test on ios devices NOTE : minimum time to wait in ios is 15 minitus
      // NotificationService()
      //     .showNotification(title: "terst for ios ", body: "message for ios ");


      var response = await GetConnect().post('http://192.168.1.170:2090/cp/ms/cp_api/member_api.php?action=register',FormData(data));
      var result = json.decode(response.body);
      NotificationService()
          .showNotification(title: result["title"], body: result["message"]);
      if (response.statusCode == 200) {
        NotificationService()
            .showNotification(title: result["title"], body: result["message"]);
        // Check if a new record is added in the database
        // If true, trigger a local notification




      }
    } catch (e) {
      print("Error: $e");
    }

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  NotificationService().initNotification();
  Workmanager().registerPeriodicTask(
    "periodicTask",
    "simplePeriodicTask",
    //it must be 15 min since in ios it the minimum required time for a task to excec in the background or in terminated state of the application
    frequency: Duration(minutes: 9),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Background API Call'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 200,),
              Text('Your App Content'),
              SizedBox(height: 50,),
              //this button is to check if the function work in the foreground
              ElevatedButton(onPressed: () async{
                try {
                  //api to add a record to tamallak database
                  var data= {
                    "cp__member_first_name":"jad",
                    "cp__member_last_name":"shaheen",
                    "cp__member_phone":"123556",
                    "cp__member_name":"jad121",
                    "cp__member_password":"123456789",
                    "cp__member_email":"ruba.s.opentech@gmail.com"
                  };


                  var response = await GetConnect().post('http://192.168.1.170:2090/cp/ms/cp_api/member_api.php?action=register',FormData(data));
                  var result = json.decode(response.body);
                  print("this is the body $result ");
                  NotificationService()
                      .showNotification(title: result["title"], body: result["message"]);
                  if (response.statusCode == 200) {
                    NotificationService()
                        .showNotification(title: result["title"], body: result["message"]);
                    // Check if a new record is added in the database
                    // If true, trigger a local notification




                  }
                } catch (e) {
                  print("Error: $e");
                }
              }, child: Text("Click Me "))
            ],
          ),

        ),
      ),
    );
  }
}
