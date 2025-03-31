class AppointmentModel {
  static List<Item> items = [];

  Item getById(int id) =>
      items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final String bookedSlot;
  final String appointmentDate;
  final String purpose;
  final String notes;
  String status;

  Item(
      {required this.id,
        required this.bookedSlot,
        required this.appointmentDate,
        required this.purpose,
        required this.notes,
        required this.status,});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map["id"],
        bookedSlot: map["booked_slot"],
        appointmentDate: map['appointment_date'],
        purpose:map['purpose'],
        notes:map['notes'],
        status: map['status']);

  }

  toMap() =>{
    "id":id,
    "booked_slot":bookedSlot,
    "appointment_date":appointmentDate,
    "purpose": purpose,
    "notes": notes,
    "Bed_type": status,
  };
}
