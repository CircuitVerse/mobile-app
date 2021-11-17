import 'package:mobile_app/models/links.dart';

class Collaborators {
  List<Collaborator> data;
  Links links;
  Collaborators({
    this.data,
    this.links,
  });


  factory Collaborators.fromJson(Map<String, dynamic> json) => Collaborators(
        data: List<Collaborator>.from(
            json['data'].map((x) => Collaborator.fromJson(x))),
        links: Links.fromJson(json['links']),
      );
}

class Collaborator {
  String id;
  String type;
  CollaboratorAttributes attributes;
  Collaborator({
    this.id,
    this.type,
    this.attributes,
  });


  factory Collaborator.fromJson(Map<String, dynamic> json) => Collaborator(
        id: json['id'],
        type: json['type'],
        attributes: CollaboratorAttributes.fromJson(json['attributes']),
      );
}

class CollaboratorAttributes {
  String name;
  CollaboratorAttributes({
    this.name,
  });


  factory CollaboratorAttributes.fromJson(Map<String, dynamic> json) =>
      CollaboratorAttributes(
        name: json['name'],
      );
}
