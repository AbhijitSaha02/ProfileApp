import 'dart:io';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final bool edit;
  const DisplayImage(
      {Key? key,
      required this.imagePath,
      required this.onPressed,
      required this.edit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Color.fromRGBO(255, 62, 50, 1);

    return Center(
      child: Stack(
        children: <Widget>[
          buildImage(color),
          if (edit)
            Positioned(
              child: buildEditIcon(color),
              right: 4,
              top: 10,
            ),
        ],
      ),
    );
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    var image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return CircleAvatar(
      radius: (edit) ? 75 : 90,
      backgroundColor: color,
      child: CircleAvatar(
        backgroundImage: image as ImageProvider,
        radius: (edit) ? 70 : 80,
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: Icon(
        Icons.edit,
        color: color,
        size: 20,
      ));

  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}
