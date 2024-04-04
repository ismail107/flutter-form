import 'package:flutter/material.dart';
import 'package:fata/email_form.dart';
import 'package:fata/utils/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmailForm(),
    );
  }
}
