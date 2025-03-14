class DoctorModel{
  static List<Item> items = [];

  Item getById(int id) => items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final String fullName;
  final String specialization;
  final int yearOfExperience;
  final String city;


  Item({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.yearOfExperience,
    required this.city,

  });

  factory Item.fromMap(Map<String, dynamic> map){
    return Item(
      id: map["id"],
      fullName: map["full_name"],
      specialization: map["Specialization"],
      yearOfExperience: map["Year_of_experience"],
      city: map["city"],
    );
  }

  toMap() =>
      {
        "id": id,
        "full_name": fullName,
        "Specialization": specialization,
        "Year_of_experience": yearOfExperience,
        "city": city,
      };
}