import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../utils/navigator_key.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': Timestamp.now(),
        });
      } catch (e) {
        print('Error storing user data: $e');
        await userCredential.user?.delete();  // Delete the auth user if Firestore fails
        throw 'Failed to create user profile. Please try again.';
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'This email is already registered. Please use a different email or login.';
        case 'invalid-email':
          throw 'Invalid email address format.';
        case 'weak-password':
          throw 'Password is too weak. Please use at least 6 characters.';
        default:
          throw 'Failed to create account: ${e.message}';
      }
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'wrong-password':
          throw 'Incorrect password. Please try again.';
        case 'invalid-email':
          throw 'Invalid email address format.';
        case 'user-disabled':
          throw 'This account has been disabled.';
        default:
          throw 'Login failed: ${e.message}';
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    final todoProvider = Provider.of<TodoProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );
    await todoProvider.clearLocalData();
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}