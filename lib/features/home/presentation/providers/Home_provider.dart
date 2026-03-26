import 'package:TrackIt/features/auth/domain/authentication_usecase.dart';
import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:TrackIt/features/home/domain/home_usecase.dart';
import 'package:TrackIt/features/home/domain/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class HomeProvider with ChangeNotifier {
  final HomeUseCase _homeUseCase = HomeUseCase();
  final SharedPreferences _prefs;

  User? _user;
  Profile? _profile;
  Expense? _expense;

  bool _isLoading = false;
  bool _rememberMe = false;

  User? get user => _user;
  Profile? get profile => _profile;
  Expense? get expense => _expense;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;

  HomeProvider(this._prefs)
      : _rememberMe = _prefs.getBool("rememberMe") ?? false;

  Future<dynamic> signUp(
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _homeUseCase.signUp(email, password);
    } catch (e) {
      throw Exception("Sign-up failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> getExpense(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Map<String, dynamic>> response =
          await _homeUseCase.getExpense(userId);

      // _expense = Expense.fromMap(response);
      return response;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> saveExpense(List<Expense> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _homeUseCase.saveExpense(data);
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
      _user = await _homeUseCase.signIn(email, password);
      return user;
    } catch (e) {
      throw Exception("Sign-in failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _homeUseCase.signOut();
    _user = null;
    notifyListeners();
  }

  void checkAuthStatus() {
    _user = _homeUseCase.checkAuthStatus();
    notifyListeners();
  }
}
