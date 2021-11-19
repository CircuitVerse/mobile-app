import 'package:mobile_app/models/links.dart';

class Collaborators {
  factory Collaborators.fromJson(Map<String, dynamic> json) => Collaborators(
        data: List<Collaborator>.from(
            json['data'].map((x) => Collaborator.fromJson(x))),
        links: Links.fromJson(json['links']),
      );
  
  Collaborators({
    this.data,
    this.links,
  });
  List<Collaborator> data;
  Links links;


}

class Collaborator {
  factory Collaborator.fromJson(Map<String, dynamic> json) => Collaborator(
        id: json['id'],
        type: json['type'],
        attributes: CollaboratorAttributes.fromJson(json['attributes']),
      );
  
  Collaborator({
    this.id,
    this.type,
    this.attributes,
  });
  String id;
  String type;
  CollaboratorAttributes attributes;


}

class CollaboratorAttributes {
  factory CollaboratorAttributes.fromJson(Map<String, dynamic> json) =>
      CollaboratorAttributes(
        name: json['name'],
      );
 
  CollaboratorAttributes({
    this.name,
  });
  String name;


}
