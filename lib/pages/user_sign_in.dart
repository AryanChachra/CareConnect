import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:CareConnect/services/api_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    final data = {"username": email, "password": password};
    final response = await apiService.postData("login_user/", data);
    int status = response['status'];
    String message = response['message'];
    if (status == 200 || status == 201) {
      String authToken = response['Token'];
      String userId = response['user_id'].toString();
      String userName = response['username'];
      String userType = response['UserRole'];
      await _storage.write(key: 'auth_token', value: authToken);
      await _storage.write(key: 'userType', value: userType);
      await _storage.write(key: 'userName', value: userName);
      await _storage.write(key: 'userId', value: userId);

      setState(() {
        isLoggedIn = true;
        token = authToken;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));
      Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
    } else if (status == 401) {
      final data = {"userEmail": email};
      final regenerate =
          await apiService.postData("GeneratenewOtpMobile/", data);
      int status = regenerate['status'];
      if (status == 200 || status == 201) {
        String otp = regenerate['Otp'];
        String authToken = regenerate['Token'];
        await _storage.write(key: 'otp', value: otp.toString());
        await _storage.write(key: 'token', value: authToken);
        await _storage.write(key: 'userType', value: 'User');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email not verified"),
            content: Text('An Otp has been sent to your Email!!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, MyRoutes.verifyotpRoute,
                    arguments: {"userType": "User"}),
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
