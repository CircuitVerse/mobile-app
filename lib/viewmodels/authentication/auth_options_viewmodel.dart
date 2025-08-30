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
  final String FB_OAUTH = 'fb_oauth';
  final String GOOGLE_OAUTH = 'google_oauth';
  final String GITHUB_OAUTH = 'github_oauth';

  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  Future facebookAuth({bool isSignUp = false}) async {
    final result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        setStateFor(FB_OAUTH, ViewState.Busy);

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

          setStateFor(FB_OAUTH, ViewState.Success);
        } on Failure catch (f) {
          setStateFor(FB_OAUTH, ViewState.Error);
          setErrorMessageFor(FB_OAUTH, f.message);
        }
        break;
      case LoginStatus.cancelled:
        setStateFor(FB_OAUTH, ViewState.Error);
        setErrorMessageFor(FB_OAUTH, 'Login Cancelled By User!');
        break;
      case LoginStatus.failed:
        setStateFor(FB_OAUTH, ViewState.Error);
        setErrorMessageFor(FB_OAUTH, 'Unable to authenticate!');
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

      setStateFor(GOOGLE_OAUTH, ViewState.Busy);

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

      setStateFor(GOOGLE_OAUTH, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(GOOGLE_OAUTH, ViewState.Error);
      setErrorMessageFor(GOOGLE_OAUTH, f.message);
    } catch (e) {
      setStateFor(GOOGLE_OAUTH, ViewState.Error);
      setErrorMessageFor(GOOGLE_OAUTH, 'Unable to authenticate!');
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

      setStateFor(GITHUB_OAUTH, ViewState.Busy);

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

      setStateFor(GITHUB_OAUTH, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(GITHUB_OAUTH, ViewState.Error);
      setErrorMessageFor(GITHUB_OAUTH, f.message);
    } catch (e) {
      setStateFor(GITHUB_OAUTH, ViewState.Error);
      setErrorMessageFor(GITHUB_OAUTH, 'Unable to authenticate!');
    }
  }
}
