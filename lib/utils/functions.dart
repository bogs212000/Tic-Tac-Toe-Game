import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/user.dart';
import '../screen/auth/auth.wrapper.dart';
import 'const.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore fbStore = FirebaseFirestore.instance;
final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;

class AuthService {
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        margin: EdgeInsets.all(10),
        'Login Successful',
        'Welcome back, $email!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      Get.offAll(() => AuthWrapper());
      print("User signed in successfully");
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      // You can handle specific errors here, for example:
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      }
      Get.snackbar(
        'Error', // Title
        '${e.code}', // Message
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        // Position of Snackbar
        backgroundColor: Colors.red,
        // Background color
        colorText: Colors.white,
        // Text color
        duration: Duration(seconds: 3),
        // Duration the snackbar will show
        icon: Icon(Icons.info,
            color: Colors.white), // Icon to show on the snackbar
      );
    } catch (e) {
      Get.snackbar(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        'Error',
        // Title
        'An unknown error occurred',
        // Message
        snackPosition: SnackPosition.BOTTOM,
        // Position of Snackbar
        backgroundColor: Colors.red,
        // Background color
        colorText: Colors.white,
        // Text color
        duration: Duration(seconds: 3),
        // Duration the snackbar will show
        icon: const Icon(Icons.info,
            color: Colors.white), // Icon to show on the snackbar
      );
      print("An unknown error occurred: $e");
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      // Create the user in Firebase Authentication
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // After successful authentication, save user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'role': 'user',
        'email': email,
        'username': username,
        'wins': 0,
      });

      // Show success message and navigate to the AuthWrapper screen
      Get.snackbar(
        'Account Created',
        'Welcome, $email!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Get.offAll(() => AuthWrapper());
      print("User signed up successfully");
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth-specific exceptions
      Get.back();
      Get.snackbar(
        'Error',
        e.message ?? 'Something went wrong!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      print("Error signing up: ${e.message}");
    } catch (e) {
      // Handle other exceptions
      print("An unknown error occurred: $e");
      Get.snackbar(
        'Error',
        'An unknown error occurred!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

Future<UserModel?> fetchUserData() async {
  try {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        print("User data does not exist in Firestore.");
      }
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }
  return null;
}

Future<void> getUserData(setState) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .get();
  setState(() {
    username = snapshot.data()?['username'];
    role = snapshot.data()?['role'];
    wins = snapshot.data()?['wins'];
    email = snapshot.data()?['email'];
  });
  print('$wins, $role, $email, $username');
}

Future<void> addScore(String playerEmail, int win) async {
  final userRef =
  FirebaseFirestore.instance.collection('users').doc(playerEmail);
  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      if (!userDoc.exists) {
        throw Exception("User does not exist!");
      }

      final currentScore =
          userDoc['wins'] ?? 0; // Default to 0 if not present
      transaction.update(userRef, {
        'wins': currentScore + win, // Increment total score
      });
    });
  }
   catch (e) {print(e);}
}

Future<int> getPlayerRank(setState) async {
  try {
    // Fetch all users and sort them by score in descending order
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('wins', descending: true)
        .get();

    // Get the list of documents (players)
    List<QueryDocumentSnapshot> users = querySnapshot.docs;

    // Iterate to find the player's rank
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == FirebaseAuth.instance.currentUser!.email.toString()) {
        // Rank is index + 1 since ranks are 1-based
        print('rank : $i');
        setState((){
          rank = i + 1;
        });
        return i + 1;
      }
    }

    // If player email is not found
    throw Exception("Player not found in the leaderboard.");
  } catch (e) {
    print("Error getting player rank: $e");
    return -1; // Return -1 to indicate an error
  }
}
