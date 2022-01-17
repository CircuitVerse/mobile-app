import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class AuthOptionsViewModel extends BaseModel {
  // ViewState Keys
  final String fbOAUTH = 'fb_oauth';
  final String googleOAUTH = 'google_oauth';
  final String githubOAUTH = 'github_oauth';

  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  Future facebookAuth({bool isSignUp = false}) async {
    final result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        setStateFor(fbOAUTH, ViewState.Busy);

        try {
          // save token & current user to local storage..
          if (isSignUp) {
            _storage.token = await _userApi.oauthSignup(
              accessToken: result.accessToken!.token,
              provider: 'facebook',
            );
          } else {
            _storage.token = await _userApi.oauthLogin(
              accessToken: result.accessToken!.token,
              provider: 'facebook',
            );
          }

          _storage.currentUser = await _userApi.fetchCurrentUser();

          // update authentication status..
          _storage.isLoggedIn = true;

          // save authentication type to local storage..
          _storage.authType = AuthType.FACEBOOK;

          setStateFor(fbOAUTH, ViewState.Success);
        } on Failure catch (f) {
          setStateFor(fbOAUTH, ViewState.Error);
          setErrorMessageFor(fbOAUTH, f.message);
        }
        break;
      case LoginStatus.cancelled:
        setStateFor(fbOAUTH, ViewState.Error);
        setErrorMessageFor(fbOAUTH, 'Login Cancelled By User!');
        break;
      case LoginStatus.failed:
        setStateFor(fbOAUTH, ViewState.Error);
        setErrorMessageFor(fbOAUTH, 'Unable to authenticate!');
        break;
      case LoginStatus.operationInProgress:
        break;
    }
  }

  Future googleAuth({bool isSignUp = false}) async {
    var _googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      await _googleSignIn.signIn();
      var _googleSignInAuthentication =
          await _googleSignIn.currentUser!.authentication;

      setStateFor(googleOAUTH, ViewState.Busy);

      // save token & current user to local storage..
      if (isSignUp) {
        _storage.token = await _userApi.oauthSignup(
          accessToken: _googleSignInAuthentication.accessToken!,
          provider: 'google',
        );
      } else {
        _storage.token = await _userApi.oauthLogin(
          accessToken: _googleSignInAuthentication.accessToken!,
          provider: 'google',
        );
      }

      _storage.currentUser = await _userApi.fetchCurrentUser();

      // update authentication status..
      _storage.isLoggedIn = true;

      // save authentication type to local storage..
      _storage.authType = AuthType.GOOGLE;

      setStateFor(googleOAUTH, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(googleOAUTH, ViewState.Error);
      setErrorMessageFor(googleOAUTH, f.message);
    } catch (e) {
      setStateFor(googleOAUTH, ViewState.Error);
      setErrorMessageFor(googleOAUTH, 'Unable to authenticate!');
    }
  }

  Future githubAuth({bool isSignUp = false}) async {
    OAuth2Client _client = GitHubOAuth2Client(
      redirectUri: EnvironmentConfig.GITHUB_OAUTH_REDIRECT_URI,
      customUriScheme: 'circuitverse',
    );

    var _oauthHelper = OAuth2Helper(
      _client,
      clientId: EnvironmentConfig.GITHUB_OAUTH_CLIENT_ID,
      clientSecret: EnvironmentConfig.GITHUB_OAUTH_CLIENT_SECRET,
      scopes: ['read:user'],
    );

    try {
      var _accessTokenResponse = await _oauthHelper.getToken();

      setStateFor(githubOAUTH, ViewState.Busy);

      // save token & current user to local storage..
      if (isSignUp) {
        _storage.token = await _userApi.oauthSignup(
          accessToken: _accessTokenResponse!.accessToken!,
          provider: 'github',
        );
      } else {
        _storage.token = await _userApi.oauthLogin(
          accessToken: _accessTokenResponse!.accessToken!,
          provider: 'github',
        );
      }

      _storage.currentUser = await _userApi.fetchCurrentUser();

      // update authentication status..
      _storage.isLoggedIn = true;

      // save authentication type to local storage..
      _storage.authType = AuthType.GITHUB;

      setStateFor(githubOAUTH, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(githubOAUTH, ViewState.Error);
      setErrorMessageFor(githubOAUTH, f.message);
    } catch (e) {
      setStateFor(githubOAUTH, ViewState.Error);
      setErrorMessageFor(githubOAUTH, 'Unable to authenticate!');
    }
  }
}
