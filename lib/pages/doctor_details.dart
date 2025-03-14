import 'package:CareConnect/models/doctor_model.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  final ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      var doctorData = await apiService.getData("Doctorlist");
      DoctorModel.items = List.from(doctorData['Data']).map((item) => Item.fromMap(item)).toList();
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
                Expanded(child: BedList(),),
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
          "Available Doctors",
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

class BedList extends StatelessWidget {
  const BedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: DoctorModel.items.length,
      itemBuilder: (context, index) {
        final catalog = DoctorModel.items[index];
        return BedItem(catalog: catalog);
      },
    );
  }
}

class BedItem extends StatelessWidget {
  // final List<Item> beds;
  final Item catalog;
  const BedItem({super.key, required this.catalog});

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
                      "Name: ${catalog.fullName}",
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
                  // Text(
                  //   "Specialization: ${catalog.Specialization}\n Experience: ${catalog.Year_of_experience} years",
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Specialization: ${catalog.specialization}\nExperience: ${catalog.yearOfExperience} years\nLocation: ${catalog.city}"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, MyRoutes.appointmentRoute,arguments: {
                            "id": catalog.id,
                            "full_name": catalog.fullName,
                            "Specialization": catalog.specialization,
                            "experience": catalog.yearOfExperience,
                            "hospital_name": catalog.city,
                          },
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          MyTheme.blueColor, // For button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "View Details",
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
