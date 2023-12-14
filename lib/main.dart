// main.dart

import 'dart:convert';

import 'package:backss/noticontroller.dart';
import 'package:backss/notifications_history.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import "package:get/get.dart";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Perform API call or any background task here
    try {
      // Make API call using getx

//mmmm
      //when you this code is to test on ios devices NOTE : minimum time to wait in ios is 15 minitus
      // NotificationService()
      //     .showNotification(title: "terst for ios ", body: "message for ios ");
      var data = {
        "user_id": 1,
      };

      var response = await GetConnect().post(
        'http://amjadtech.com/jad/check_noti.php',
        FormData(data),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        if (result.isNotEmpty) {
          print("Received");

          for (var notification in result) {
            print(notification['title']);
            var title = notification["title"];
            var body = notification["message"];
            NotificationService().showNotification(title: title, body: body);
            await Future.delayed(Duration(seconds: 2));
          }
        } else {
          print("No new notifications");
        }

        GetConnect().get("http://amjadtech.com/jad/notification_history.php");
      } else {
        print("Failed to fetch notifications");
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
    frequency: Duration(minutes: 15),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Background API Call'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(onPressed: (){
              Get.to(NotificationHistory());
            }, icon: Icon(Icons.history)),
          ],
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
                  var data = {
                    "user_id": 1,
                  };

                  var response = await GetConnect().post(
                    'http://amjadtech.com/jad/check_noti.php',
                    FormData(data),
                  );

                  if (response.statusCode == 200) {
                    var result = json.decode(response.body);

                    if (result.isNotEmpty) {
                      print("Received");

                      for (var notification in result) {
                        print(notification['title']);
                        var title = notification["title"];
                        var body = notification["message"];
                        NotificationService().showNotification(title: title, body: body);
                        await Future.delayed(Duration(seconds: 2));
                      }
                    } else {
                      print("No new notifications");
                    }
                    
                    GetConnect().get("http://amjadtech.com/jad/notification_history.php");
                  } else {
                    print("Failed to fetch notifications");
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
