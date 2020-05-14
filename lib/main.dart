import 'package:flutter/material.dart';
import 'player.dart';

void main() => runApp(MaterialApp(
  home: Player(),
  theme: ThemeData(
    primarySwatch: Colors.red,
  ),
  debugShowCheckedModeBanner: false,
));
