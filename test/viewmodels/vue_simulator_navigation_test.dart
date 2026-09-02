import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/viewmodels/simulator/vue_simulator_navigation.dart';

// Unhandled navigations render a browser error page inside the simulator, so
// every path the Vue app uses is covered here.
void main() {
  VueNavigation resolveLocal(String path) => resolveVueNavigation(
    Uri.parse('http://localhost:8123$path'),
    isLocal: true,
  );

  group('stays in the webview', () {
    test('the bundle entry point', () {
      expect(resolveLocal('/'), isA<LoadInWebView>());
      expect(resolveLocal('/index.html'), isA<LoadInWebView>());
    });

    test('proxied API calls', () {
      expect(resolveLocal('/api/v1/me'), isA<LoadInWebView>());
    });
  });

  group('reopens saved projects in place', () {
    test('the path the app redirects to after a save', () {
      expect(
        resolveLocal('/simulatorvue/edit/2006856'),
        const OpenProject('2006856'),
      );
    });

    test('leaves the v0 simulator path alone', () {
      // /simulator/ is the old simulator, which this build does not carry.
      expect(resolveLocal('/simulator/edit/42'), isA<ReturnToApp>());
    });

    test('carries a version query along', () {
      expect(
        resolveLocal('/simulatorvue/edit/42?simver=v1'),
        const OpenProject('42'),
      );
    });

    test('absorbs the self-redirect setup.js fires after loading a project', () {
      // setup.js fires this after loading any project, using the name not the id.
      expect(
        resolveLocal('/simulatorvue/edit/My%20Adder?simver=v1'),
        isA<StayOnCurrentPage>(),
      );
      expect(resolveLocal('/simulatorvue/edit/test'), isA<StayOnCurrentPage>());
    });

    test('does not open a numeric id meant for another version', () {
      expect(
        resolveLocal('/simulatorvue/edit/42?simver=v2'),
        isA<ReturnToApp>(),
      );
    });

    test('returns to the app for a version this build cannot open', () {
      expect(
        resolveLocal('/simulatorvue/edit/test?simver=v2'),
        isA<ReturnToApp>(),
      );
      expect(resolveLocal('/simulator/edit/test'), isA<ReturnToApp>());
    });

    test('refuses a non-numeric id rather than injecting it as script', () {
      // The id gets interpolated into injected JavaScript.
      expect(
        resolveLocal('/simulatorvue/edit/1";alert(1);//'),
        isNot(isA<OpenProject>()),
      );
    });
  });

  group('hands website routes to native screens', () {
    test('profile carries the user id', () {
      expect(
        resolveLocal('/users/409461'),
        const OpenAppScreen(VueAppScreen.profile, argument: '409461'),
      );
    });

    test('groups', () {
      expect(
        resolveLocal('/users/409461/groups'),
        const OpenAppScreen(VueAppScreen.groups),
      );
    });

    test('sign in', () {
      expect(
        resolveLocal('/users/sign_in'),
        const OpenAppScreen(VueAppScreen.login),
      );
    });
  });

  group('never hands off to a browser', () {
    test("a project page opens the app's own project screen", () {
      // Where the Vue app goes after a save or a details update.
      expect(
        resolveLocal('/users/409461/projects/2006856'),
        const OpenProjectPage('2006856'),
      );
      expect(
        resolveLocal('/users/409461/projects/2006856/edit'),
        const OpenProjectPage('2006856'),
      );
    });

    test('a route with no in-app screen returns to the app', () {
      expect(
        resolveLocal('/users/409461/notifications'),
        const ReturnToApp('/users/409461/notifications'),
      );
    });

    test('off-origin links are refused, staying in the simulator', () {
      expect(
        resolveVueNavigation(
          Uri.parse('https://learn.circuitverse.org/docs'),
          isLocal: false,
        ),
        isA<StayOnCurrentPage>(),
      );
    });
  });
}
