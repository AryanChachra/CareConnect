import 'package:CareConnect/models/slot_model.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentViewing extends StatefulWidget {
  const AppointmentViewing({super.key});

  @override
  AppointmentViewingState createState() => AppointmentViewingState();
}

class AppointmentViewingState extends State<AppointmentViewing> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? doctorDetails;
  String _selectedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // Default: Today’s date
  List<String> availableSlots = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          doctorDetails = args;
        });
        fetchSlots(_selectedDate); // Fetch slots for today's date
      }
    });
  }

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No past dates
      lastDate: DateTime.now().add(Duration(days: 4)), // Limit to 30 days
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> fetchSlots(String date) async {
    final data = {
      "Doctor_id": doctorDetails!['id'],
      "slot_date": date.toString(),
    };
    var slotData =
        await apiService.postData("Available_slot_For_Doctor/", data);
    setState(() {
      SlotModel.items = slotData['data']
          .entries
          .expand((entry) => entry.value as List)
          .map<Item>((item) => Item.fromMap(item))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (doctorDetails == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Doctor Details")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Doctor's Name: ${doctorDetails!['full_name']}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Specialization: ${doctorDetails!['Specialization']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Experience: ${doctorDetails!['experience']} years",
                      style: TextStyle(fontSize: 18)),
                  Text("Location: ${doctorDetails!['city']}",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Date: $_selectedDate",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: MyTheme.blueColor,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Pick Date",
                    style: TextStyle(
                        color: MyTheme.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => fetchSlots(_selectedDate),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "View Slots",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Available Slots Section
            Text("Available Slots:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            SlotModel.items.isEmpty
                ? Center(child: Text("No slots available for this date."))
                : Expanded(
                    child: ListView.builder(
                      itemCount: SlotModel.items.length,
                      itemBuilder: (context, index) {
                        final slot = SlotModel.items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text("Slot Time: ${slot.slotDuration}",
                                style: TextStyle(fontSize: 16)),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  MyRoutes.bookappointmentRoute,
                                  arguments: {
                                    "doctorid": doctorDetails!['id'],
                                    "doctorName": doctorDetails!['full_name'],
                                    "bookedSlot": slot.slotDuration,
                                    "date": _selectedDate,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Book",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}
