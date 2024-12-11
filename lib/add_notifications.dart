import 'package:flutter/material.dart';
import 'package:scheduled_notification/db/notification_info.dart';
import 'package:scheduled_notification/utils.dart';

class AddNotifications extends StatefulWidget {
  const AddNotifications({super.key, required this.onDatePicked});

  final void Function(NotificationInfo info) onDatePicked;

  @override
  State<AddNotifications> createState() => _AddNotificationsState();
}

class _AddNotificationsState extends State<AddNotifications> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _intervalController = TextEditingController();

  DateTime? pickedDateTime;
  String? name;
  @override
  void initState() {
    super.initState();
    _nameController.text = "";
    _dateController.text = "Select date";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Pick repeated interval(in days)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Pick date & time (from)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                var date = await showDateTimePicker(context: context);
                setState(() {
                  pickedDateTime = date;
                  _dateController.text = pickedDateTime.toString();
                });
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _nameController.text ==
                              "Enter notfication name here") {
                        showSnackBar(
                            context: context,
                            title: "Notification name is required");

                        return;
                      }

                      if (pickedDateTime == null) {
                        showSnackBar(
                            context: context,
                            title: "'Date & time is required");
                        return;
                      }
                      widget.onDatePicked(NotificationInfo(
                          name: _nameController.text,
                          dateTime: pickedDateTime!,
                          enabled: true,
                          interval:
                              int.tryParse(_intervalController.text) ?? 1));
                    },
                    child: const Text('Save'))),
          ],
        ),
      ),
    );
  }
}
