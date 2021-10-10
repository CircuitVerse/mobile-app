import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/add_collaborator_response.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/collaborators_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_add_collaborators_response.dart';
import '../setup/test_data/mock_collaborators.dart';
import '../setup/test_helpers.dart';

void main() {
  group('CollaboratorsApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _collaborators = Collaborators.fromJson(mockCollaborators);
    var _addCollaboratorsResponse =
        AddCollaboratorsResponse.fromJson(mockAddCollaboratorsResponse);

    group('fetchProjectCollaborators -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockCollaborators), 200)));
        var _collaboratorsApi = HttpCollaboratorsApi();

        expect(
            (await _collaboratorsApi.fetchProjectCollaborators('1')).toString(),
            _collaborators.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _collaboratorsApi = HttpCollaboratorsApi();

        ApiUtils.client = MockClient(((_) => throw UnauthorizedException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.fetchProjectCollaborators('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.fetchProjectCollaborators('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.fetchProjectCollaborators('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('addCollaborators -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(
            Response(jsonEncode(mockAddCollaboratorsResponse), 201)));
        var _collaboratorsApi = HttpCollaboratorsApi();

        expect((await _collaboratorsApi.addCollaborators('1', '')).toString(),
            _addCollaboratorsResponse.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _collaboratorsApi = HttpCollaboratorsApi();

        ApiUtils.client = MockClient(((_) => throw UnauthorizedException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.addCollaborators('1', ''),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.addCollaborators('1', ''),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.addCollaborators('1', ''),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteCollaborator -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _collaboratorsApi = HttpCollaboratorsApi();

        expect(await _collaboratorsApi.deleteCollaborator('1', '1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _collaboratorsApi = HttpCollaboratorsApi();

        ApiUtils.client = MockClient(((_) => throw UnauthorizedException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.deleteCollaborator('1', '1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.deleteCollaborator('1', '1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')) as Future<Response> Function(Request));
        expect(_collaboratorsApi.deleteCollaborator('1', '1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
