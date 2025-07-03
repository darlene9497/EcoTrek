import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../models/lesson_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth getters
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;

  // Collections
  static CollectionReference get _usersCollection => _firestore.collection('users');
  static CollectionReference get _challengesCollection => _firestore.collection('challenges');
  static CollectionReference get _lessonsCollection => _firestore.collection('lessons');

  // Authentication methods
  static Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // User methods
  static Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('[FirebaseService] Get user error: $e');
      rethrow;
    }
  }

  static Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toFirestore());
    } catch (e) {
      print('[FirebaseService] Create user error: $e');
      rethrow;
    }
  }

  static Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toFirestore());
    } catch (e) {
      print('[FirebaseService] Update user error: $e');
      rethrow;
    }
  }

  // Challenge methods - SIMPLIFIED to avoid index issues
  static Future<List<ChallengeModel>> getChallenges() async {
    try {
      print('[FirebaseService] Getting challenges...');
      
      // Simple query without filters to avoid index issues
      QuerySnapshot querySnapshot = await _challengesCollection
          .orderBy('createdAt', descending: true)
          .get();
      
      print('[FirebaseService] Retrieved ${querySnapshot.docs.length} documents');
      
      List<ChallengeModel> challenges = [];
      
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        try {
          ChallengeModel challenge = ChallengeModel.fromFirestore(doc);
          challenges.add(challenge);
          print('[FirebaseService] Parsed challenge: ${challenge.title}, AI: ${challenge.aiGenerated}');
        } catch (e) {
          print('[FirebaseService] Error parsing challenge doc ${doc.id}: $e');
          // Skip this document and continue with others
        }
      }
      
      print('[FirebaseService] Successfully parsed ${challenges.length} challenges');
      return challenges;
    } catch (e) {
      print('[FirebaseService] Get challenges error: $e');
      
      // If orderBy fails due to missing index, try simple query
      try {
        print('[FirebaseService] Trying simple query...');
        QuerySnapshot querySnapshot = await _challengesCollection.get();
        
        List<ChallengeModel> challenges = [];
        
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          try {
            ChallengeModel challenge = ChallengeModel.fromFirestore(doc);
            challenges.add(challenge);
          } catch (e) {
            print('[FirebaseService] Error parsing challenge doc ${doc.id}: $e');
          }
        }
        
        // Sort manually
        challenges.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        print('[FirebaseService] Simple query successful: ${challenges.length} challenges');
        return challenges;
      } catch (e2) {
        print('[FirebaseService] Simple query also failed: $e2');
        rethrow;
      }
    }
  }

  static Future<void> createChallenge(ChallengeModel challenge) async {
    try {
      print('[FirebaseService] Creating challenge: ${challenge.title}');
      
      if (challenge.id.isEmpty) {
        // Auto-generate ID
        DocumentReference docRef = _challengesCollection.doc();
        ChallengeModel challengeWithId = ChallengeModel(
          id: docRef.id,
          title: challenge.title,
          description: challenge.description,
          instructions: challenge.instructions,
          difficulty: challenge.difficulty,
          category: challenge.category,
          points: challenge.points,
          estimatedTime: challenge.estimatedTime,
          tips: challenge.tips,
          imageUrl: challenge.imageUrl,
          isActive: challenge.isActive,
          createdAt: challenge.createdAt,
          aiGenerated: challenge.aiGenerated,
          createdBy: challenge.createdBy,
        );
        
        await docRef.set(challengeWithId.toFirestore());
        print('[FirebaseService] Challenge created with ID: ${docRef.id}');
      } else {
        await _challengesCollection.doc(challenge.id).set(challenge.toFirestore());
        print('[FirebaseService] Challenge created with ID: ${challenge.id}');
      }
    } catch (e) {
      print('[FirebaseService] Create challenge error: $e');
      rethrow;
    }
  }

  static Future<void> updateChallenge(ChallengeModel challenge) async {
    try {
      await _challengesCollection.doc(challenge.id).update(challenge.toFirestore());
    } catch (e) {
      print('[FirebaseService] Update challenge error: $e');
      rethrow;
    }
  }

  static Future<void> completeChallenge(String userId, String challengeId, int points) async {
    try {
      // Update user's completed challenges and points
      await _usersCollection.doc(userId).update({
        'completedChallenges': FieldValue.arrayUnion([challengeId]),
        'totalPoints': FieldValue.increment(points),
        'lastActive': FieldValue.serverTimestamp(),
      });
      
      print('[FirebaseService] Challenge $challengeId completed for user $userId');
    } catch (e) {
      print('[FirebaseService] Complete challenge error: $e');
      rethrow;
    }
  }

  // Lesson methods
  static Future<List<LessonModel>> getLessons() async {
    try {
      QuerySnapshot querySnapshot = await _lessonsCollection.get();
      
      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('[FirebaseService] Get lessons error: $e');
      return []; // Return empty list instead of throwing
    }
  }

  static Future<void> createLesson(LessonModel lesson) async {
    try {
      if (lesson.id.isEmpty) {
        await _lessonsCollection.add(lesson.toFirestore());
      } else {
        await _lessonsCollection.doc(lesson.id).set(lesson.toFirestore());
      }
    } catch (e) {
      print('[FirebaseService] Create lesson error: $e');
      rethrow;
    }
  }

  // Bookmark
  static Future<void> bookmarkLesson(String userId, String lessonId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.update({
      'bookmarkedLessons': FieldValue.arrayUnion([lessonId]),
    });
  }

  static Future<void> unbookmarkLesson(String userId, String lessonId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.update({
      'bookmarkedLessons': FieldValue.arrayRemove([lessonId]),
    });
  }
  
  // Leaderboard
  static Future<List<UserModel>> getLeaderboard() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .orderBy('totalPoints', descending: true)
          .limit(10)
          .get();
      
      return querySnapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('[FirebaseService] Get leaderboard error: $e');
      return []; // Return empty list instead of throwing
    }
  }
}