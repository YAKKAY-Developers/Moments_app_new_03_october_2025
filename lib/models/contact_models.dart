class ContactInfo {
  final String name;
  final String phoneNumber;

  ContactInfo({
    required this.name,
    required this.phoneNumber,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

class ContactInvitation {
  final String name;
  final String phoneNumber;
  final bool isRegistered;
  final Map<String, dynamic>? userData;

  ContactInvitation({
    required this.name,
    required this.phoneNumber,
    required this.isRegistered,
    this.userData,
  });

  factory ContactInvitation.fromJson(Map<String, dynamic> json) {
    return ContactInvitation(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isRegistered: json['isRegistered'] ?? false,
      userData: json['userData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'isRegistered': isRegistered,
      'userData': userData,
    };
  }
}
