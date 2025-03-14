import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isLoading = false;
  int? doctorid;
  String? doctorName;
  String? bookedSlot;
  String? date;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      doctorid = args["doctorid"];
      doctorName = args["doctorName"];
      bookedSlot = args["bookedSlot"];
      date = args["date"];
    }
  }



  Future<void> _requestforappointment() async {
    if (!_formKey.currentState!.validate()) return;
    String? userName = await _storage.read(key: 'userName');
    String? id = await _storage.read(key: 'UserId');
    int userId = int.parse(id!);
    final data = {
      "user_id": userId,
      "user_name": userName,
      "Doctor_id": doctorid,
      "doctor_name": doctorName,
      "booked_slot": bookedSlot,
      "appointment_date": date,
      "purpose": _purposeController.text,
      "notes": _notesController.text,
    };
    setState(() {
      _isLoading = true;
    });

    final response = await apiService.postData("requestforappointmentMobile/", data);
    int status = response['status'];
    String message = response['message'];
    if (status == 200 || status == 201) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text('Appointment Booked Successfully! A meeting link will be sent  as soon as the doctor confirms the Apppointment!!'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyRoutes.homeRoute),
              child: Text('OK!'),
            ),
          ],
        ),
      );
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyRoutes.homeRoute),
              child: Text('OK!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _purposeController,
                  decoration: InputDecoration(labelText: "Purpose of Appointemnt"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _notesController,
                  decoration:
                  InputDecoration(labelText: "Notes (If any)"),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _requestforappointment,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blueColor),
                  child: Text(
                    "Book Appointment",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
