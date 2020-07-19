import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({this.data});

  Data data;

  factory User.fromJson(Map<String, dynamic> json) => User(
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.type,
    this.attributes,
  });

  String id;
  String type;
  UserAttributes attributes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        type: json['type'],
        attributes: UserAttributes.fromJson(json['attributes']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'attributes': attributes.toJson(),
      };
}

class UserAttributes {
  UserAttributes({
    this.name,
    this.email,
    this.subscribed,
    this.createdAt,
    this.updatedAt,
    this.admin,
    this.country,
    this.educationalInstitute,
  });

  String name;
  String email;
  bool subscribed;
  DateTime createdAt;
  DateTime updatedAt;
  bool admin;
  dynamic country;
  dynamic educationalInstitute;

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
        name: json['name'],
        email: json['email'],
        subscribed: json['subscribed'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        admin: json['admin'],
        country: json['country'],
        educationalInstitute: json['educational_institute'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'subscribed': subscribed,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'admin': admin,
        'country': country,
        'educational_institute': educationalInstitute,
      };
}
