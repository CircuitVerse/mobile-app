class Grade {
  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
        id: json['id'],
        type: json['type'],
        attributes: GradeAttributes.fromJson(json['attributes']),
        relationships: GradeRelationships.fromJson(json['relationships']),
      );
  
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

}

class GradeAttributes {
  factory GradeAttributes.fromJson(Map<String, dynamic> json) =>
      GradeAttributes(
        grade: json['grade'],
        remarks: json['remarks'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
  
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

}

class GradeRelationships {
  factory GradeRelationships.fromJson(Map<String, dynamic> json) =>
      GradeRelationships(
        project: GradedProject.fromJson(json['project']),
      );
  
  GradeRelationships({
    this.project,
  });

  GradedProject project;

}

class GradedProject {
  factory GradedProject.fromJson(Map<String, dynamic> json) => GradedProject(
        data: GradedProjectData.fromJson(json['data']),
      );
  GradedProject({
    this.data,
  });

  GradedProjectData data;

}

class GradedProjectData {
  factory GradedProjectData.fromJson(Map<String, dynamic> json) =>
      GradedProjectData(
        id: json['id'],
        type: json['type'],
      );
 
  GradedProjectData({
    this.id,
    this.type,
  });

  String id;
  String type;

}
