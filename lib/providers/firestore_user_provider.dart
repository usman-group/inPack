import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/models/cigarette_pack.dart';
import 'package:in_pack/models/user.dart';

class FirestoreUserProvider {
  final _usersCollection =
      FirebaseFirestore.instance.collection(usersCollection);
  static const usersCollection = 'users';
  User? currentUser;

  Future<void> create(User user) async {
    currentUser = user;
    return _usersCollection.doc(user.id).set(user.toJson());
  }

  Future<User?> getUserById(String id) async {
    final json = (await _usersCollection.doc(id).get()).data();
    return json != null ? User.fromJson(json) : null;
  }

  Future<List<User>> getAllUsers() async {
    final usersSnapshot = await _usersCollection.orderBy('name').get();
    final usersJson = usersSnapshot.docs.map((e) => e.data()).toList();
    return usersJson.map((e) => User.fromJson(e)).toList();
  }

  Future<User?> getCurrentUser(String id) async{
    if (currentUser != null) {
      return Future.delayed(Duration.zero, () => currentUser);
    }
    currentUser = await getUserById(id);
    return currentUser;
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
    assert((user != null &&
            lastSeen == null &&
            name == null &&
            rank == null &&
            imageUrl == null &&
            lastPosition == null &&
            currentPack == null) ||
        (user == null &&
            (lastSeen != null ||
                name != null ||
                rank != null ||
                imageUrl != null ||
                lastPosition != null ||
                currentPack != null)));
    if (currentUser == null) {
      throw 'You can not update user while sign-out';
    }
    if (user != null) {
      _usersCollection.doc(user.id).set(user.toJson());
      currentUser = user;
      return;
    }
    currentUser = currentUser!.copyWith(
        imageUrl: imageUrl,
        lastSeen: lastSeen,
        lastPosition: lastPosition,
        currentPack: currentPack,
        name: name,
        rank: rank);
    _usersCollection.doc(currentUser!.id).set(currentUser!.toJson());
  }
}
