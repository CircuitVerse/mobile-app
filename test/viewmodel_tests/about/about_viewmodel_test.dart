import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/about/about_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_contributors.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('AboutViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('fetchContributors -', () {
      test('When called & service returns success response', () async {
        var _mockContributorsApi = getAndRegisterContributorsApiMock();
        when(_mockContributorsApi.fetchContributors()).thenAnswer(
          (_) => Future.value(
            mockContributors
                .map((e) => CircuitVerseContributor.fromJson(e))
                .toList(),
          ),
        );

        var _model = AboutViewModel();
        await _model.fetchContributors();

        // verify call to fetchContributors was made
        verify(_mockContributorsApi.fetchContributors());
        expect(_model.stateFor(_model.fetchCONTRIBUTORS), ViewState.Success);

        // cvContributors was populated
        expect(_model.cvContributors.length, 3);
      });

      test('When called & service returns error', () async {
        var _mockContributorsApi = getAndRegisterContributorsApiMock();
        when(_mockContributorsApi.fetchContributors())
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = AboutViewModel();
        await _model.fetchContributors();

        // verify call to fetchContributors was made
        verify(_mockContributorsApi.fetchContributors());
        expect(_model.stateFor(_model.fetchCONTRIBUTORS), ViewState.Error);
      });
    });
  });
}
