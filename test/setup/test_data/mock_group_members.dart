Map<String, dynamic> mockGroupMembers = {
  'data': [
    {
      'id': '1',
      'type': 'group_member',
      'attributes': {
        'group_id': 1,
        'user_id': 1,
        'created_at': '2020-08-15T14:36:38.228Z',
        'updated_at': '2020-08-15T14:36:38.228Z',
        'name': 'Test User',
        'email': 'test@test.com'
      },
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

Map<String, dynamic> mockGroupMember = {
  'id': '1',
  'type': 'group_member',
  'attributes': mockGroupMemberAttributes
};

Map<String, dynamic> mockGroupMemberAttributes = {
  'group_id': 1,
  'user_id': 1,
  'created_at': '2020-08-15T14:36:38.228Z',
  'updated_at': '2020-08-15T14:36:38.228Z',
  'name': 'Test User',
  'email': 'test@test.com'
};
