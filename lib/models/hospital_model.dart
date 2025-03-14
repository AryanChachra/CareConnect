class HospitalModel {
  static List<Item> items = [];

  Item getById(int id) =>
      items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final String name;
  final String address;
  final String details;
  final String image;

  Item(
      {required this.id,
      required this.name,
      required this.address,
      required this.details,
      required this.image});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map["id"],
        name: map["hospital_name"],
        address: map["hospital_address"],
        details: map["hospital_details"],
        image: map["hospital_image"]);
  }

  toMap() =>{
    "id":id,
    "hospital_name":name,
    "hospital_address":address,
    "hospital_details": details,
    "hospital_image":image,
  };
}
