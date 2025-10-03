// class UserModel {
//   final String userToken;
//   final String? name;
//   final String? email;
//   final String? phoneNumber;
//   final String? photo;
//   final String? address;
//   final int? age;
//   final DateTime? createdAt;

//   UserModel({
//     required this.userToken,
//     this.name,
//     this.email,
//     this.phoneNumber,
//     this.photo,
//     this.address,
//     this.age,
//     this.createdAt,
//   });

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       userToken: map['user_token'] ?? '',
//       name: map['name'],
//       email: map['email'],
//       phoneNumber: map['phone_number'],
//       photo: map['photo'],
//       address: map['address'],
//       age: map['age'] != null ? int.tryParse(map['age'].toString()) : null,
//       createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'user_token': userToken,
//       'name': name,
//       'email': email,
//       'phone_number': phoneNumber,
//       'photo': photo,
//       'address': address,
//       'age': age,
//       'createdAt': createdAt?.toIso8601String(),
//     };
//   }

//   UserModel copyWith({
//     String? userToken,
//     String? name,
//     String? email,
//     String? phoneNumber,
//     String? photo,
//     String? address,
//     int? age,
//     DateTime? createdAt,
//   }) {
//     return UserModel(
//       userToken: userToken ?? this.userToken,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       photo: photo ?? this.photo,
//       address: address ?? this.address,
//       age: age ?? this.age,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

class UserModel {
  final String userToken;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photo;
  final String? address;
  final int? age;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userToken,
    this.name,
    this.email,
    this.phoneNumber,
    this.photo,
    this.address,
    this.age,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userToken: map['user_token'] ?? '',
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      photo: map['photo'],
      address: map['address'],
      age: map['age'] != null ? int.tryParse(map['age'].toString()) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_token': userToken,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'photo': photo,
      'address': address,
      'age': age,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? userToken,
    String? name,
    String? email,
    String? phoneNumber,
    String? photo,
    String? address,
    int? age,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userToken: userToken ?? this.userToken,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      address: address ?? this.address,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
}