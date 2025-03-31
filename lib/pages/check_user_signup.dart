import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';


class CheckUserSignUp extends StatefulWidget {
  const CheckUserSignUp({super.key});

  @override
  State<CheckUserSignUp> createState() => _CheckUserSignUpState();
}

class _CheckUserSignUpState extends State<CheckUserSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: BottomArcClipper(height: 30),
                  child: Container(
                    height: 400,
                    color: MyTheme.blueColor,
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Image.asset(
                    'assets/images/loginImgbg.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                SizedBox(
                    height: 100,
                    width: 350,
                    child: Image(
                        image: AssetImage('assets/images/CareConnect.png'))),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.registerRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.blueColor, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners
                    ),
                    elevation: 5, // Shadow
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.app_registration, size: 20,color: Colors.white,), // Add an email icon
                      SizedBox(width: 8),
                      Text(
                        "Sign Up as Patient",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.doctorregisterRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    foregroundColor: MyTheme.blueColor, // Text color
                    padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners
                    ),
                    elevation: 5, // Shadow
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.app_registration, size: 20,color: MyTheme.blueColor,), // Add an email icon
                      SizedBox(width: 8),
                      Text(
                        "Sign Up as Doctor",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "By signing up you are agreeing to our",
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                Text(
                  "Terms and Conditions",
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  final double height;

  BottomArcClipper({required this.height});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - height);
    path.quadraticBezierTo(
        size.width / 2, size.height + height, size.width, size.height - height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
