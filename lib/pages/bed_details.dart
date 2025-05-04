import 'package:CareConnect/models/bed_model.dart';
import 'package:CareConnect/services/api_service.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';

class BedDetails extends StatefulWidget {
  const BedDetails({super.key});

  @override
  State<BedDetails> createState() => _BedDetailsState();
}

class _BedDetailsState extends State<BedDetails> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  int? hospitalid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hospitalid = ModalRoute.of(context)!.settings.arguments as int?;
    loadData(hospitalid);
  }

  loadData(id) async {
    final data = {'HospitalId': id.toString()};
    try {
      var bedData = await apiService.postData("viewBedByHospital/", data);
      BedModel.items =
          List.from(bedData['Data']).map((item) => Item.fromMap(item)).toList();
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
                Expanded(
                  child: BedList(),
                ),
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
        // "Select the Suitable Bed".text.xl5.bold.color(MyTheme.blueColor).make(),
        Text(
          "Select the Suitable Bed",
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
      itemCount: BedModel.items.length,
      itemBuilder: (context, index) {
        final catalog = BedModel.items[index];
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
                      "Hospital Name: ${catalog.name}",
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
                    "Bed Type: ${catalog.bedType}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bed Number: ${catalog.bedId}"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            MyRoutes.formRoute,
                            arguments: {
                              "id": catalog.id,
                              "bedId": catalog.bedId,
                              "name": catalog.name,
                              "wardNumber": catalog.wardNumber,
                              "bedNumber": catalog.roomNumber,
                              "bedType": catalog.bedType,
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
                          "Book Now",
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
