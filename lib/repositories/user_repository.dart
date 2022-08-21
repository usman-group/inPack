import 'package:geolocator/geolocator.dart';
import 'package:in_pack/models/cigarette_pack.dart';
import 'package:in_pack/models/user.dart';
import 'package:in_pack/providers/fauth_user_provider.dart';
import 'package:in_pack/providers/firestore_user_provider.dart';

class UserRepository {
  final FAuthUserProvider _fAuthProvider = FAuthUserProvider();
  final FirestoreUserProvider _firestoreProvider = FirestoreUserProvider();

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **operation-not-allowed**:
  ///  - Thrown if email/password accounts are not enabled. Enable
  ///    email/password accounts in the Firebase Console, under the Auth tab.
  /// - **weak-password**:
  ///  - Thrown if the password is not strong enough.
  Future<User> signUp(
      {required String email,
      required String password,
      String? name,
      String? imageUrl,
      Rank? rank}) async {
    final authUser = await _fAuthProvider.signUp(email, password);
    final user = User(
        id: authUser!.uid,
        lastSeen: DateTime.now(),
        name: name,
        imageUrl: imageUrl,
        rank: Rank.junior);
    _firestoreProvider.create(user);
    return user;
  }

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **invalid-email**:
  /// - Thrown if the email address is not valid.
  /// - **user-disabled**:
  /// - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  /// - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  /// - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  Future<User> signIn({required String email, required String password}) async {
    dynamic user = await _fAuthProvider.signIn(email, password);
    user = _firestoreProvider.getUserById(user.uid).then((value) {
      if (value == null) {
        throw 'User has not register successfully. Try to delete user from firebase auth';
      }
      return value;
    });
    _firestoreProvider.currentUser = await user;
    return user;
  }

  Future<void> signOut() {
    return _fAuthProvider.signOut();
  }

  /// Return all users in firestore
  Future<List<User>> get allUsers {
    return _firestoreProvider.getAllUsers();
  }

  Future<List<User>> get allUsersExceptMe {
    return allUsers.then((value) => value..remove(currentUser));
  }

  /// Get current user from [FirebaseFirestore] if user is logged-in
  /// else return [null]
  Future<User?> get currentUser {
    if (_fAuthProvider.currentUser == null) {
      return Future.delayed(Duration.zero, () => null);
    }
    return _firestoreProvider.getCurrentUser(_fAuthProvider.currentUser!.uid);
  }

  Future<void> updateCurrentUser({
    User? user,
    DateTime? lastSeen,
    String? name,
    Rank? rank,
    String? imageUrl,
    Position? lastPosition,
    CigarettePack? currentPack,
  }) async {
    _firestoreProvider.updateCurrentUser(
        user: user,
        lastSeen: lastSeen,
        lastPosition: lastPosition,
        name: name,
        rank: rank,
        imageUrl: imageUrl,
        currentPack: currentPack);
  }
}
