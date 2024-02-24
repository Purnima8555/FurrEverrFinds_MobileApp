import 'package:firebase_auth/firebase_auth.dart';

void printUserID() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('User ID: ${user.uid}');
  } else {
    print('No user is currently logged in.');
  }
}
