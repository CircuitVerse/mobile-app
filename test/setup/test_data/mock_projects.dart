Map<String, dynamic> mockProjects = {
  'data': [
    mockProject,
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
    'attributes': mockProjectAttributes,
    'relationships': mockProjectRelationships
  }
};

Map<String, dynamic> mockProjectAttributes = {
  'name': 'Test/Test',
  'project_access_type': 'Private',
  'created_at': '2020-08-15T15:23:03.007Z',
  'updated_at': '2020-08-15T15:23:03.007Z',
  'image_preview': mockImagePreview,
  'description': null,
  'view': 1,
  'tags': [mockTag],
  'is_starred': false,
  'author_name': 'Test',
  'stars_count': 0
};

Map<String, dynamic> mockProjectRelationships = {
  'author': mockAuthor,
  'collaborators': {'data': []}
};

Map<String, dynamic> mockImagePreview = {'url': '/img/default.png'};

Map<String, dynamic> mockAuthor = {
  'data': {'id': '1', 'type': 'author'}
};

Map<String, dynamic> mockTag = {
  'id': 1,
  'name': 'test',
  'created_at': '2020-08-15T15:23:03.007Z',
  'updated_at': '2020-08-15T15:23:03.007Z'
};
