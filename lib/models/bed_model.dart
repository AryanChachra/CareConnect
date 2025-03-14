class BedModel {
  static List<Item> items = [];

  Item getById(int id) =>
      items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final String name;
  final String bedId;
  final String wardNumber;
  final String roomNumber;
  final String bedType;

  Item(
      {required this.id,
        required this.name,
        required this.bedId,
        required this.wardNumber,
        required this.roomNumber,
        required this.bedType,});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map["id"],
        name: map["Hospital_name"],
        bedId: map['Bed_id'],
        wardNumber:map['Ward_number'],
        roomNumber:map['Room_number'],
        bedType: map['Bed_type']);

  }

  toMap() =>{
    "id":id,
    "Hospital_name":name,
    "Bed_id":bedId,
    "Ward_number": wardNumber,
    "Room_number": roomNumber,
    "Bed_type": bedType,
  };
}
