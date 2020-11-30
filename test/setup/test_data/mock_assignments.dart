Map<String, dynamic> mockAssignments = {
  'data': [
    {
      'id': '1',
      'type': 'assignment',
      'attributes': {
        'name': 'Test',
        'deadline': '2020-08-15T15:23:00.000Z',
        'description': 'description',
        'status': 'open',
        'restrictions': '[]',
        'has_mentor_access': true,
        'current_user_project_id': null,
        'created_at': '2020-08-19T15:00:30.423Z',
        'updated_at': '2020-08-20T15:23:03.018Z',
        'grading_scale': 'letter',
        'grades_finalized': false
      },
      'relationships': {
        'projects': {
          'data': [
            {'id': '1', 'type': 'project'}
          ]
        },
        'grades': {
          'data': [
            {'id': '1', 'type': 'grade'}
          ]
        }
      }
    }
  ],
  'links': {
    'self': '{url}?page[number]=1',
    'first': '{url}?page[number]=1',
    'prev': null,
    'next': '{url}?page[number]=2',
    'last': '{url}?page[number]=1'
  }
};

Map<String, dynamic> mockAssignment = {
  'data': {
    'id': '1',
    'type': 'assignment',
    'attributes': mockAssignmentAttributes,
    'relationships': {
      'projects': {
        'data': [
          {'id': '1', 'type': 'project'}
        ]
      },
      'grades': {
        'data': [
          {'id': '1', 'type': 'grade'}
        ]
      }
    }
  },
  'included': [
    {
      'id': '1',
      'type': 'grade',
      'attributes': {
        'grade': 'A',
        'remarks': 'Good',
        'created_at': '2020-08-20T15:23:50.073Z',
        'updated_at': '2020-08-20T15:23:50.073Z'
      },
      'relationships': {
        'project': {
          'data': {'id': '1', 'type': 'project'}
        }
      }
    },
    {
      'id': '1',
      'type': 'project',
      'attributes': {
        'name': 'Test/Test',
        'project_access_type': 'Private',
        'created_at': '2020-08-15T15:23:03.007Z',
        'updated_at': '2020-08-15T15:23:03.007Z',
        'image_preview': {'url': '/img/default.png'},
        'description': null,
        'view': 1,
        'tags': [],
        'is_starred': false,
        'author_name': 'Test',
        'stars_count': 0
      },
      'relationships': {
        'author': {
          'data': {'id': '1', 'type': 'author'}
        },
        'collaborators': {'data': []}
      }
    }
  ]
};

Map<String, dynamic> mockAssignmentAttributes = {
  'name': 'Test',
  'deadline': '2020-08-15T15:23:00.000Z',
  'description': 'description',
  'status': 'open',
  'restrictions': '[]',
  'has_mentor_access': true,
  'current_user_project_id': null,
  'created_at': '2020-08-19T15:00:30.423Z',
  'updated_at': '2020-08-20T15:23:03.018Z',
  'grading_scale': 'letter',
  'grades_finalized': false
};
