import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    elevation: 5,
    automaticallyImplyLeading: removeBackButton ? false: true,
    title: Text(
      isAppTitle ? 'Nvil': titleText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontFamily: "Signatra",
        fontSize: isAppTitle ? 50.0: 30.0
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}
