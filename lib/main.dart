import 'package:dices/DicePage.dart';
import 'package:dices/themeData.dart';
import 'package:dices/widget/DiceDrawer.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: Scaffold(
        drawer: DiceDrawer(),
        appBar: AppBar(
          title: const Text('Dice app'),
        ),
        body: const DicePage(),
      ),
    ),
  );
}