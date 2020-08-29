import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_projects.dart';
import '../setup/test_helpers.dart';

void main() {
  group('ProjectsApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _projects = Projects.fromJson(mockProjects);
    var _project = Project.fromJson(mockProject);

    group('getPublicProjects -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProjects), 200)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.getPublicProjects()).toString(),
            _projects.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _projectsApi.getPublicProjects(), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('getUserProjects -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProjects), 200)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.getUserProjects('1')).toString(),
            _projects.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.getUserProjects('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_projectsApi.getUserProjects('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.getUserProjects('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('getFeaturedProjects -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProjects), 200)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.getFeaturedProjects()).toString(),
            _projects.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.getFeaturedProjects(),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.getFeaturedProjects(),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('getUserFavourites -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProjects), 200)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.getUserFavourites('1')).toString(),
            _projects.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.getUserFavourites('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.getUserFavourites('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('getProjectDetails -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProject), 200)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.getProjectDetails('1')).toString(),
            _project.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.getProjectDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_projectsApi.getProjectDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_projectsApi.getProjectDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.getProjectDetails('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('updateProject -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProject), 202)));
        var _projectsApi = HttpProjectsApi();

        expect(
            (await _projectsApi.updateProject('1',
                    name: 'Test Project',
                    projectAccessType: 'Public',
                    description: 'description',
                    tagsList: []))
                .toString(),
            _project.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw BadRequestException(''));
        expect(
            _projectsApi.updateProject('1',
                name: 'Test Project',
                projectAccessType: 'Public',
                description: 'description',
                tagsList: []),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
            _projectsApi.updateProject('1',
                name: 'Test Project',
                projectAccessType: 'Public',
                description: 'description',
                tagsList: []),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
            _projectsApi.updateProject('1',
                name: 'Test Project',
                projectAccessType: 'Public',
                description: 'description',
                tagsList: []),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
            _projectsApi.updateProject('1',
                name: 'Test Project',
                projectAccessType: 'Public',
                description: 'description',
                tagsList: []),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _projectsApi.updateProject('1',
                name: 'Test Project',
                projectAccessType: 'Public',
                description: 'description',
                tagsList: []),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteProject -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _projectsApi = HttpProjectsApi();

        expect(await _projectsApi.deleteProject('1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
            _projectsApi.deleteProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
            _projectsApi.deleteProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
            _projectsApi.deleteProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _projectsApi.deleteProject('1'), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('toggleStarProject -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"message": "toggled"}', 200)));
        var _projectsApi = HttpProjectsApi();

        expect(await _projectsApi.toggleStarProject('1'), 'toggled');
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.toggleStarProject('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_projectsApi.toggleStarProject('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.toggleStarProject('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('forkProject -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockProject), 204)));
        var _projectsApi = HttpProjectsApi();

        expect((await _projectsApi.forkProject('1')).toString(),
            _project.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _projectsApi = HttpProjectsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_projectsApi.forkProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_projectsApi.forkProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ConflictException(''));
        expect(_projectsApi.forkProject('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_projectsApi.forkProject('1'), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
