import 'package:CareConnect/models/appointment_model.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final ApiService apiService = ApiService();
  final _storage = FlutterSecureStorage();
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    String? id = await _storage.read(key: 'UserId');
    loadData(id);
  }

  loadData(id) async {
    final data = {'userId': id, 'userRole':'Doctor'};
    try {
      var appointmentData = await apiService.postData("appointment_status_mobile/",data);
      AppointmentModel.items = List.from(appointmentData['message']).map((item) => Item.fromMap(item)).toList();
    } catch (e) {
      setState(() {
        isLoading = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  approveAppointment(id) async{
    final data = {'AppointmentId': id};
    var response = await apiService.postData("generatelink/",data);
    String meeting = response['meeting_link'];
    if(meeting != ""){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment Approved')),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Approving Appointment')),
      );
    }
  }

  rejectAppointment(id) async{
    final data = {'AppointmentId': id};
    var response = await apiService.postData("Rejectappointment/",data);
    String meeting = response['meeting_link'];
    if(meeting != ""){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment Rejected')),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Rejecting Appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalogHeader(),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
              // Center(
              // child: Text("No beds found for this hospital."),
                Expanded(child: AppointmentList(approveAppointment: approveAppointment, rejectAppointment: rejectAppointment),),
              // )
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}

class CatalogHeader extends StatelessWidget {
  const CatalogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Appointment Requests",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: MyTheme.blueColor,
          ),
        ),
      ],
    );
  }
}

class AppointmentList extends StatelessWidget {
  final Function(int) approveAppointment;
  final Function(int) rejectAppointment;
  const AppointmentList({super.key, required this.approveAppointment, required this.rejectAppointment});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AppointmentModel.items.length,
      itemBuilder: (context, index) {
        final catalog = AppointmentModel.items[index];
        return AppointmentItem(catalog: catalog,approveAppointment: approveAppointment,rejectAppointment: rejectAppointment,);
      },
    );
  }
}

class AppointmentItem extends StatelessWidget {
  // final List<Item> beds;
  final Item catalog;
  final Function(int) approveAppointment;
  final Function(int) rejectAppointment;
  const AppointmentItem({super.key, required this.catalog, required this.approveAppointment, required this.rejectAppointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Slot Time: ${catalog.bookedSlot}",
                      style: TextStyle(
                        color: MyTheme.blueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Date: ${catalog.appointmentDate}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => rejectAppointment(catalog.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          MyTheme.blueColor, // For button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => approveAppointment(catalog.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          MyTheme.blueColor, // For button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Approve",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
