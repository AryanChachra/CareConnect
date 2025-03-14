import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:CareConnect/services/api_service.dart';

class DoctorSignIn extends StatefulWidget {
  const DoctorSignIn({super.key});

  @override
  State<DoctorSignIn> createState() => _DoctorSignInState();
}

class _DoctorSignInState extends State<DoctorSignIn> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  bool isLoggedIn = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? storedToken = await _storage.read(key: 'auth_token');
    if (storedToken != null) {
      setState(() {
        isLoggedIn = true;
        token = storedToken;
      });
    }
  }

  Future<void> _login() async {
    final email = _usernameController.text;
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Email and Password')),
      );
      return;
    }
    final data = {"username": email, "passcode": password};
    final response = await apiService.postData("Doctor_login/", data);
    int status = response['status'];
    String message = response['message'];
    if (status == 200 || status == 201) {
      String authToken = response['Token'];
      String userType = response['userRole'];
      String userId = response['user_id'].toString();
      await _storage.write(key: 'auth_token', value: authToken);
      await _storage.write(key: 'userType', value: userType);
      await _storage.write(key: 'userId', value: userId);
      setState(() {
        isLoggedIn = true;
        token = authToken;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    } else if (message == 'user is not verified') {
      final data = {"userEmail": email};
      final regenerate =
          await apiService.postData("GeneratenewOtpMobile/", data);
      int status = regenerate['status'];
      if (status == 200 || status == 201) {
        String otp = regenerate['Otp'];
        String authToken = regenerate['Token'];
        await _storage.write(key: 'otp', value: otp.toString());
        await _storage.write(key: 'token', value: authToken);
        await _storage.write(key: 'userType', value: 'Doctor');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email not verified"),
            content: Text('An Otp has been sent to your Email!!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, MyRoutes.verifyotpRoute,
                    arguments: {"userType": "Doctor"}),
                child: Text('OK!'),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Email is required!';
                //   }
                // },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                keyboardType: TextInputType.text,
                obscureText: true,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Email is required!';
                //   }
                // },
              ),
              SizedBox(
                height: 16,
              ),
              // ElevatedButton(onPressed: _login, child: Text('Login')),
              isLoggedIn
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.blueColor),
                      child: Text(
                        "Login",
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
                    Navigator.pushNamed(context, MyRoutes.checkuserRoute);
                  },
                  child: Text('Don\'t have an account?')),
            ],
          ),
        ),
      ),
    );
  }
}
