final Map<String, dynamic> mockNotification = {
  'id': '1',
  'type': 'notifications',
  'attributes': {
    'recipient_type': 'User',
    'recipient_id': 1,
    'type': 'StarNotification',
    'read_at': null,
    'created_at': '2023-01-01T00:00:00.000Z',
    'updated_at': '2023-01-01T00:00:00.000Z',
    'unread': true,
    'params': {
      'user': {
        'id': 1,
        'name': 'Test User',
        'email': 'test@circuitverse.org',
        'admin': false,
        'subscribed': false,
      },
      'project': {
        'id': 1,
        'author_id': 1,
        'project_access_type': 'Public',
        'name': 'Test Circuit',
        'project_submission': false,
        'description': 'Test description',
        'slug': 'test-circuit',
        'view': 10,
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-01T00:00:00.000Z',
        'image_preview': {'url': 'https://circuitverse.org/preview.png'},
      },
    },
  },
};

final Map<String, dynamic> mockNotifications = {
  'data': [
    mockNotification,
    {
      'id': '2',
      'type': 'notifications',
      'attributes': {
        'recipient_type': 'User',
        'recipient_id': 1,
        'type': 'ForkNotification',
        'read_at': '2023-01-02T00:00:00.000Z',
        'created_at': '2023-01-02T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
        'unread': false,
        'params': {
          'user': {
            'id': 2,
            'name': 'Another User',
            'email': 'another@circuitverse.org',
            'admin': false,
            'subscribed': false,
          },
          'project': {
            'id': 2,
            'author_id': 1,
            'project_access_type': 'Public',
            'name': 'Forked Circuit',
            'project_submission': false,
            'description': 'Forked description',
            'slug': 'forked-circuit',
            'view': 5,
            'created_at': '2023-01-02T00:00:00.000Z',
            'updated_at': '2023-01-02T00:00:00.000Z',
            'image_preview': null,
          },
        },
      },
    },
  ],
};
