import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String? OSIS;
  final String? firstName;
  final String? lastName;
  final String? UID;
  final String? officialClass;
  final List<String>? favorites;

  MyUser({
    this.OSIS,
    this.firstName,
    this.lastName,
    this.UID,
    this.officialClass,
    this.favorites,
  });

  factory MyUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MyUser(
      OSIS: data?['OSIS'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      UID: data?['UID'],
      officialClass: data?['officialClass'],
      favorites:
          data?['favorites'] is Iterable ? List.from(data?['favorites']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (OSIS != null) 'OSIS': OSIS,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (UID != null) 'UID': UID,
      if (officialClass != null) 'officialClass': officialClass,
      if (favorites != null) 'favorites': favorites,
    };
  }
}
