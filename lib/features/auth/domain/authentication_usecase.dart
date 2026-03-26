import 'package:TrackIt/features/auth/data/authentication_service.dart';
import 'package:TrackIt/features/auth/domain/profile_entity.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUseCase {
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  Future<User?> signUp(String email, String password) async {
    final response = await _authRepo.signUp(
      email,
      password,
    );
    return response.user;
  }

  Future<dynamic> createProfile(Profile data) async {
    final response = await _authRepo.createProfile(data.toMap());
    return response;
  }

  Future<dynamic> getProfile(String userId) async {
    final response = await _authRepo.getProfile(userId);

    return response;
  }

  Future<User?> signIn(String email, String password) async {
    final response = await _authRepo.signIn(email, password);
    return response.user;
  }

  Future<void> verifyOtp(String token, String email) async {
    final response = await _authRepo.verifyOtp(token, email);
    return response;
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }

  User? checkAuthStatus() {
    return _authRepo.getCurrentUser();
  }
}
