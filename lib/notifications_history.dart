import "dart:convert";

import "package:flutter/material.dart";
import "package:get/get.dart";

class NotificationHistory extends StatefulWidget {
   NotificationHistory({super.key});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  List<Map<String, dynamic>> notifications = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotifications();

  }

  Future<void> fetchNotifications() async {
    //this is for user 1 only
    final response = await GetConnect().get(
          'http://192.168.1.147/notifications/get_notifications.php?user_id=1');

    if (response.statusCode == 200) {
      setState(() {
        notifications = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print("Error fetching notifications: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(

            title: Text(notifications[index]['title']),
            subtitle: Text(notifications[index]['message']),
          );
        },
      ),
    );
  }
}
