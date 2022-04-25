import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/services/local_storage_service.dart';

class Projects {
  factory Projects.fromJson(Map<String, dynamic> json) => Projects(
        data: List<Project>.from(json['data'].map((x) => Project.fromJson(x))),
        links: Links.fromJson(json['links']),
      );

  Projects({
    required this.data,
    required this.links,
  });
  List<Project> data;
  Links links;
}

class Project {
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
  Project({
    required this.id,
    required this.type,
    required this.attributes,
    required this.relationships,
    this.collaborators,
  });
  String id;
  String type;
  ProjectAttributes attributes;
  ProjectRelationships relationships;
  List<Collaborator>? collaborators;

  Project copyWith({
    String? id,
    String? type,
    ProjectAttributes? attributes,
    ProjectRelationships? relationships,
    List<Collaborator>? collaborators,
  }) {
    return Project(
      id: id ?? this.id,
      type: type ?? this.type,
      attributes: attributes ?? this.attributes,
      relationships: relationships ?? this.relationships,
      collaborators: collaborators ?? this.collaborators,
    );
  }

  bool get hasAuthorAccess {
    var currentUser = locator<LocalStorageService>().currentUser;

    if (currentUser != null) {
      return relationships.author.data.id == currentUser.data.id;
    }

    return false;
  }
}

class ProjectAttributes {
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
        isStarred: json['is_starred'] ?? false,
        authorName: json['author_name'],
        starsCount: json['stars_count'],
      );
  ProjectAttributes({
    required this.name,
    required this.projectAccessType,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePreview,
    this.description,
    required this.view,
    required this.tags,
    required this.isStarred,
    required this.authorName,
    required this.starsCount,
  });

  String name;
  String projectAccessType;
  DateTime createdAt;
  DateTime updatedAt;
  ImagePreview imagePreview;
  String? description;
  int view;
  List<Tag> tags;
  bool isStarred;
  String authorName;
  int starsCount;

  ProjectAttributes copyWith({
    String? name,
    String? projectAccessType,
    DateTime? createdAt,
    DateTime? updatedAt,
    ImagePreview? imagePreview,
    String? description,
    int? view,
    List<Tag>? tags,
    bool? isStarred,
    String? authorName,
    int? starsCount,
  }) {
    return ProjectAttributes(
      name: name ?? this.name,
      projectAccessType: projectAccessType ?? this.projectAccessType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePreview: imagePreview ?? this.imagePreview,
      view: view ?? this.view,
      tags: tags ?? this.tags,
      authorName: authorName ?? this.authorName,
      starsCount: starsCount ?? this.starsCount,
      description: description ?? this.description,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}

class ImagePreview {
  factory ImagePreview.fromJson(Map<String, dynamic> json) => ImagePreview(
        url: json['url'],
      );
  ImagePreview({
    required this.url,
  });

  String url;
}

class ProjectRelationships {
  factory ProjectRelationships.fromJson(Map<String, dynamic> json) =>
      ProjectRelationships(
        author: Author.fromJson(json['author']),
      );

  ProjectRelationships({
    required this.author,
  });
  Author author;
}

class Author {
  factory Author.fromJson(Map<String, dynamic> json) => Author(
        data: AuthorData.fromJson(json['data']),
      );

  Author({
    required this.data,
  });
  AuthorData data;
}

class AuthorData {
  factory AuthorData.fromJson(Map<String, dynamic> json) => AuthorData(
        id: json['id'],
        type: json['type'],
      );

  AuthorData({
    required this.id,
    required this.type,
  });
  String id;
  String type;
}

class Tag {
  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
}
