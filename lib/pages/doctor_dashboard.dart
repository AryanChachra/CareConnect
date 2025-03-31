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
    String? id = await _storage.read(key: 'userId');
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

  Future<bool> approveAppointment(int id) async {
    final data = {'AppointmentId': id};
    try {
      var response = await apiService.postData("generatelink/", data);
      String meeting = response['meeting_link'];

      if (meeting.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment Approved')),
        );
        return true;  // Indicating success
      } else {
        throw Exception("Invalid meeting link");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Approving Appointment')),
      );
      return false;  // Indicating failure
    }
  }

  Future<bool> rejectAppointment(int id) async {
    final data = {'AppointmentId': id};
    try {
      var response = await apiService.postData("Rejectappointment/", data);
      String message = response['message'];

      if (message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment Rejected')),
        );
        return true;  // Indicating success
      } else {
        throw Exception("Invalid rejection message");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Rejecting Appointment')),
      );
      return false;  // Indicating failure
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
  final Future<bool> Function(int) approveAppointment;
  final Future<bool> Function(int) rejectAppointment;
  const AppointmentList({super.key, required this.approveAppointment, required this.rejectAppointment,});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AppointmentModel.items.length,
      itemBuilder: (context, index) {
        final catalog = AppointmentModel.items[index];
        return AppointmentItem(catalog: catalog, approveAppointment: approveAppointment, rejectAppointment: rejectAppointment);
      },
    );
  }
}

class AppointmentItem extends StatefulWidget {
  final Item catalog;
  final Future<bool> Function(int) approveAppointment;
  final Future<bool> Function(int) rejectAppointment;

  const AppointmentItem({
    super.key,
    required this.catalog,
    required this.approveAppointment,
    required this.rejectAppointment,
  });

  @override
  _AppointmentItemState createState() => _AppointmentItemState();
}

class _AppointmentItemState extends State<AppointmentItem> {
  bool isLoading = false;
  bool isApproved = false;
  bool isRejected = false;
  Color loaderColor = Colors.green;

  void handleApprove() async {
    setState(() {
      isLoading = true;
      isApproved = false;
      isRejected = false;
      loaderColor = Colors.green;
    });
    var response = await widget.approveAppointment(widget.catalog.id);

    if (response) {
      setState(() {
        widget.catalog.status = "Approve";
        isLoading = false;
        isApproved = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleReject() async {
    setState(() {
      isLoading = true;
      isApproved = false;
      isRejected = false;
      loaderColor = Colors.red;
    });
    var response = await widget.rejectAppointment(widget.catalog.id);

    if (response) {
      setState(() {
        widget.catalog.status = "Reject";
        isLoading = false;
        isRejected = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

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
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Slot Time: ${widget.catalog.bookedSlot}",
                    style: TextStyle(
                      color: MyTheme.blueColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Date: ${widget.catalog.appointmentDate}"),
                  Text("Status: ${widget.catalog.status}"),
                  SizedBox(height: 5),
                  if (widget.catalog.status == "Pending")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!isLoading)
                          ElevatedButton(
                            onPressed: handleReject,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text("Reject", style: TextStyle(color: Colors.white)),
                          ),

                        isLoading
                            ? CircularProgressIndicator(color: loaderColor)
                            : ElevatedButton(
                          onPressed: handleApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Approve", style: TextStyle(color: Colors.white)),
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