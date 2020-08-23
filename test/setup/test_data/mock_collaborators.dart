Map<String, dynamic> mockCollaborators = {
  'data': [
    {
      'id': '1',
      'type': 'user',
      'attributes': {
        'name': 'Test User',
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

Map<String, dynamic> mockCollaborator = {
  'id': '1',
  'type': 'user',
  'attributes': {
    'name': 'Test User',
  }
};
