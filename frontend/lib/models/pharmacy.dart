class Pharmacy {
  final int id;
  final String address;
  final String workingHours;

  Pharmacy(
      {required this.id, required this.address, required this.workingHours});

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      address: json['address'],
      workingHours: json['working_hours'],
    );
  }
}