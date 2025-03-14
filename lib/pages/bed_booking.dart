import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/services/api_service.dart';

class BedBooking extends StatefulWidget {
  const BedBooking({super.key});

  @override
  State<BedBooking> createState() => _BedBookingState();
}

class _BedBookingState extends State<BedBooking> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _pastsurgeriesController = TextEditingController();
  final TextEditingController _insurancepolicyController = TextEditingController();
  final TextEditingController _policynumberController = TextEditingController();
  final TextEditingController _specialreqController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  String? _gender;
  bool _isLoading = false;
  int? id;
  String? bedId;
  String? name;
  String? wardNumber;
  String? bedNumber;
  String? bedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      id = args["id"];
      bedId = args["bedId"];
      name = args["name"];
      wardNumber = args["wardNumber"];
      bedNumber = args["bedNumber"];
      bedType = args["bedType"];
    }
  }


  final List<String> _genderOptions = ['Male', 'Female', 'Others'];

  Future<void> _requestforbed() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "id": id,
      "Hospital_name": name,
      "Bed_id": bedId,
      "Ward_number": wardNumber,
      "Room_number": bedNumber,
      "Disease": _diseaseController.text,
      "Bed_type": bedType,
      "patient_name": _patientNameController.text,
      "patient_gender": _gender,
      "patient_age": _patientageController.text,
      "address": _addressController.text,
      "mobile_number": _mobileController.text,
      "current_medication": _medicationController.text,
      "allergies": _allergiesController.text,
      "past_surgeries": _pastsurgeriesController.text,
      "insurance_policy": _insurancepolicyController.text,
      "Policy_number": _policynumberController.text,
      "special_request": _specialreqController.text,
    };
    setState(() {
      _isLoading = true;
    });

    final response = await apiService.postData("request_for_beds/", data);
    int status = response['status'];
    String message = response['message'];
    if (status == 200 || status == 201) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text('Bed Requested Successfully!'),
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
                  controller: _patientNameController,
                  decoration: InputDecoration(labelText: "Patient's Name"),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your full name" : null,
                ),
                TextFormField(
                  controller: _patientageController,
                  decoration:
                  InputDecoration(labelText: "Enter Patient's Age"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty
                      ? "Please enter your age"
                      : null,
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: "Gender"),
                  items: _genderOptions
                      .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? "Please select your gender" : null,
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: "Mobile Number"),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your Mobile Number" : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Address"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _diseaseController,
                  decoration: InputDecoration(labelText: "Medical Records"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _medicationController,
                  decoration: InputDecoration(labelText: "Current Medications (If any)"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _allergiesController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Allergies (if any)"),
                ),
                TextFormField(
                  controller: _pastsurgeriesController,
                  decoration: InputDecoration(labelText: "Past Surgeries (if any)"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _insurancepolicyController,
                  decoration: InputDecoration(labelText: "Insurance Policy (If any)"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _policynumberController,
                  decoration: InputDecoration(labelText: "Policy Number"),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: _specialreqController,
                  decoration: InputDecoration(labelText: "Special Request (If any)"),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _requestforbed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blueColor),
                  child: Text(
                    "Book Bed",
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
