class Grade {
  String id;
  String type;
  GradeAttributes attributes;
  GradeRelationships relationships;
  Grade({
    this.id,
    this.type,
    this.attributes,
    this.relationships,
  });


  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
        id: json['id'],
        type: json['type'],
        attributes: GradeAttributes.fromJson(json['attributes']),
        relationships: GradeRelationships.fromJson(json['relationships']),
      );
}

class GradeAttributes {
  String grade;
  dynamic remarks;
  DateTime createdAt;
  DateTime updatedAt;
  GradeAttributes({
    this.grade,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });


  factory GradeAttributes.fromJson(Map<String, dynamic> json) =>
      GradeAttributes(
        grade: json['grade'],
        remarks: json['remarks'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class GradeRelationships {
  GradedProject project;
  GradeRelationships({
    this.project,
  });


  factory GradeRelationships.fromJson(Map<String, dynamic> json) =>
      GradeRelationships(
        project: GradedProject.fromJson(json['project']),
      );
}

class GradedProject {
  GradedProjectData data;
  GradedProject({
    this.data,
  });


  factory GradedProject.fromJson(Map<String, dynamic> json) => GradedProject(
        data: GradedProjectData.fromJson(json['data']),
      );
}

class GradedProjectData {
  String id;
  String type;
  GradedProjectData({
    this.id,
    this.type,
  });


  factory GradedProjectData.fromJson(Map<String, dynamic> json) =>
      GradedProjectData(
        id: json['id'],
        type: json['type'],
      );
}
