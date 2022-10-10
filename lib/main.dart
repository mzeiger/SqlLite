import 'package:flutter/material.dart';
import 'package:sqlite/src/screens/query_screen.dart';

void main() => runApp(const SqlLiteApp());

class SqlLiteApp extends StatelessWidget {
  const SqlLiteApp({Key? key}) : super(key: key);
  final String appTitle = 'SqlLite Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
        home: const QueryScreen(),
    );
  }
}
