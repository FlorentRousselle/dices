import 'package:flutter/material.dart';

Drawer DiceDrawer() {
  return Drawer(
    child: ListView(
      children: const [
        DrawerHeader(child: Text("header")),
        ListTile(
          title: Text("menu 1"),
        )
      ],
    ),
  );
}
