import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'Questions.dart';

class QuestionProvider with ChangeNotifier {
  bool _QuestiondataLoaded = false;
  List<Question> _questions = [];

  List<Question> get questions => _questions;

  Future<void> loadQuestionsFromFirestore() async {

    if (_QuestiondataLoaded) {
      print("returned as Questions is loaded");
      return;
    }
    // Reference to the Firestore collection 'questions'
    CollectionReference questionsRef = FirebaseFirestore.instance.collection('questions');

    // Load data from the collection
    QuerySnapshot snapshot = await questionsRef.get();

    // Create Question objects from the Firestore documents
    _questions = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return Question.fromFirestore(typedDoc.data());
    }).toList();

    print(_questions[0].question);
    _QuestiondataLoaded = true;
    notifyListeners();
  }
}