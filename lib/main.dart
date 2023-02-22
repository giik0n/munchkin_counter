import 'package:flutter/material.dart';
import 'package:munchkin_counter/screens/MyApp.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  Wakelock.enable();
  runApp(MyApp());
}
