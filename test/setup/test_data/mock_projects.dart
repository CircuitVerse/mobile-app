Map<String, dynamic> mockProjects = {
  'data': [
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

Map<String, dynamic> mockProject = {
  'data': {
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
};
