import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        setStateFor(FB_OAUTH, ViewState.Busy);

        try {
          // save token & current user to local storage..
          if (isSignUp) {
            _storage.token = await _userApi.oauth_signup(
              accessToken: result.accessToken.token,
              provider: 'facebook',
            );
          } else {
            _storage.token = await _userApi.oauth_login(
              accessToken: result.accessToken.token,
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
      case FacebookLoginStatus.cancelledByUser:
        setStateFor(FB_OAUTH, ViewState.Error);
        setErrorMessageFor(FB_OAUTH, 'Login Cancelled By User!');
        break;
      case FacebookLoginStatus.error:
        setStateFor(FB_OAUTH, ViewState.Error);
        setErrorMessageFor(FB_OAUTH, 'Unable to authenticate!');
        break;
    }
  }

  Future googleAuth({bool isSignUp = false}) async {
    var _googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      await _googleSignIn.signIn();
      var _googleSignInAuthentication =
          await _googleSignIn.currentUser.authentication;

      setStateFor(GOOGLE_OAUTH, ViewState.Busy);

      // save token & current user to local storage..
      if (isSignUp) {
        _storage.token = await _userApi.oauth_signup(
          accessToken: _googleSignInAuthentication.accessToken,
          provider: 'google',
        );
      } else {
        _storage.token = await _userApi.oauth_login(
          accessToken: _googleSignInAuthentication.accessToken,
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
      redirectUri: 'circuitverse://auth/callback/github',
      customUriScheme: 'circuitverse',
    );

    var _oauthHelper = OAuth2Helper(
      _client,
      clientId: '06fa6b965ba7e4a4175c',
      clientSecret: 'd3a8a95bd1691b557ca347b14ae6507b89f92e47',
      scopes: ['read:user'],
    );

    try {
      var _accessTokenResponse = await _oauthHelper.getToken();

      setStateFor(GITHUB_OAUTH, ViewState.Busy);

      // save token & current user to local storage..
      if (isSignUp) {
        _storage.token = await _userApi.oauth_signup(
          accessToken: _accessTokenResponse.accessToken,
          provider: 'github',
        );
      } else {
        _storage.token = await _userApi.oauth_login(
          accessToken: _accessTokenResponse.accessToken,
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
