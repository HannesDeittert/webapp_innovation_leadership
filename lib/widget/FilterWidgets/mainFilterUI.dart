import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../datamanager/InnovationHub.dart';
import '../../datamanager/InnovationHubProvider.dart';
import '../../datamanager/QuestionProvider.dart';
import '../../datamanager/Questions.dart';

class FilterUI extends StatefulWidget {
  @override
  _FilterUIState createState() => _FilterUIState();
}

class _FilterUIState extends State<FilterUI> {
  @override
  void initState() {
    super.initState();

    // Load questions from Firestore when the widget is initialized
    Provider.of<QuestionProvider>(context, listen: false)
        .loadQuestionsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
      builder: (context, provider, child) {
        // List of questions from the QuestionProvider
        List<Question> questions =
            Provider.of<QuestionProvider>(context).questions;
        List<InnovationHub> Inno = provider.innovationHubs;
        List<InnovationHub> filtered = provider.filteredHubs;
        List<String> tags_question_category = [];
        List<MultiSelectCard> card_question_category = [];

        for (Question question in questions) {
          List<String> tags = [];
          for (InnovationHub hub in Inno) {
            // Fügen Sie die Tags aus der question_category Eigenschaft des Hub hinzu, die der aktuellen Frage entsprechen
            if (question.title == "question_category") {
              tags.addAll(hub.question_category);
              tags_question_category = tags;
            }

            ///ToDo: If we add another Question, we need to update this method.
            print("innohubiteration");
          }
        }
        tags_question_category = tags_question_category.toSet().toList();

        ///ToDo: If we add another Question, we need to update this method.
        for (String string in tags_question_category) {
          card_question_category
              .add(MultiSelectCard(value: string, label: string));
        }

        print(tags_question_category);
        return Scaffold(
            appBar: AppBar(
              title: Text('Filter Questions'),
            ),
            body: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("What kind of Innovation Hub are you searching?"),
                      MultiSelectContainer(
                          prefix: MultiSelectPrefix(
                            selectedPrefix: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          itemsDecoration: MultiSelectDecorations(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.green.withOpacity(0.1),
                                  Colors.yellow.withOpacity(0.1),
                                ]),
                                border: Border.all(color: Colors.green[200]!),
                                borderRadius: BorderRadius.circular(20)),
                            selectedDecoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [Colors.green, Colors.lightGreen]),
                                border: Border.all(color: Colors.green[700]!),
                                borderRadius: BorderRadius.circular(5)),
                            disabledDecoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.grey[500]!),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          items: card_question_category,
                          onChange: (allSelectedItems, selectedItem) {
                            filterInnoHubs(context, "question_category", allSelectedItems);
                          }),
                    ],
                  ),
                )
              ],
            ));
      },
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
  }
}
