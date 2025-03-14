class SlotModel{
  static List<Item> items = [];

  Item getById(int id) => items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final int slotHour;
  final String slotType;
  final String slotDuration;


  Item({
    required this.id,
    required this.slotHour,
    required this.slotType,
    required this.slotDuration,
  });

  factory Item.fromMap(Map<String, dynamic> map){
    return Item(
      id: map["id"],
      slotHour: map["slot_hour"],
      slotType: map["slot_type"],
      slotDuration: map["slot_duration"],
    );
  }

  toMap() =>
      {
        "id": id,
        "slot_hour": slotHour,
        "slot_type": slotType,
        "slot_duration": slotDuration,
      };
}