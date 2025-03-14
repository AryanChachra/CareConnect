import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/arc.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = FlutterSecureStorage();
  Future<String?> _getUserType() async {
    String? userType = await _storage.read(key: 'userType');
    return userType;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      appBar: CustomAppBar(),
      body: FutureBuilder<String?>(
        future: _getUserType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading user type"));
          }
          String route1 = MyRoutes.hospitalRoute;
          String route2 = MyRoutes.doctorRoute;
          String title1 = 'Search Hospitals';
          String title2 = 'Talk with Doctor';
          String subtitle1 = 'Select the Hospital of your choice!!';
          String subtitle2 = 'Book Appointment!!';


            if (snapshot.hasData && snapshot.data == "Doctor") {
              route1 = MyRoutes.doctordashboardRoute;
              route2 = MyRoutes.doctoravailableslotRoute;
              title1 = 'Appointment Requests';
              title2 = 'Manage Slots';
              subtitle1 = 'Manage appointment requests!!';
              subtitle2 = 'Manage your available slots!!';
            }


          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/doctors.png"),
                CustomPaint(
                  size: Size(
                    double.infinity,
                    70,
                  ),
                  painter: ArcPainter(color: MyTheme.blueColor),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    "At CareConnect, we're dedicated to revolutionizing healthcare access. Our user-friendly platform offers real-time bed availability, personalized recommendations, and seamless communication with healthcare providers. Join us in simplifying the healthcare journey for everyone.",
                    textAlign: TextAlign.center,
                    style: (TextStyle(
                        color: MyTheme.darkblueColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17)),
                  ),
                ),
                CustomPaint(
                  size: Size(
                    double.infinity,
                    70,
                  ),
                  painter: ArcPainter(color: MyTheme.blueColor),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, route1);
                      },
                      child: Container(
                        width: (snapshot.hasData && snapshot.data == "Doctor") ? 300 : 145,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MyTheme.blueColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.lightblueColor,
                              blurRadius: 6,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_hospital,
                                  color: MyTheme.lightblueColor,
                                  size: 30,
                                )),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                            title1,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              subtitle1,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (snapshot.hasData && snapshot.data != "Doctor")
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, route2);
                      },
                      child: Container(
                        width: 145,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: MyTheme.blueColor,
                              blurRadius: 6,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyTheme.blueColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.videocam_fill,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              title2,
                              style: TextStyle(
                                fontSize: 22,
                                color: MyTheme.blueColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              subtitle2,
                              style: TextStyle(color: MyTheme.blueColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}
