import 'package:flutter/material.dart';

class Hamburger extends StatelessWidget {
  final BuildContext parentContext;

  const Hamburger({Key key, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        iconSize: 36,
        onPressed: () {
          Scaffold.of(parentContext).openDrawer();
        });
  }
}
