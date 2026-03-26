import 'package:TrackIt/features/auth/domain/authentication_usecase.dart';
import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase _authUseCase = AuthUseCase();
  final SharedPreferences _prefs;

  User? _user;
  Profile? _profile;
  bool _isLoading = false;
  bool _rememberMe = false;

  User? get user => _user;
  Profile? get profile => _profile;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;

  AuthProvider(this._prefs)
      : _rememberMe = _prefs.getBool("rememberMe") ?? false;

  bool get isAuthenticated => _prefs.getBool("authenticated") ?? false;
  Future<dynamic> signUp(
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoading = false;
      _user = await _authUseCase.signUp(email, password);
    } catch (e) {
      throw Exception("Sign-up failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> getProfile(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> response = await _authUseCase.getProfile(userId);
      _profile = Profile.fromMap(response);
      _isLoading = false;
      return response;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> createProfile(Profile data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authUseCase.createProfile(data);
      return true;
    } catch (e) {
      throw Exception("create profile failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  shouldRememberMe(bool val) {
    _rememberMe = val;
    _prefs.setBool("rememberMe", val); // Save to SharedPreferences
    notifyListeners();
  }

  Future<User?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authUseCase.signIn(email, password);
      if (_user != null) {
        _prefs.setBool("authenticated", true);
      }

      return user;
    } catch (e) {
      throw Exception("Sign-in failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authUseCase.signOut();
    _prefs.remove('authenticated');
    _user = null;
    notifyListeners();
  }

  void checkAuthStatus() {
    _user = _authUseCase.checkAuthStatus();
    notifyListeners();
  }
}
