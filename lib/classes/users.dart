import 'dart:convert';

class Users {
  String? location;
  String? name;
  String? phonenumber;
  String? email;

  Users({
    this.location,
    this.name,
    this.phonenumber,
    this.email,
  });

  static Users fromJson(Map<String, dynamic> json) => Users(
        name: json['name'],
        phonenumber: json['phonenumber'],
        location: json['location'],
        email: json['Email'],
      );

  Users copyWith({
    String? location,
    String? name,
    String? phonenumber,
    String? email,
    String? image,
  }) {
    return Users(
      location: location ?? this.location,
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'name': name,
      'phonenumber': phonenumber,
      'email': email,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      location: map['location'],
      name: map['name'],
      phonenumber: map['phonenumber'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory Users.fromJson(String source) => Users.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Users(location: $location, name: $name, phonenumber: $phonenumber, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Users &&
        other.location == location &&
        other.name == name &&
        other.phonenumber == phonenumber &&
        other.email == email;
  }

  @override
  int get hashCode {
    return location.hashCode ^
        name.hashCode ^
        phonenumber.hashCode ^
        email.hashCode;
  }
}
