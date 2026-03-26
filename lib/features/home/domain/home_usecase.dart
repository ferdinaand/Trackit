import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:TrackIt/features/home/data/home_service.dart';
import 'package:TrackIt/features/home/domain/expense_entity.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class HomeUseCase {
  final HomeRepository _homeRepo = HomeRepository();

  Future<User?> signUp(String email, String password) async {
    final response = await _homeRepo.signUp(
      email,
      password,
    );
    return response.user;
  }

  Future<dynamic> saveExpense(List<Expense> data) async {
    final response = await _homeRepo.saveExpense(
      data.map((e) => e.toMap()).toList(),
    );
    return response;
  }

  Future<dynamic> getExpense(String userId) async {
    final response = await _homeRepo.getExpense(userId);

    return response;
  }

  Future<User?> signIn(String email, String password) async {
    final response = await _homeRepo.signIn(email, password);
    return response.user;
  }

  Future<void> verifyOtp(String token, String email) async {
    final response = await _homeRepo.verifyOtp(token, email);
    return response;
  }

  Future<void> signOut() async {
    await _homeRepo.signOut();
  }

  User? checkAuthStatus() {
    return _homeRepo.getCurrentUser();
  }
}
