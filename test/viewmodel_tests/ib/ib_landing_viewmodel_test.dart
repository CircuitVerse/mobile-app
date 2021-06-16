import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('IbLandingViewModel Test -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('fetchChapters -', () {
      test('When called & service returns success response', () async {
        var _mockIbEngineApi = getAndRegisterIbEngineServiceMock();
        when(_mockIbEngineApi.getChapters()).thenAnswer(
          (_) => Future.value([
            IbChapter(
              id: 'index.md',
              value: 'Home',
              navOrder: '1',
            ),
          ]),
        );

        var _model = IbLandingViewModel();
        await _model.fetchChapters();

        // verify call to IbEngineService was made
        verify(_mockIbEngineApi.getChapters());
        expect(_model.stateFor(_model.IB_FETCH_CHAPTERS), ViewState.Success);

        // verify returned chapters
        expect(_model.chapters.length, 1);
      });

      test('When called & service returns error', () async {
        var _mockIbEngineApi = getAndRegisterIbEngineServiceMock();
        when(_mockIbEngineApi.getChapters())
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = IbLandingViewModel();
        await _model.fetchChapters();

        // verify call to IbEngineService was made
        verify(_mockIbEngineApi.getChapters());
        expect(_model.stateFor(_model.IB_FETCH_CHAPTERS), ViewState.Error);
      });
    });
  });
}
