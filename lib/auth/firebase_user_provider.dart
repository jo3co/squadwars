import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class SquadWarsFirebaseUser {
  SquadWarsFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

SquadWarsFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<SquadWarsFirebaseUser> squadWarsFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<SquadWarsFirebaseUser>(
        (user) => currentUser = SquadWarsFirebaseUser(user));
