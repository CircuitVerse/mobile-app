import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/services/local_storage_service.dart';

class Projects {
  Projects({
    this.data,
    this.links,
  });

  List<Project> data;
  Links links;

  factory Projects.fromJson(Map<String, dynamic> json) => Projects(
        data: List<Project>.from(json['data'].map((x) => Project.fromJson(x))),
        links: Links.fromJson(json['links']),
      );
}

class Project {
  Project({
    this.id,
    this.type,
    this.attributes,
    this.relationships,
    this.collaborators,
  });

  String id;
  String type;
  ProjectAttributes attributes;
  ProjectRelationships relationships;
  List<Collaborator> collaborators;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] ?? json['data']['id'],
        type: json['type'] ?? json['data']['type'],
        attributes: ProjectAttributes.fromJson(
            json['attributes'] ?? json['data']['attributes']),
        relationships: ProjectRelationships.fromJson(
            json['relationships'] ?? json['data']['relationships']),
        collaborators: json['included'] != null
            ? List<Collaborator>.from(
                json['included']
                    ?.where((e) => e['type'] == 'user')
                    ?.map((e) => Collaborator.fromJson(e)),
              )
            : null,
      );

  bool get hasAuthorAccess {
    var currentUser = locator<LocalStorageService>().currentUser;

    if (currentUser != null) {
      return relationships.author.data.id == currentUser.data.id;
    }

    return false;
  }
}

class ProjectAttributes {
  ProjectAttributes({
    this.name,
    this.projectAccessType,
    this.createdAt,
    this.updatedAt,
    this.imagePreview,
    this.description,
    this.view,
    this.tags,
    this.isStarred,
    this.authorName,
    this.starsCount,
  });

  String name;
  String projectAccessType;
  DateTime createdAt;
  DateTime updatedAt;
  ImagePreview imagePreview;
  String description;
  int view;
  List<Tag> tags;
  bool isStarred;
  String authorName;
  int starsCount;

  factory ProjectAttributes.fromJson(Map<String, dynamic> json) =>
      ProjectAttributes(
        name: json['name'],
        projectAccessType: json['project_access_type'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        imagePreview: ImagePreview.fromJson(json['image_preview']),
        description: json['description'],
        view: json['view'],
        tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
        isStarred: json['is_starred'],
        authorName: json['author_name'],
        starsCount: json['stars_count'],
      );
}

class ImagePreview {
  ImagePreview({
    this.url,
  });

  String url;

  factory ImagePreview.fromJson(Map<String, dynamic> json) => ImagePreview(
        url: json['url'],
      );
}

class ProjectRelationships {
  ProjectRelationships({
    this.author,
  });

  Author author;

  factory ProjectRelationships.fromJson(Map<String, dynamic> json) =>
      ProjectRelationships(
        author: Author.fromJson(json['author']),
      );
}

class Author {
  Author({
    this.data,
  });

  AuthorData data;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        data: AuthorData.fromJson(json['data']),
      );
}

class AuthorData {
  AuthorData({
    this.id,
    this.type,
  });

  String id;
  String type;

  factory AuthorData.fromJson(Map<String, dynamic> json) => AuthorData(
        id: json['id'],
        type: json['type'],
      );
}

class Tag {
  Tag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}
