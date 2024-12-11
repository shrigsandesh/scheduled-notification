import 'package:flutter/material.dart';
import 'package:scheduled_notification/add_notifications.dart';
import 'package:scheduled_notification/db/database_service.dart';
import 'package:scheduled_notification/db/notification_info.dart';
import 'package:scheduled_notification/notification_service.dart';
import 'package:scheduled_notification/utils.dart';
import 'package:scheduled_notification/widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DatabaseService databaseService = DatabaseService();
  late List<NotificationInfo> list;
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called every time the widget is rebuilt or when the page comes into focus
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      list = databaseService.getSavedNotifiation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) async {
              await databaseService.deleteNotification(NotificationInfo(
                name: list[index].name,
                dateTime: list[index].dateTime,
                enabled: false,
              ));
              setState(() {
                list.removeAt(index);
              });
            },
            key: Key(list[index].name),
            child: NotificationTile(
                name: list[index].name,
                value: list[index].enabled,
                time: formatDateTime(list[index].dateTime),
                onChanged: (value) async {
                  // Update the database
                  await databaseService.updateNOfication(NotificationInfo(
                    name: list[index].name,
                    dateTime: list[index].dateTime,
                    enabled: value,
                  ));

                  // Update the in-memory list
                  setState(() {
                    list[index] = NotificationInfo(
                      name: list[index].name,
                      dateTime: list[index].dateTime,
                      enabled: value,
                    );
                  });
                }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddNotifications(
                onDatePicked: (info) async {
                  await databaseService.saveNotifications([
                    NotificationInfo(
                        name: info.name,
                        dateTime: info.dateTime,
                        enabled: info.enabled)
                  ]);
                  await scheduleDailyNotificationFromDate(
                    info.dateTime,
                    'Daily Reminder ${info.name}',
                    'This is your daily notification starting from tomorrow!',
                    info.dateTime,
                  );
                  if (!context.mounted) return;
                  showSnackBar(
                      context: context,
                      title: 'Notification saved successfully.');
                  Navigator.of(context).pop();
                },
              ),
            ),
          ).then((val) {
            _loadNotifications();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
