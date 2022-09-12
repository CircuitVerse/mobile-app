class User {
  factory User.fromJson(Map<String, dynamic> json) => User(
        data: Data.fromJson(json['data']),
      );

  User({required this.data});
  Data data;

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class Data {
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        type: json['type'],
        attributes: UserAttributes.fromJson(json['attributes']),
      );

  Data({
    required this.id,
    required this.type,
    required this.attributes,
  });
  String id;
  String? type;
  UserAttributes attributes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'attributes': attributes.toJson(),
      };
}

class UserAttributes {
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
        profilePicture: json['profile_picture'],
        educationalInstitute: json['educational_institute'],
      );

  UserAttributes({
    this.name,
    required this.email,
    required this.subscribed,
    this.createdAt,
    this.updatedAt,
    required this.admin,
    this.country,
    this.profilePicture,
    this.educationalInstitute,
  });
  String? name;
  String? email;
  bool subscribed;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profilePicture;
  bool admin;
  dynamic country;
  dynamic educationalInstitute;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'subscribed': subscribed,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'admin': admin,
        'country': country,
        'profile_picture': profilePicture,
        'educational_institute': educationalInstitute,
      };
}
