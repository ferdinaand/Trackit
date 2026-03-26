import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeRepository {
  //first we create an instance of the supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;
  get currentSession => _supabase.auth.currentSession;
  get currentId => _supabase.auth.currentUser!.id;
  //create an asynchronous function [signUp] and provide email and password as named parameters, with an AuthResponse data type

  ///[updateSalary] function to update user's salary
  Future<dynamic> updateSalary(String userId) async {
    final response =
        await _supabase.from('expenses').select().eq('user_id', userId);
    return response;
  }

  Future<dynamic> updatePayday(String userId) async {
    final response =
        await _supabase.from('expenses').select().eq('user_id', userId);
    return response;
  }

  Future<dynamic> addIncomeTransaction(String userId) async {
    final response =
        await _supabase.from('expenses').select().eq('user_id', userId);
    return response;
  }

  Future<dynamic> deleteAccount(String userId) async {
    final response =
        await _supabase.from('expenses').select().eq('user_id', userId);
    return response;
  }

  Future<dynamic> logout(String userId) async {
    final response =
        await _supabase.from('expenses').select().eq('user_id', userId);
    return response;
  }

  Future<dynamic> saveExpense(List<Map<String, dynamic>> data) async {
    final response = await _supabase.from('expenses').insert(data);
    return response;
  }

  Future<dynamic> notificationPreference(String userId) async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      if (status.isGranted) {
        return;
      }

      if (status.isDenied) {
        final result = await Permission.notification.request();

        if (result.isGranted) {}
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<dynamic> setOrUpdateAppLockPin(List<Map<String, dynamic>> data) async {
    final response = await _supabase.from('expenses').insert(data);
    return response;
  }

  Future<void> verifyOtp(String token, String email) async {
    await _supabase.auth
        .verifyOTP(type: OtpType.email, token: token, email: email);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
