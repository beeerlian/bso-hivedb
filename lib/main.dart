import 'package:flutter/material.dart';
import 'package:flutter_hivedb/pages/home.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var docDirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(docDirectory.path);
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
