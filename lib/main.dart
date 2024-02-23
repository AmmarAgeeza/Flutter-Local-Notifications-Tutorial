import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notification/local_notification_service.dart';
import 'package:flutter_local_notification/notification_details.dart';
import 'package:flutter_local_notification/work_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    LocalNotificationService.init(),
    WorkManagerService().init(),
  ]);
  // await LocalNotificationService.init(); //2
  // await WorkManagerService().init(); //4
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Notification Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        // useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    listenToNotificationStream();
  }

  void listenToNotificationStream() {
    LocalNotificationService.streamController.stream.listen(
      (notificationResponse) {
        log(notificationResponse.id!.toString());
        log(notificationResponse.payload!.toString());
        //logic to get product from database.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailsScreen(
              response: notificationResponse,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: const Icon(Icons.notifications),
        titleSpacing: 0.0,
        title: const Text('Flutter Local Notification Tutorial'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //basic
          ListTile(
            onTap: () {
              LocalNotificationService.showBasicNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Basic Notification'),
            subtitle: const Text('with custom sound'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(0);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
          //repeated
          ListTile(
            onTap: () {
              LocalNotificationService.showRepeatedNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Repeated Notification'),
            subtitle: const Text('every minute'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(1);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
          //Schduled
          ListTile(
            onTap: () {
              LocalNotificationService.showSchduledNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Schduled Notification'),
            subtitle: const Text('after 10 seconds from now'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(2);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
          //cancel All
          ElevatedButton(
            onPressed: () {
              LocalNotificationService.flutterLocalNotificationsPlugin
                  .cancelAll();
            },
            child: const Text('Cancel All'),
          )
        ],
      )),
    );
  }
}


