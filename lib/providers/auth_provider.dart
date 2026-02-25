import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, emailUnverified }

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AppAuthProvider(this._authService) {
    _init();
  }

  AuthStatus _status = AuthStatus.initial;
  UserProfile? _userProfile;
  String? _errorMessage;
  bool _isLoading = false;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<UserProfile?>? _profileSub;

  AuthStatus get status => _status;
  UserProfile? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  User? get firebaseUser => _authService.currentUser;

  void _init() {
    _authSub = _authService.authStateChanges.listen((user) {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
        _userProfile = null;
        _profileSub?.cancel();
      } else if (!user.emailVerified) {
        _status = AuthStatus.emailUnverified;
        _listenToProfile(user.uid);
      } else {
        _status = AuthStatus.authenticated;
        _listenToProfile(user.uid);
      }
      notifyListeners();
    });
  }

  void _listenToProfile(String uid) {
    _profileSub?.cancel();
    _profileSub = _authService.getUserProfileStream(uid).listen((profile) {
      _userProfile = profile;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signUp(
          email: email, password: password, displayName: displayName);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signIn(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> sendVerificationEmail() async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.sendVerificationEmail();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> reloadUser() async {
    await _authService.reloadUser();
    final user = _authService.currentUser;
    if (user != null && user.emailVerified) {
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  void clearError() => _clearError();

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication error. Please try again.';
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
