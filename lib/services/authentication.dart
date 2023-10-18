import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';


class authentication {

  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );



  static FirebaseAuth _fbauth = FirebaseAuth.instance;
  //For iOS
  Stream<User?> get authStateChanges => _fbauth.authStateChanges();

  static Future<User?> logInAnonymously() async {
    try {
      final UserCredential userCredential = await _fbauth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error logging in anonymously: $e');
      return null;
    }
  }

  static Future handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication!.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await _fbauth.signInWithCredential(credential);

      final User user = userCredential.user!;

      if (user != null) {
        String? photoURL = user.photoURL;
        String? firebaseID = user.uid;
        String? name = user.displayName;
        String? email = user.email;

        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("photoURL", photoURL!);
        sp.setString("email", email!);
        sp.setString("firebaseID", firebaseID);
        sp.setString("displayName", name!);
        sp.setBool("loggedOutFromApp", false);
      }

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future handleGoogleSignOut(String email, String password) async {
    try {
      var result = await _fbauth.signInWithEmailAndPassword(
          email: email, password: password);

      return result;
    } catch (error) {
      throw error;
    }
  }

  static Future sendEmailVerification() async {
    try {
      await _fbauth.currentUser!.sendEmailVerification();
    } catch (error) {
      throw error;
    }
  }

  static Future resendEmailVerification() async {
    try {
      await _fbauth.currentUser!.sendEmailVerification();
    } catch (error) {
      throw error;
    }
  }

  static Future resetPassword(String email) async {
    try {
      var result = await _fbauth.sendPasswordResetEmail(email: email);
      return result;
    } catch (error) {
      throw error;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _fbauth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("firebaseID", userCredential.user!.uid);
        sp.setString("email", email);
        sp.setBool("loggedOutFromApp", false);
      }

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // create user with email and password
  Future<User?> createUserWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _fbauth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("firebaseID", userCredential.user!.uid);
        sp.setString("email", email);
        sp.setBool("loggedOutFromApp", false);
      }

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithApple() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final UserCredential userCredential = await _fbauth.signInWithCredential(credential);

        String? firebaseID = userCredential.user!.uid;
        String appleDisplayName = appleIdCredential.fullName?.givenName ?? "";

        String email = appleIdCredential.email ?? "";
        if(appleIdCredential.fullName?.givenName != null ){
          appleDisplayName = '${appleIdCredential.fullName?.givenName} ${appleIdCredential.fullName?.familyName}';
        }

        SharedPreferences sp = await SharedPreferences.getInstance();

        sp.setString("firebaseID", firebaseID!);
        sp.setString("displayName", appleDisplayName);
        sp.setString("email", email);
        sp.setBool("loggedOutFromApp", false);

        //await checkForVersion(userCredential.user!);
        return userCredential.user;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error?.localizedDescription}");

        return null;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        return null;
    }


  }

  User? getCurrentUser() {
    User? user = _fbauth.currentUser;
    return user;
  }

  static Future<void> logout() async {
    try {

      // Sign out from FirebaseAuth
      await _fbauth.signOut();

      // Sign out from Google
      await googleSignIn.signOut();
    } catch (error) {
      throw error;
    }
  }


}

class AppleSignInAvailable{
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  Future<AppleSignInAvailable> check() async{
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }

}