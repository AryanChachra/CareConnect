import 'package:CareConnect/models/hospital_model.dart';
import 'package:CareConnect/utils/routes.dart';
import 'package:CareConnect/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:CareConnect/widgets/appbar.dart';
import 'package:CareConnect/widgets/bottom_appbar.dart';
import 'package:CareConnect/widgets/drawer.dart';
import 'package:CareConnect/widgets/floating_action_button.dart';
import 'package:CareConnect/services/api_service.dart';

class HospitalDetails extends StatefulWidget {
  const HospitalDetails({super.key});

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  final ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      var hospitalData = await apiService.getData("viewhospital");
      HospitalModel.items =
          List.from(hospitalData).map((item) => Item.fromMap(item)).toList();
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
              if (!isLoading && HospitalModel.items.isNotEmpty)
                Expanded(child:HospitalList(),)
              else if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Center(
                  child: Text("No hospitals found."),
                )
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
          "Hospitals Near You",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: MyTheme.blueColor
          ),
        ),
      ],
    );
  }
}

class HospitalList extends StatelessWidget {
  const HospitalList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: HospitalModel.items.length,
      itemBuilder: (context, index) {
        final catalog = HospitalModel.items[index];
        return HospitalItem(catalog: catalog);
      },
    );
  }
}

class HospitalItem extends StatelessWidget {
  final Item catalog;
  const HospitalItem({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: (Colors.grey.a * 0.5)),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          HospitalImage(image: catalog.image),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  catalog.name,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.blueColor,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  catalog.address,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.bedRoute, arguments: catalog.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blueColor,
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 19.0, vertical: 8.0),
                    ),
                    child: Text(
                      "Book a Bed",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HospitalImage extends StatelessWidget {
  final String image;
  const HospitalImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(image, fit: BoxFit.cover),
      ),
    );
  }
}
