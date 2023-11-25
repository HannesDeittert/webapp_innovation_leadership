import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../datamanager/InnovationHub.dart';

class UpdateInnoHub_General extends StatelessWidget {
  final InnovationHub hub;

  UpdateInnoHub_General(this.hub);

  // Create controllers for each TextFormFields
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController questionCategoryController = TextEditingController();
  final TextEditingController questionGoalController = TextEditingController();
  final TextEditingController questionTopicController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController profileImagePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with the values from the InnovationHub object
    categoryController.text = hub.category;
    nameController.text = hub.name;
    summaryController.text = hub.summary;
    questionCategoryController.text = hub.question_category.join(", ");
    questionGoalController.text = hub.question_goal.join(", ");
    questionTopicController.text = hub.question_topic.join(", ");

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: MediaQuery.of(context).size.height / 20,
        ),
        child: Column(
          children: [
            // Example TextFormField
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: summaryController,
              decoration: InputDecoration(labelText: 'Summary'),
            ),
            TextFormField(
              controller: questionCategoryController,
              decoration: InputDecoration(labelText: 'Question Category'),
            ),
            TextFormField(
              controller: questionGoalController,
              decoration: InputDecoration(labelText: 'Question Goal'),
            ),
            TextFormField(
              controller: questionTopicController,
              decoration: InputDecoration(labelText: 'Question Topic'),
            ),
          ],
        ),
      ),
    );
  }
}