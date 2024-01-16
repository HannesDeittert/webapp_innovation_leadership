
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/Homepage.dart';
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
  List<String> questions = [
    "Are you from Fürth?",
    "What type of innovation location are you intrested in?",
    "What best matches your Intrests?"
  ];
  List<String> answerOptions_Furth = ["Yes", "No"];
  List<String> answerOptions_Type = [
    "University Chair",
    "StartUps",
    "Research Institutions",
    "Not Sure"
  ];
  List<String> answerOptions_topic = [
    "Information Technology / AI",
    "Business / Economics",
    "Sustainability",
    "Healthcare",
    "Education",
    "Research",
    "Automotive",
    "Mechanics",
    "Finance",
    "Insurance",
    "Social Science",
    "Creativity",
    "Communications",
    "Manufacturing",
    "FAU",
    "Sports"
  ];
  List<String> selectedAnswers_Furth = [];
  List<String> selectedAnswers_Type = [];
  List<String> selectedAnswers_topic = [];

  void setSelectedValue(List<String> value) {
    setState(() => selectedAnswers_topic = value);
  }

  String GetIndex() {
    List<List<String>> Arrays = [['Yes', 'StartUps',],['Yes', 'University Chair'],['No', 'StartUps'],['No', 'Not Sure'],['No', 'Research Institutions']];
    List<String> PathList = ['pdf/231117_Innovation_Lecture_upload.pdf', 'pdf/231117_Innovation_Lecture_upload.pdf','pdf/Exercise_2.pdf','pdf/InnoHikes Factsheet Promotion Hike 2.pdf','pdf/InnoHikes Factsheet Promotion Hike 2.pdf'];
    List<int> match = List.filled(Arrays.length, 0);
    List<int> matchInd =[];
    List<String?> filterTags= [selectedAnswers_Furth[0] , selectedAnswers_Type[0]];
    //filterTags.addAll(selectedAnswers_topic);
    print(filterTags);

    int counter = 0;
    for(List<String> List_ in Arrays){
      List<int> match =[];
      List<String> oneandtwo = [];
      oneandtwo.add(List_[0]);
      oneandtwo.add(List_[1]);
      String filterTagsString = filterTags.join(',');
      String PDFTagsString = oneandtwo.join(',');
      if(filterTagsString == PDFTagsString){
        matchInd.add(counter);
      }
      counter = counter+1;
    }
    for(int index in matchInd){
      List<String> compareArray = Arrays[index];
      for(String topic in selectedAnswers_topic){
        if(compareArray.contains(topic)){
          match[index] = match[index]+1;
        }
      }
    }
    int maxIndex = 0;
    int maxValue = match[0];

    for (int i = 1; i < match.length; i++) {
      if (match[i] > maxValue) {
        maxValue = match[i];
        maxIndex = i;
      }
    }
    return PathList[maxIndex];
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of questions from the QuestionProvider

    // Get the list of Innovation Hubs from the InnovationHubProvider
    List<InnovationHub> innoHubs =
        Provider.of<InnovationHubProvider>(context).innovationHubs;

    // Get the current question based on the index
    String currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
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
                  questions[currentQuestionIndex],
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
                  if (currentQuestion == "Are you from Fürth?") {
                    if (questions.isNotEmpty &&
                        answerOptions_Furth.isNotEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        // Setzen Sie hier die maximale Höhe nach Bedarf
                        child: RepaintBoundary(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: answerOptions_Furth.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Toggle the selection status of the answer
                                    if (selectedAnswers_Furth
                                        .contains(answerOptions_Furth[index])) {
                                      selectedAnswers_Furth
                                          .remove(answerOptions_Furth[index]);
                                    } else {
                                      selectedAnswers_Furth
                                          .add(answerOptions_Furth[index]);
                                      if (currentQuestionIndex ==
                                          questions.length - 1) {
                                        print(selectedAnswers_Furth);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()),
                                        );
                                      } else {
                                        // Ansonsten gehe zur nächsten Frage
                                        setState(() {
                                          currentQuestionIndex++;
                                        });
                                      }
                                    }
                                  });
                                  String selectedAnswer =
                                      answerOptions_Furth[index];
                                  print('Selected Answer: $selectedAnswer');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: answerOptions_Furth[index],
                                        // Unique tag for each image
                                        child: FutureBuilder(
                                          future: _loadProfileImage(
                                              answerOptions_Furth[index]),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      snapshot.data as String,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
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
                                          tag:
                                              'text_${answerOptions_Furth[index]}',
                                          child: Text(
                                            answerOptions_Furth[index],
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: tPrimaryColorText,
                                            ),
                                          ),
                                        ),
                                      )),
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
                  } else if (currentQuestion ==
                      "What best matches your Intrests?") {
                    if (questions.isNotEmpty &&
                        answerOptions_topic.isNotEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                (280 / 1080),
                            width: MediaQuery.of(context).size.width *
                                (1053 / 1728),
                            child: InlineChoice<String>(
                              multiple: true,
                              clearable: true,
                              value: selectedAnswers_topic,
                              onChanged: setSelectedValue,
                              itemCount: answerOptions_topic.length,
                              itemBuilder: (selection, i) {
                                return ChoiceChip(
                                  selected: selection
                                      .selected(answerOptions_topic[i]),
                                  onSelected: selection
                                      .onSelected(answerOptions_topic[i]),
                                  label: Text(answerOptions_topic[i]),
                                );
                              },
                              listBuilder: ChoiceList.createWrapped(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  } else {
                    if (questions.isNotEmpty && answerOptions_Type.isNotEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        // Setzen Sie hier die maximale Höhe nach Bedarf
                        child: RepaintBoundary(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: answerOptions_Type.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Toggle the selection status of the answer
                                    if (selectedAnswers_Type
                                        .contains(answerOptions_Type[index])) {
                                      selectedAnswers_Type
                                          .remove(answerOptions_Type[index]);
                                    } else {
                                      selectedAnswers_Type
                                          .add(answerOptions_Type[index]);
                                      if (currentQuestionIndex ==
                                          questions.length - 1) {
                                        print(selectedAnswers_Type);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()),
                                        );
                                      } else {
                                        // Ansonsten gehe zur nächsten Frage
                                        setState(() {
                                          currentQuestionIndex++;
                                        });
                                      }
                                    }
                                  });
                                  String selectedAnswer =
                                      answerOptions_Type[index];
                                  print('Selected Answer: $selectedAnswer');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: answerOptions_Type[index],
                                        // Unique tag for each image
                                        child: FutureBuilder(
                                          future: _loadProfileImage(
                                              answerOptions_Type[index]),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      snapshot.data as String,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
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
                                          tag:
                                              'text_${answerOptions_Type[index]}',
                                          child: Text(
                                            answerOptions_Type[index],
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: tPrimaryColorText,
                                            ),
                                          ),
                                        ),
                                      )),
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
                  }
                },
              ),
            ),
            if (currentQuestionIndex == questions.length - 1)
              GestureDetector(
                onTap: () async {
                  String result = GetIndex();

                  print('Filter tags match an array in Arrays. Corresponding path: $result');
                  final ref = firebase_storage.FirebaseStorage.instance.ref(result);
                  final url = await ref.getDownloadURL();

                  String? downloadUrl = await url;
                  if (downloadUrl != null) {
                    // Open the URL in the browser
                    if (await canLaunch(downloadUrl)) {
                      await launch(downloadUrl);
                    } else {
                      print("Could not launch $downloadUrl");
                    }
                  } else {
                    print("Matching entry not found in PathList");
                  }

                },
                child: Container(
                  height: MediaQuery.of(context).size.height * (60 / 982),
                  width: MediaQuery.of(context).size.width * (317 / 1512),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(
                        (MediaQuery.of(context).size.height * (60 / 982)) / 2,
                      )),
                  child: Center(
                    child: Text(
                      'View Reccomendations',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 30),
                child: Text('${currentQuestionIndex + 1} / ${questions.length}',
                    style: TextStyle(
                        color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                        fontSize: 64)),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height *(124/1080),
            )
          ],
        ),
      ),
    );
  }

  void _restartFilter() {
    currentQuestionIndex = 0;
  }

  Future<Object> _loadProfileImage(String selectedAnswer) async {
    String imagePath = "";
    try {
      print(selectedAnswer);
      if (selectedAnswer == "StartUps") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/StartUp.svg";
      } else if (selectedAnswer == "Yes") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "No") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "Research Institutions") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "University Chair") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Chair.svg";
      } else if (selectedAnswer == "Not Sure") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
            "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Beer Celebration-cuate.svg";
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
