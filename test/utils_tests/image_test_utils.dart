import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:transparent_image/transparent_image.dart';

import 'image_test_utils.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<HttpClient>(returnNullOnMissingStub: true),
    MockSpec<HttpClientRequest>(returnNullOnMissingStub: true),
    MockSpec<HttpClientResponse>(returnNullOnMissingStub: true),
    MockSpec<HttpHeaders>(returnNullOnMissingStub: true),
  ],
)
R provideMockedNetworkImages<R>(R Function() body, {List<int>? imageBytes}) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createMockImageHttpClient(_, imageBytes),
  );
}

// Returns a mock HTTP client that responds with an image to all requests.
MockHttpClient _createMockImageHttpClient(
    SecurityContext? _, List<int>? imageBytes) {
  final client = MockHttpClient();
  final request = MockHttpClientRequest();
  final response = MockHttpClientResponse();
  final headers = MockHttpHeaders();

  when(client.getUrl(any))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));
  when(request.headers).thenReturn(headers);
  when(request.close())
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(response.contentLength).thenReturn(kTransparentImage.length);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(
    any,
    cancelOnError: anyNamed('cancelOnError'),
    onDone: anyNamed('onDone'),
    onError: anyNamed('onError'),
  )).thenAnswer((Invocation invocation) {
    final void Function(List<int>) onData = invocation.positionalArguments[0];
    final void Function() onDone = invocation.namedArguments[#onDone];
    final void Function(Object, [StackTrace]) onError =
        invocation.namedArguments[#onError];
    final bool cancelOnError = invocation.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(
            <List<int>>[imageBytes ?? kTransparentImage])
        .listen(onData,
            onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  });

  return client;
}
