import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHubProvider.dart';

import '../../datamanager/Questions.dart';
import '../../home.dart';

class FilterUI extends StatefulWidget {
  @override
  _FilterUIState createState() => _FilterUIState();
}

class _FilterUIState extends State<FilterUI> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();

    // Load questions from Firestore when the widget is initialized
    Provider.of<QuestionProvider>(context, listen: false)
        .loadQuestionsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of questions from the QuestionProvider
    List<Question> questions = Provider.of<QuestionProvider>(context).questions;

    // Get the list of Innovation Hubs from the InnovationHubProvider
    List<InnovationHub> innoHubs =
        Provider.of<InnovationHubProvider>(context).innovationHubs;

    // Ensure the current question index is within bounds
    if (currentQuestionIndex >= questions.length) {
      // Handle when all questions are answered (you can replace this logic)
      return Scaffold(
        appBar: AppBar(
          title: Text('Filter Questions'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('All questions have been answered.'),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: Text("Finish"))
            ],
          ),
        ),
      );
    }

    // Get the current question based on the index
    Question currentQuestion = questions[currentQuestionIndex];
    print(currentQuestion);

    List<String> answerOptions = [];
    List<String> selectedAnswers = [];

    for (Question question in questions) {
      List<String> tags = [];
      for (InnovationHub hub in innoHubs) {
        // Fügen Sie die Tags aus der question_category Eigenschaft des Hub hinzu, die der aktuellen Frage entsprechen
        if (question.title == "question_category") {
          tags.addAll(hub.question_category);
          answerOptions = tags;
        }

        ///ToDo: If we add another Question, we need to update this method.
        print("innohubiteration");
      }
    }
    answerOptions = answerOptions.toSet().toList();
    print(answerOptions);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Questions'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              child: Text(
                questions[currentQuestionIndex].question,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Flexible(
            child: Builder(
              builder: (context) {
                if (questions.isNotEmpty && answerOptions.isNotEmpty) {
                  return Column(children: [
                    Container(
                      height: 200,
                      // Setzen Sie hier die maximale Höhe nach Bedarf
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: answerOptions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150,
                            child: ListTile(
                              title: Text(answerOptions[index]),
                              onTap: () {
                                  selectedAnswers.add(answerOptions[index]);
                                  String selectedAnswer = answerOptions[index];
                                  print('Selected Answer: $selectedAnswer');
                              },
                            ),
                          );
                        },
                      ),
                    ), // Counter und Next/Finish Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Question ${currentQuestionIndex + 1} of ${questions.length}'),
                        ElevatedButton(
                          onPressed: () {
                            // Wenn es die letzte Frage ist, zeige "Finish" und navigiere nach Hause
                            if (currentQuestionIndex == questions.length - 1) {
                              print(selectedAnswers);
                              filterInnoHubs(
                                  context,
                                  questions[currentQuestionIndex].title,
                                  selectedAnswers);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            } else {
                              // Ansonsten gehe zur nächsten Frage
                              currentQuestionIndex++;
                            }
                          },
                          child: Text(
                              currentQuestionIndex == questions.length - 1
                                  ? 'Finish'
                                  : 'Next'),
                        ),
                      ],
                    ),
                  ]);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<InnovationHub> filterHubs(List<InnovationHub> hubs, List<String> selectedTags) {
  return hubs.where((hub) {
    for (String tag in selectedTags) {
      if (hub.question_category.contains(tag)) {
        return true;
      }
    }
    return false;
  }).toList();
}

double calculateSimilarity(List<String> selectedTags, List<String> hubTags) {
  int matchCount = 0;
  for (String tag in selectedTags) {
    if (hubTags.contains(tag)) {
      matchCount++;
    }
  }
  return matchCount.toDouble() / selectedTags.length;
}

void sortFilteredHubs(List<InnovationHub> filteredHubs, List<String> selectedTags) {
  filteredHubs.sort((hub1, hub2) {
    double similarity1 = calculateSimilarity(selectedTags, hub1.question_category);
    double similarity2 = calculateSimilarity(selectedTags, hub2.question_category);
    return similarity2.compareTo(similarity1);
  });
}

void filterInnoHubs(BuildContext context, String question, List<dynamic> allSelectedItems) {
  if (question == "question_category") {
    // Get the original list of innovation hubs
    List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;

    // Filter the hubs that have at least one matching tag
    List<InnovationHub> filteredHubs = filterHubs(originalHubs, allSelectedItems.cast<String>());

    // Sort the filteredHubs list based on the similarity with the selected tags
    sortFilteredHubs(filteredHubs, allSelectedItems.cast<String>());

    // Call the createFilterdHubList function with the sorted and filtered filteredHubs list
    context.read<InnovationHubProvider>().createFilterdHubList(filteredHubs);
    print(InnovationHubProvider().filteredHubs);
  }
}
