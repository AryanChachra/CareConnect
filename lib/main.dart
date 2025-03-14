import 'package:CareConnect/pages/appointment_booking.dart';
import 'package:CareConnect/pages/bed_booking.dart';
import 'package:CareConnect/pages/bed_details.dart';
import 'package:CareConnect/pages/book_slot.dart';
import 'package:CareConnect/pages/check_user_signin.dart';
import 'package:CareConnect/pages/check_user_signup.dart';
import 'package:CareConnect/pages/contact_us.dart';
import 'package:CareConnect/pages/doctor_dashboard.dart';
import 'package:CareConnect/pages/doctor_details.dart';
import 'package:CareConnect/pages/doctor_sign_in.dart';
import 'package:CareConnect/pages/doctor_sign_up.dart';
import 'package:CareConnect/pages/home_page.dart';
import 'package:CareConnect/pages/hospital_details.dart';
import 'package:CareConnect/pages/landing_page.dart';
import 'package:CareConnect/pages/otp_verification_page.dart';
import 'package:CareConnect/pages/user_sign_in.dart';
import 'package:CareConnect/pages/user_sign_up.dart';
import 'package:CareConnect/pages/team_details.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key:'auth_token');

  runApp(MyApp(token:token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      // initialRoute: token != null ? MyRoutes.homeRoute : MyRoutes.landingRoute,
      initialRoute: MyRoutes.landingRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LandingPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.registerRoute: (context) => UserSignUp(),
        MyRoutes.loginRoute: (context) => SignIn(),
        MyRoutes.landingRoute: (context) => LandingPage(),
        MyRoutes.bedRoute: (context) => BedDetails(),
        MyRoutes.hospitalRoute: (context) => HospitalDetails(),
        MyRoutes.contactRoute: (context) => ContactUs(),
        MyRoutes.teamRoute: (context) => TeamDetailsPage(team: team),
        MyRoutes.formRoute: (context) => BedBooking(),
        MyRoutes.appointmentRoute: (context) => AppointmentViewing(),
        MyRoutes.checkuserRoute: (context) => CheckUserSignUp(),
        MyRoutes.checkusersigninRoute: (context) => CheckUserSignIn(),
        MyRoutes.doctorregisterRoute:(context) => DoctorSignUp(),
        MyRoutes.verifyotpRoute:(context) => OTPVerificationPage(),
        MyRoutes.doctorloginRoute:(context) => DoctorSignIn(),
        MyRoutes.doctorRoute:(context) => DoctorDetails(),
        MyRoutes.bookappointmentRoute:(context) => AppointmentBooking(),
        MyRoutes.doctordashboardRoute:(context) => DoctorDashboard(),
      },
    );
  }
}