import 'package:dices/DicePage.dart';
import 'package:dices/widget/DiceDrawer.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DiceDrawer(),
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: const Text('Dice app'),
          backgroundColor: Colors.teal,
        ),
        body: DicePage(),
      ),
    ),
  );
}