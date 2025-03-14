import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fathersNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String? _gender;
  String? _state;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Others'];
  final List<String> _stateOptions = ['Andhra Pradesh','Arunachal Pradesh','Assam','Bihar','Chhattisgarh','Goa','Gujarat','Haryana','Himachal Pradesh','Jharkhand','Karnataka','Kerala','Madhya Pradesh','Maharashtra','Manipur','Meghalaya','Mizoram','Nagaland','Odisha','Punjab','Rajasthan','Sikkim','Tamil Nadu','Telangana','Tripura','Uttar Pradesh','Uttarakhand','West Bengal','Andaman and Nicobar Islands','Chandigarh',' Dadra and Nagar Haveli and Daman and Diu','Lakshadweep','Delhi','Puducherry',];


  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "full_name": _fullNameController.text,
      "fathers_name": _fathersNameController.text,
      "gender": _gender,
      "email": _emailController.text,
      "code": _codeController.text,
      "address1": _address1Controller.text,
      "address2": _address2Controller.text,
      "city": _cityController.text,
      "state": _state,
      "zip": _zipController.text,
      "SourceSystem":"Mobile"
    };
    setState(() {
      _isLoading = true;
    });

    final response = await apiService.postData("register/", data);
    int status = response['status'];
    String message = response['message'];
    if (status == 200 || status == 201) {
      String otp = response['Otp'];
      String authToken = response['Token'];
      await _storage.write(key: 'otp', value: otp.toString());
      await _storage.write(key: 'token', value: authToken);
      await _storage.write(key: 'userType', value: 'Doctor');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text('Registration Successful! PLease Verify Your email'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyRoutes.verifyotpRoute,arguments: {"userType":"User"}),
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
                  Navigator.pushNamed(context, MyRoutes.landingRoute),
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
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: "Full Name"),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your full name" : null,
                ),
                TextFormField(
                  controller: _fathersNameController,
                  decoration:
                      InputDecoration(labelText: "Father's/Husband's Name"),
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isEmpty
                      ? "Please enter your father's/husband's name"
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
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your Email" : null,
                ),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(labelText: "Set Password"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Password cannot be empty" : null,
                ),
                TextFormField(
                  controller: _address1Controller,
                  decoration: InputDecoration(labelText: "Address Line 1"),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your address" : null,
                ),
                TextFormField(
                  controller: _address2Controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Address Line 2"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your address" : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "City"),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your city" : null,
                ),
                DropdownButtonFormField<String>(
                  value: _state,
                  decoration: InputDecoration(labelText: "State"),
                  items: _stateOptions
                      .map((state) => DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _state = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select your state" : null,
                ),
                TextFormField(
                  controller: _zipController,
                  decoration: InputDecoration(labelText: "Zip Code"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your Zip Code" : null,
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.blueColor),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 16.0,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.checkusersigninRoute);
                    },
                    child: Text('Already have an account?')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
