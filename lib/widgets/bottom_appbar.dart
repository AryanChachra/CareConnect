import  'package:CareConnect/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: (){
           Navigator.pushNamed(context, MyRoutes.homeRoute);
          }, icon: Icon(Icons.home),),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, MyRoutes.hospitalRoute);
          }, icon: Icon(Icons.bed,),),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, MyRoutes.doctorRoute);
          }, icon: Icon(CupertinoIcons.videocam_fill,color: Colors.red),),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, MyRoutes.contactRoute);
          }, icon: Icon(Icons.email),),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, MyRoutes.teamRoute);
          }, icon: Icon(CupertinoIcons.group_solid),),
        ],
      ),
    );
  }
}
