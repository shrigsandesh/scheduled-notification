import 'package:flutter/material.dart';
import 'package:scheduled_notification/db/database_service.dart';
import 'package:scheduled_notification/notification_page.dart';

DatabaseService databaseService = DatabaseService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationPage(),
    );
  }
}
