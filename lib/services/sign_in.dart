import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String nameGoogle;
String emailGoogle;
String imageUrl;
String errorMessageRegister;
String errorMessageLogin;
String uid;

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;
  if (user != null) {
// Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    nameGoogle = user.displayName;
    emailGoogle = user.email;
    imageUrl = user.photoURL;
    uid = user.uid;
// Only taking the first part of the name, i.e., First Name
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: $user');
    return '$user';
  }
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
  nameGoogle = "";
  emailGoogle = "";
  imageUrl = "";
  errorMessageLogin = "";
  errorMessageRegister = "";
  uid = "";
}

Future<User> signInWithEmailAndPassword(String email, String password) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    errorMessageLogin = "";
    uid = user.uid;
    return user;
  } catch (e) {
    if (e.code == 'user-not-found') {
      errorMessageLogin = "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      errorMessageLogin = "Wrong password provided for that user.";
    } else if (e.code == 'unknown') {
      errorMessageLogin = "Empty input not allowed";
    } else if (e.code == 'invalid-email') {
      errorMessageLogin = "Invalid Email";
    }
    print(e.toString());
    return null;
  }
}

Future<User> signUp(String email, String password) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    errorMessageRegister = "";
    uid = user.uid;
    return user;
  } catch (e) {
    if (e.code == 'email-already-in-use') {
      errorMessageRegister = "Email already in use.";
    } else if (e.code == 'operation-not-allowed') {
      errorMessageRegister = "Email/Password must be filled.";
    } else if (e.code == 'unknown') {
      errorMessageRegister = "Empty input not allowed";
    } else if (e.code == 'invalid-email') {
      errorMessageRegister = "Invalid Email";
    } else if (e.code == 'weak-password') {
      errorMessageRegister = "Weak Password, must be more than 6 character";
    }
    print(e.toString());
    return null;
  }
}
