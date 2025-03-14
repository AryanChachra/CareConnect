import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      backgroundColor: MyTheme.blueColor,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text("Chat Support will be available Soon"),
        ));
      },
      child: Icon(CupertinoIcons.chat_bubble, size: 45,color: Colors.white,),
    );
  }
}
