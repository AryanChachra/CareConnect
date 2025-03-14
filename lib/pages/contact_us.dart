import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';


class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Contact Us".text.color(MyTheme.blueColor).xl5.bold.make().p16(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                    color: MyTheme.blueColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 25,
              ),
              Form(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: MyTheme.blueColor),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      // 5.heightBox,
                      SizedBox(height: 5,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: MyTheme.blueColor),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Message",
                          labelStyle: TextStyle(color: MyTheme.blueColor),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.blueColor),
                        onPressed: () {
                          _submitform(context);
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}

void _submitform(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Form submitted!'),
    ),
  );
}
