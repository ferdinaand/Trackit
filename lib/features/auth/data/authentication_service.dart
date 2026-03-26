import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationRepository {
  //first we create an instance of the supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;
  get currentSession => _supabase.auth.currentSession;
  get currentId => _supabase.auth.currentUser!.id;
  //create an asynchronous function [signUp] and provide email and password as named parameters, with an AuthResponse data type

  Future<AuthResponse> signUp(String email, String password) async {
    final response =
        await _supabase.auth.signUp(email: email, password: password);
    print(response);
    return response;
  }

  // ignore: avoid_types_as_parameter_names
  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<dynamic> getProfile(String userId) async {
    final response =
        await _supabase.from('profile').select().eq('id', userId).maybeSingle();
    return response;
  }

  Future<dynamic> createProfile(Map<String, dynamic> data) async {
    final response = await _supabase.from('profile').insert(data);
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
