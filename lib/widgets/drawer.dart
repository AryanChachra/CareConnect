import 'package:CareConnect/services/api_service.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  String? name;
  String? email;

  @override
  void initState(){
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async{
    String? token = await _storage.read(key: 'auth_token');
    String? userType = await _storage.read(key: 'userType');

    final data = {
      "token": token,
      "userRole": userType
    };
    try{
      final response = await apiService.postData("profile_data/",data);
      final profileData = response['message'][0];
      setState(() {
        name=profileData['full_name'];
        email=profileData['email'];
      });
    } catch(e){
      setState(() {
        name = "Name";
        email = "Email";
      });
    }
  }

  Future<void> _logout() async{
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'userType');
    await _storage.delete(key: 'otp');
    await _storage.delete(key: 'UserId');
    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.landingRoute, (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                ),
                SizedBox(
                  width: 255,
                  child: ClipOval(
                    child: Image.asset("assets/images/CareConnect.png",fit: BoxFit.fill,),

                  ),
                ),
                SizedBox(height: 120),
                CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person,
                      size: 45, color: MyTheme.lightblueColor),
                ),
                SizedBox(height: 16),
                Text(
                  name ?? "Name",
                  style: TextStyle(
                    color: MyTheme.blueColor,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  email ?? 'Email',
                  style: TextStyle(
                    color: MyTheme.blueColor,
                    fontSize: 14,
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 3,
                  color: MyTheme.blueColor,

                ),
              ],
            ),
          ),
          FilledButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(MyTheme.blueColor),
            ),
            onPressed: _logout,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20), // Adding some space at the bottom
        ],
      ),
    );
  }
}
