import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHubProvider.dart';
import '../../datamanager/Questions.dart';
import '../../home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_svg/flutter_svg.dart';

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
  Widget build(BuildContext context) {
    // Get the list of questions from the QuestionProvider
    List<Question> questions = Provider.of<QuestionProvider>(context).questions;

    // Get the list of Innovation Hubs from the InnovationHubProvider
    List<InnovationHub> innoHubs =
        Provider.of<InnovationHubProvider>(context).innovationHubs;

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

                      return Container(
                        alignment: Alignment.center,
                        // Setzen Sie hier die maximale Höhe nach Bedarf
                        child: RepaintBoundary(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: answerOptions_category.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Toggle the selection status of the answer
                                    if (selectedAnswers_category.contains(answerOptions_category[index])) {
                                      selectedAnswers_category.remove(answerOptions_category[index]);
                                    } else {
                                      selectedAnswers_category.add(answerOptions_category[index]);
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
                                    }
                                  });
                                  String selectedAnswer = answerOptions_category[index];
                                  print('Selected Answer: $selectedAnswer');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Hero(
                                          tag: answerOptions_category[index], // Unique tag for each image
                                          child: FutureBuilder(
                                            future: _loadProfileImage(answerOptions_category[index]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context).size.height / 4,
                                                  width: MediaQuery.of(context).size.height / 4,
                                                  child: CachedNetworkImage(
                                                      imageUrl: snapshot.data as String,
                                                      width: MediaQuery.of(context).size.height / 4,
                                                      height: MediaQuery.of(context).size.height / 4,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Container(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                );
                                              } else {
                                                return Container(); // Ladeindikator kann hier eingefügt werden
                                              }
                                            },
                                          ),
                                        ),
                                        Center(
                                            child: RepaintBoundary(
                                              child: Hero(
                                                tag: 'text_${answerOptions_category[index]}',
                                                child: Text(
                                                  answerOptions_category[index],
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: tPrimaryColorText,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ),
                                      ],
                                    ),
                                  ),
                              );
                            },
                          ),
                        ), // Counter und Next/Finish Button


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
                            child: Wrap(
                              spacing: 8.0,
                              children: answerOptions_topic.map((option) {
                                return ChoiceChip(
                                  label: Text(option),
                                  selected: selectedAnswers_topic.contains(option),
                                  selectedColor: Colors.blueAccent,
                                  onSelected: (selected) {
                                    if (!selectedAnswers_topic.contains(option)) {
                                      // Füge das Element nur hinzu, wenn es noch nicht in der Liste ist
                                      setState(() {
                                        selectedAnswers_topic.add(option);
                                      });

                                    } else if (selectedAnswers_topic.contains(option)) {
                                      // Entferne das Element nur, wenn es bereits in der Liste ist
                                      setState(() {
                                        selectedAnswers_topic.remove(option);
                                      });
                                      print(selected);
                                    }
                                    print('Selected Answers: $selectedAnswers_topic');
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
                                  selectedColor: Colors.blueAccent,
                                  onSelected: (selected) {
                                    if (!selectedAnswers_goal.contains(option)) {
                                      // Füge das Element nur hinzu, wenn es noch nicht in der Liste ist
                                      setState(() {
                                        selectedAnswers_goal.add(option);
                                      });

                                    } else if (selectedAnswers_goal.contains(option)) {
                                      // Entferne das Element nur, wenn es bereits in der Liste ist
                                      setState(() {
                                        selectedAnswers_goal.remove(option);
                                      });
                                      print(selected);
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

                ///ToDo: Wenn alle SelctedAnswers empty sind dann Popup, mit hinweis darauf, wenn dann dort auf weiter, dann direkt Home() ohne zu filtern.
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

  void _restartFilter(){
    currentQuestionIndex = 0;
  }
  Future<Object> _loadProfileImage(String selectedAnswer) async {
    String imagePath = "";
    try {
      print(selectedAnswer);
      if (selectedAnswer == "StartUp") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/StartUp.svg";
      } else if (selectedAnswer == "Company") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      }else if (selectedAnswer == "Chair") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Chair.svg";
      }else if (selectedAnswer == "Event") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Beer Celebration-cuate.svg";
      }else if (selectedAnswer == "Internship") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Internship-amico.svg";
      }else if (selectedAnswer == "Job") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Job hunt-amico.svg";
      } else if (selectedAnswer == "Thesis") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Thesis-amico.svg";
      }
      else {
        // Verwende hier die Referenz für andere Fälle
        imagePath = "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Group-bro.svg";
      }
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Fehlerbehandlung, wenn das Bild nicht geladen werden kann
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }
}


void filterInnoHubs(BuildContext context, List<dynamic> allSelectedItems_goal, List<dynamic> allSelectedItems_topic, List<dynamic> allSelectedItems_category) {
  // Get the original list of innovation hubs
  List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;
  List<Map<InnovationHub, int>> filteredHubs = [];
  print(allSelectedItems_topic);
  print(allSelectedItems_goal);
  print(allSelectedItems_category);
  print("filter");
  if(allSelectedItems_category.length == 0 && allSelectedItems_goal.length == 0 && allSelectedItems_topic.length == 0){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Options Selected'),
        content: Text("During the Filtering you have not selected an Filtering Option."),
        actions: [
          TextButton(
            child: const Text('Let´s restart!'),
            onPressed: () {
              ///ToDo: implement logic to set qurrentQuestionIndex to 0
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Let´s go Home'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ],
      ),
    );
  } else {
    for (InnovationHub Hub in originalHubs) {
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
    List<InnovationHub> sortedHubs = filteredHubs.map((entry) =>
    entry.keys.first).toList();

    // Call the createFilterdHubList function with the sorted and filtered filteredHubs list
    context.read<InnovationHubProvider>().createFilterdHubList(sortedHubs);
  }
}
