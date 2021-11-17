import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/models/projects.dart';

class Assignments {
  List<Assignment> data;
  Links links;
  Assignments({
    this.data,
    this.links,
  });


  factory Assignments.fromJson(Map<String, dynamic> json) => Assignments(
        data: List<Assignment>.from(
          json['data'].map((x) => Assignment.fromJson(x)),
        ),
        links: Links.fromJson(json['links']),
      );
}

class Assignment {
  String id;
  String type;
  AssignmentAttributes attributes;
  List<Project> projects;
  List<Grade> grades;
  Assignment({
    this.id,
    this.type,
    this.attributes,
    this.projects,
    this.grades,
  });


  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json['id'] ?? json['data']['id'],
        type: json['type'] ?? json['data']['type'],
        attributes: AssignmentAttributes.fromJson(
            json['attributes'] ?? json['data']['attributes']),
        projects: json['included'] != null
            ? List<Project>.from(
                json['included']
                    ?.where((e) => e['type'] == 'project')
                    ?.map((e) => Project.fromJson(e)),
              )
            : null,
        grades: json['included'] != null
            ? List<Grade>.from(
                json['included']
                    ?.where((e) => e['type'] == 'grade')
                    ?.map((e) => Grade.fromJson(e)),
              )
            : null,
      );

  bool get canBeGraded =>
      attributes.gradingScale != 'no_scale' &&
      !attributes.gradesFinalized &&
      attributes.deadline.isBefore(DateTime.now());

  String get gradingScaleHint {
    switch (attributes.gradingScale) {
      case 'letter':
        return 'Assignment can be graded with any of the letters A/B/C/D/E/F';
        break;
      case 'percent':
        return 'Assignment can be graded from 0 - 100 %';
        break;
      case 'custom':
        return 'Assignment can be graded with any of custom grades';
        break;
      default:
        return '';
    }
  }
}

class AssignmentAttributes {
  String name;
  DateTime deadline;
  String description;
  bool hasMentorAccess;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  int currentUserProjectId;
  String gradingScale;
  bool gradesFinalized;
  String restrictions;
  AssignmentAttributes({
    this.name,
    this.deadline,
    this.description,
    this.hasMentorAccess,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.currentUserProjectId,
    this.gradingScale,
    this.gradesFinalized,
    this.restrictions,
  });


  factory AssignmentAttributes.fromJson(Map<String, dynamic> json) =>
      AssignmentAttributes(
        name: json['name'],
        deadline: DateTime.parse(json['deadline']).toLocal(),
        description: json['description'],
        hasMentorAccess: json['has_mentor_access'],
        createdAt: DateTime.parse(json['created_at']).toLocal(),
        updatedAt: DateTime.parse(json['updated_at']).toLocal(),
        status: json['status'],
        currentUserProjectId: json['current_user_project_id'],
        gradingScale: json['grading_scale'],
        gradesFinalized: json['grades_finalized'],
        restrictions: json['restrictions'],
      );
}
