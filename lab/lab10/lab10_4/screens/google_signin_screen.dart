// Lab 10.4 – Firebase Google Sign-In Screen
//
// ✅ SETUP REQUIRED (one-time) before running:
//   1. Create a Firebase project at https://console.firebase.google.com
//   2. Add Android app with package name: com.example.flutter2026
//   3. Download google-services.json → put in android/app/google-services.json
//   4. Enable Google Sign-In in Firebase Console → Authentication → Sign-in method
//   5. Add SHA-1 fingerprint: run `./gradlew signingReport` or
//      `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey`
//   6. Run: flutter pub get
//
// All Gradle and pubspec.yaml setup is already done.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) setState(() => _currentUser = user);
    });
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        setState(() => _isLoading = false);
        return;
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        setState(() => _currentUser = userCredential.user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Signed in as ${userCredential.user?.displayName ?? "User"}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-In failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      setState(() => _currentUser = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.4 – Google Sign-In'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: _currentUser == null
                ? _buildSignInView()
                : _buildProfileView(),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle_outlined,
            size: 100, color: Colors.red),
        const SizedBox(height: 24),
        const Text(
          'Firebase Google Sign-In',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in with your Google account\nto access the app',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _signInWithGoogle,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.login, color: Colors.red),
            label: Text(
              _isLoading ? 'Signing in...' : 'Sign in with Google',
              style: const TextStyle(fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile photo
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.red[100],
          backgroundImage: _currentUser?.photoURL != null
              ? NetworkImage(_currentUser!.photoURL!)
              : null,
          child: _currentUser?.photoURL == null
              ? const Icon(Icons.person, size: 60, color: Colors.red)
              : null,
        ),
        const SizedBox(height: 20),
        Text(
          _currentUser?.displayName ?? 'Google User',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _currentUser?.email ?? '',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'UID: ${_currentUser?.uid ?? ''}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ),
      ],
    );
  }
}
