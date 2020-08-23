class Grade {
  Grade({
    this.id,
    this.type,
    this.attributes,
    this.relationships,
  });

  String id;
  String type;
  GradeAttributes attributes;
  GradeRelationships relationships;

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
        id: json['id'],
        type: json['type'],
        attributes: GradeAttributes.fromJson(json['attributes']),
        relationships: GradeRelationships.fromJson(json['relationships']),
      );
}

class GradeAttributes {
  GradeAttributes({
    this.grade,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  String grade;
  dynamic remarks;
  DateTime createdAt;
  DateTime updatedAt;

  factory GradeAttributes.fromJson(Map<String, dynamic> json) =>
      GradeAttributes(
        grade: json['grade'],
        remarks: json['remarks'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class GradeRelationships {
  GradeRelationships({
    this.project,
  });

  GradedProject project;

  factory GradeRelationships.fromJson(Map<String, dynamic> json) =>
      GradeRelationships(
        project: GradedProject.fromJson(json['project']),
      );
}

class GradedProject {
  GradedProject({
    this.data,
  });

  GradedProjectData data;

  factory GradedProject.fromJson(Map<String, dynamic> json) => GradedProject(
        data: GradedProjectData.fromJson(json['data']),
      );
}

class GradedProjectData {
  GradedProjectData({
    this.id,
    this.type,
  });

  String id;
  String type;

  factory GradedProjectData.fromJson(Map<String, dynamic> json) =>
      GradedProjectData(
        id: json['id'],
        type: json['type'],
      );
}
