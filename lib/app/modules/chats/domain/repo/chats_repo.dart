import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> fetchRegisteredUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      List<User> userList = querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return userList;
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }
}
