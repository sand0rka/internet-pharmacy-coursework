class Prescription {
  final int id;
  final String issueDate;
  final String medicationName;

  Prescription({
    required this.id,
    required this.issueDate,
    required this.medicationName,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      issueDate: json['issue_date'],
      medicationName: json['medication_name'] ?? "Невідомий препарат",
    );
  }
}