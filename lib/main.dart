import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivedb/pages/home.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentDirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
