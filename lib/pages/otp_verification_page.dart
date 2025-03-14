import 'package:CareConnect/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? storedOTP = await _storage.read(key: 'otp');
    String? enteredOTP = _otpController.text.trim();
    if (storedOTP != null && storedOTP == enteredOTP) {
      _storage.delete(key: 'otp');
      String? authToken = await _storage.read(key: 'token');
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      String? userType = args['userType'];

      final data = {"token": authToken, "userType": userType};
      final response = await apiService.postData("verify_token_Mobile/", data);
      int status = response['status'];
      if (status == 200 || status == 201) {
        Navigator.pushNamed(context, MyRoutes.checkusersigninRoute);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "OTP Verification failed. PLease try again";
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(_errorMessage!),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _otpController.clear();
                          });
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid OTP";
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(_errorMessage!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _otpController.clear();
                    });
                  },
                  child: Text('OK'))
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: MyTheme.blueColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to your email",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
              maxLength: 5,
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blueColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 40.0),
                    ),
                    child: Text("Verify",
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  ),
          ],
        ),
      ),
    );
  }
}
