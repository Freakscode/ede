class ContactData {
  final String names;
  final String cellPhone;
  final String landline;
  final String email;

  const ContactData({
    required this.names,
    required this.cellPhone,
    required this.landline,
    required this.email,
  });

  ContactData copyWith({
    String? names,
    String? cellPhone,
    String? landline,
    String? email,
  }) {
    return ContactData(
      names: names ?? this.names,
      cellPhone: cellPhone ?? this.cellPhone,
      landline: landline ?? this.landline,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'cellPhone': cellPhone,
      'landline': landline,
      'email': email,
    };
  }

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      names: json['names'] ?? '',
      cellPhone: json['cellPhone'] ?? '',
      landline: json['landline'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ContactData(names: $names, cellPhone: $cellPhone, landline: $landline, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactData &&
        other.names == names &&
        other.cellPhone == cellPhone &&
        other.landline == landline &&
        other.email == email;
  }

  @override
  int get hashCode {
    return names.hashCode ^
        cellPhone.hashCode ^
        landline.hashCode ^
        email.hashCode;
  }
}
