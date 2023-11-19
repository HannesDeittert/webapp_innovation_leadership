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
  List<String> answerOptions_category = [];
  List<String> answerOptions_goal = [];
  List<String> answerOptions_topic = [];
  List<String> selectedAnswers_category = [];
  List<String> selectedAnswers_goal = [];
  List<String> selectedAnswers_topic = [];

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

    for (Question question in questions) {
      List<String> tags = [];
      for (InnovationHub hub in innoHubs) {
        // Fügen Sie die Tags aus der question_category Eigenschaft des Hub hinzu, die der aktuellen Frage entsprechen
        if (question.title == "question_category") {
          tags.addAll(hub.question_category);
          answerOptions_category = tags.toSet().toList();
        } else if (question.title == "question_topic") {
          tags.addAll(hub.question_topic);
          answerOptions_topic = tags.toSet().toList();
        } else if (question.title == "question_goal") {
          tags.addAll(hub.question_goal);
          answerOptions_goal = tags.toSet().toList();
        }

        ///ToDo: If we add another Question, we need to update this method.
        print("innohubiteration");
      }
    }
    print(answerOptions_goal);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Filter Questions'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 10,
              ),
              child: Container(
                child: Text(
                  questions[currentQuestionIndex].question,
                  style: TextStyle(
                    fontSize: 64,
                    color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Builder(
                builder: (context) {
                  if (currentQuestion.title == "question_category") {
                    if (questions.isNotEmpty &&
                        answerOptions_category.isNotEmpty) {

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            // Setzen Sie hier die maximale Höhe nach Bedarf
                            child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: answerOptions_category.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 150,
                                        child: ListTile(
                                          title:
                                              Text(answerOptions_category[index]),
                                          onTap: () {
                                            selectedAnswers_category
                                                .add(answerOptions_category[index]);
                                            String selectedAnswer =
                                                answerOptions_category[index];
                                            print(
                                                'Selected Answer: $selectedAnswer');
                                          },
                                        ),
                                      );
                                    },
                                  ), // Counter und Next/Finish Button
                              ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  } else if (currentQuestion.title == "question_topic") {
                    if (questions.isNotEmpty &&
                        answerOptions_topic.isNotEmpty) {


                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              alignment: Alignment.center,
                              // Setzen Sie hier die maximale Höhe nach Bedarf
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: answerOptions_topic.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 150,
                                    child: ListTile(
                                      title: Text(answerOptions_topic[index]),
                                      onTap: () {
                                        selectedAnswers_topic
                                            .add(answerOptions_topic[index]);
                                        String selectedAnswer =
                                            answerOptions_topic[index];
                                        print(
                                            'Selected Answer: $selectedAnswer');
                                      },
                                    ),
                                  );
                                },
                              ),
                            ), // Counter und Next/Finish Button
                          ]);
                    } else {
                      return CircularProgressIndicator();
                    }
                  } else {
                    if (questions.isNotEmpty && answerOptions_goal.isNotEmpty) {


                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Wrap(
                              spacing: 8.0,
                              children: answerOptions_goal.map((option) {
                                return ChoiceChip(
                                  label: Text(option),
                                  selected: selectedAnswers_goal.contains(option),
                                  onSelected: (selected) {
                                    if (selected && !selectedAnswers_goal.contains(option)) {
                                      // Füge das Element nur hinzu, wenn es noch nicht in der Liste ist
                                      selectedAnswers_goal.add(option);
                                    } else if (!selected && selectedAnswers_goal.contains(option)) {
                                      // Entferne das Element nur, wenn es bereits in der Liste ist
                                      selectedAnswers_goal.remove(option);
                                    }
                                    print('Selected Answers: $selectedAnswers_goal');
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
                },
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Wenn es die letzte Frage ist, zeige "Finish" und navigiere nach Hause
                if (currentQuestionIndex == questions.length - 1) {
                  print(selectedAnswers_goal);
                  filterInnoHubs(
                    context,
                    selectedAnswers_goal,
                    selectedAnswers_topic,
                    selectedAnswers_category,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } else {
                  // Ansonsten gehe zur nächsten Frage
                  setState(() {
                    currentQuestionIndex++;
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  fixedSize: Size(MediaQuery.of(context).size.width / 20,
                      MediaQuery.of(context).size.height / 30)),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Finish'
                    : 'Next',
                style: TextStyle(
                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 30),
              child: Text('${currentQuestionIndex + 1} / ${questions.length}',
                  style: TextStyle(
                      color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                      fontSize: 64)),
            ),
          ],
        ),
      ),
    );
  }
}


void filterInnoHubs(BuildContext context, List<dynamic> allSelectedItems_goal, List<dynamic> allSelectedItems_topic, List<dynamic> allSelectedItems_category) {
  // Get the original list of innovation hubs
  List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;
  List<Map<InnovationHub, int>> filteredHubs = [];

  for (InnovationHub Hub in originalHubs){
    int matchCount = 0;
    Hub.filtered_chips.clear();
    // Calculate simmilarity for allSelectedItems_goal
    for (String tag in allSelectedItems_goal) {
      if (Hub.question_goal.contains(tag)) {
        matchCount++;
        Hub.filtered_chips.add(tag);
      }
    }
    // Calculate simmilarity for allSelectedItems_topic
    for (String tag in allSelectedItems_topic) {
      if (Hub.question_topic.contains(tag)) {
        matchCount++;
        Hub.filtered_chips.add(tag);
      }
    }
    // Calculate simmilarity for allSelectedItems_category
    for (String tag in allSelectedItems_category) {
      if (Hub.question_category.contains(tag)) {
        matchCount++;
        Hub.filtered_chips.add(tag);
      }
    }
    // Add it to filtered Hubs
    filteredHubs.add({Hub: matchCount});
  }

  // Sort filteredHubs by matchCount
  filteredHubs.sort((a, b) => b.values.first.compareTo(a.values.first));

  // Cut Hubs with 0 matchCount

  filteredHubs.removeWhere((entry) => entry.values.first == 0);

  // Create a List<InnovationHub> from the sorted List<Map>
  List<InnovationHub> sortedHubs = filteredHubs.map((entry) => entry.keys.first).toList();

  // Call the createFilterdHubList function with the sorted and filtered filteredHubs list
  context.read<InnovationHubProvider>().createFilterdHubList(sortedHubs);

}