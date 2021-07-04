import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('IbPageViewModel Test -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('fetchPageData -', () {
      test('When called & service returns success response', () async {
        var _mockIbEngineApi = getAndRegisterIbEngineServiceMock();
        when(_mockIbEngineApi.getPageData(id: '')).thenAnswer(
          (_) => Future.value(
            IbPageData(
              id: '',
              pageUrl: '',
              title: 'Home',
              content: [],
            ),
          ),
        );

        var _model = IbPageViewModel();
        await _model.fetchPageData(id: '');

        // verify call to IbEngineService was made
        verify(_mockIbEngineApi.getPageData(id: ''));
        expect(_model.stateFor(_model.IB_FETCH_PAGE_DATA), ViewState.Success);

        // verify returned data
        expect(_model.pageData.id, '');
        expect(_model.pageData.title, 'Home');
        expect(_model.pageData.content.length, 0);
      });

      test('When called & service returns error', () async {
        var _mockIbEngineApi = getAndRegisterIbEngineServiceMock();
        when(_mockIbEngineApi.getPageData(id: ''))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = IbPageViewModel();
        await _model.fetchPageData(id: '');

        // verify call to IbEngineService was made
        verify(_mockIbEngineApi.getPageData(id: ''));
        expect(_model.stateFor(_model.IB_FETCH_PAGE_DATA), ViewState.Error);
      });
    });
  });
}
