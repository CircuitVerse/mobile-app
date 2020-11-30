Map<String, dynamic> mockGrade = {
  'data': {
    'id': '1',
    'type': 'grade',
    'attributes': mockGradeAttributes,
    'relationships': mockGradeRelationships,
  }
};

Map<String, dynamic> mockGradeAttributes = {
  'grade': 'A',
  'remarks': 'Good',
  'created_at': '2020-08-20T15:23:50.073Z',
  'updated_at': '2020-08-20T15:23:50.073Z'
};

Map<String, dynamic> mockGradeRelationships = {'project': mockGradedProject};

Map<String, dynamic> mockGradedProject = {'data': mockGradedProjectData};

Map<String, dynamic> mockGradedProjectData = {'id': '1', 'type': 'project'};
