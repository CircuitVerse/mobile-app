import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/models/projects.dart';

import '../setup/test_data/mock_projects.dart';

void main() {
  group('Projects Test -', () {
    test('Projects fromJson', () {
      var _projects = Projects.fromJson(mockProjects);

      expect(_projects, isInstanceOf<Projects>());
      expect(_projects.data, isInstanceOf<List<Project>>());
      expect(_projects.data.length, 1);

      expect(_projects.links, isInstanceOf<Links>());
    });

    test('Project fromJson', () {
      var _project = Project.fromJson(mockProject);

      expect(_project, isInstanceOf<Project>());
      expect(_project.id, '1');
      expect(_project.type, 'project');

      expect(_project.attributes, isInstanceOf<ProjectAttributes>());
      expect(_project.collaborators, null);
      expect(_project.relationships, isInstanceOf<ProjectRelationships>());
    });

    test('ProjectAttributes fromJson', () {
      var _projectAttributes =
          ProjectAttributes.fromJson(mockProjectAttributes);

      expect(_projectAttributes, isInstanceOf<ProjectAttributes>());
      expect(_projectAttributes.name, 'Test/Test');
      expect(_projectAttributes.projectAccessType, 'Private');
      expect(_projectAttributes.createdAt,
          DateTime.parse('2020-08-15T15:23:03.007Z'));
      expect(_projectAttributes.updatedAt,
          DateTime.parse('2020-08-15T15:23:03.007Z'));
      expect(_projectAttributes.imagePreview, isInstanceOf<ImagePreview>());
      expect(_projectAttributes.description, null);
      expect(_projectAttributes.view, 1);
      expect(_projectAttributes.tags, isInstanceOf<List<Tag>>());
      expect(_projectAttributes.isStarred, false);
      expect(_projectAttributes.authorName, 'Test');
      expect(_projectAttributes.starsCount, 0);
    });

    test('ImagePreview fromJson', () {
      var _imagePreview = ImagePreview.fromJson(mockImagePreview);

      expect(_imagePreview, isInstanceOf<ImagePreview>());
      expect(_imagePreview.url, '/img/default.png');
    });

    test('ProjectRelationships fromJson', () {
      var _projectRelationships =
          ProjectRelationships.fromJson(mockProjectRelationships);

      expect(_projectRelationships, isInstanceOf<ProjectRelationships>());
      expect(_projectRelationships.author, isInstanceOf<Author>());
    });

    test('Author fromJson', () {
      var _author = Author.fromJson(mockAuthor);

      expect(_author, isInstanceOf<Author>());
      expect(_author.data, isInstanceOf<AuthorData>());
    });

    test('AuthorData fromJson', () {
      var _authorData = AuthorData.fromJson(mockAuthor['data']);

      expect(_authorData, isInstanceOf<AuthorData>());
      expect(_authorData.id, '1');
      expect(_authorData.type, 'author');
    });

    test('Tag fromJson', () {
      var _tag = Tag.fromJson(mockTag);

      expect(_tag, isInstanceOf<Tag>());
      expect(_tag.id, 1);
      expect(_tag.name, 'test');
      expect(_tag.createdAt, DateTime.parse('2020-08-15T15:23:03.007Z'));
      expect(_tag.updatedAt, DateTime.parse('2020-08-15T15:23:03.007Z'));
    });
  });
}
