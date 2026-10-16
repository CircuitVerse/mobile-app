import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/viewmodels/simulator/vue_simulator_navigation.dart';

// Unhandled navigations render a browser error page inside the simulator, so
// every path the Vue app uses is covered here.
void main() {
  VueNavigation resolveLocal(String path) => resolveVueNavigation(
    Uri.parse('http://localhost:8123$path'),
    isLocal: true,
  );

  Matcher opensProject(String id) =>
      isA<OpenProject>().having((d) => d.projectId, 'projectId', id);

  Matcher opensScreen(VueAppScreen screen, [String? argument]) =>
      isA<OpenAppScreen>()
          .having((d) => d.screen, 'screen', screen)
          .having((d) => d.argument, 'argument', argument);

  test('loads the bundle and proxied API calls in the webview', () {
    expect(resolveLocal('/'), isA<LoadInWebView>());
    expect(resolveLocal('/index.html'), isA<LoadInWebView>());
    expect(resolveLocal('/api/v1/me'), isA<LoadInWebView>());
  });

  test('reopens a saved project in place', () {
    expect(resolveLocal('/simulatorvue/edit/2006856'), opensProject('2006856'));
    // Where the project details dialog goes on cancel.
    expect(resolveLocal('/simulator/edit/42'), opensProject('42'));
  });

  test('refuses a non-numeric id rather than handing it to the page', () {
    expect(
      resolveLocal('/simulatorvue/edit/1";alert(1);//'),
      isA<ReturnToApp>(),
    );
  });

  test('hands website routes to native screens', () {
    expect(
      resolveLocal('/users/409461'),
      opensScreen(VueAppScreen.profile, '409461'),
    );
    expect(
      resolveLocal('/users/409461/groups'),
      opensScreen(VueAppScreen.groups),
    );
    expect(resolveLocal('/users/sign_in'), opensScreen(VueAppScreen.login));
    expect(resolveLocal('/users/sign_up'), opensScreen(VueAppScreen.login));
    // Where the Vue app goes after a save or a details update.
    expect(
      resolveLocal('/users/409461/projects/2006856/edit'),
      opensScreen(VueAppScreen.project, '2006856'),
    );
  });

  test('returns to the app for a route with no in-app screen', () {
    expect(resolveLocal('/users/409461/notifications'), isA<ReturnToApp>());
    expect(resolveLocal('/users'), isA<ReturnToApp>());
  });

  test('refuses off-origin links, staying in the simulator', () {
    expect(
      resolveVueNavigation(
        Uri.parse('https://learn.circuitverse.org/docs'),
        isLocal: false,
      ),
      isA<StayOnCurrentPage>(),
    );
  });
}
