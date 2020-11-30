Map<String, dynamic> mockGroups = {
  'data': [
    {
      'id': '1',
      'type': 'group',
      'attributes': {
        'member_count': 1,
        'mentor_name': 'Test User',
        'name': 'Test Group',
        'mentor_id': 1,
        'created_at': '2020-08-15T05:49:56.433Z',
        'updated_at': '2020-08-15T17:21:13.813Z'
      },
      'relationships': {
        'group_members': {
          'data': [
            {'id': '1', 'type': 'group_member'},
          ]
        },
        'assignments': {
          'data': [
            {'id': '1', 'type': 'assignment'},
          ]
        }
      },
    },
  ],
  'links': {
    'self': '{url}?page[number]=1',
    'first': '{url}?page[number]=1',
    'prev': null,
    'next': '{url}?page[number]=2',
    'last': '{url}?page[number]=1'
  }
};

Map<String, dynamic> mockGroup = {
  'data': {
    'id': '1',
    'type': 'group',
    'attributes': mockGroupAttributes,
    'relationships': {
      'group_members': {
        'data': [
          {'id': '1', 'type': 'group_member'},
        ]
      },
      'assignments': {
        'data': [
          {'id': '1', 'type': 'assignment'},
        ]
      }
    }
  },
  'included': [
    {
      'id': '1',
      'type': 'assignment',
      'attributes': {
        'name': 'Test Assignment',
        'deadline': '2020-08-15T15:23:00.000Z',
        'description': 'description',
        'status': 'open',
        'restrictions': '[]',
        'has_mentor_access': true,
        'current_user_project_id': null,
        'created_at': '2020-08-15T15:00:30.423Z',
        'updated_at': '2020-08-15T15:23:03.018Z',
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
    },
    {
      'id': '1',
      'type': 'group_member',
      'attributes': {
        'group_id': 1,
        'user_id': 1,
        'created_at': '2020-08-19T14:36:38.228Z',
        'updated_at': '2020-08-19T14:36:38.228Z',
        'name': 'Test User',
        'email': 'test@test.com'
      }
    }
  ]
};

Map<String, dynamic> mockGroupAttributes = {
  'member_count': 1,
  'mentor_name': 'Test User',
  'name': 'Test Group',
  'mentor_id': 1,
  'created_at': '2020-08-15T05:49:56.433Z',
  'updated_at': '2020-08-15T17:21:13.813Z'
};
