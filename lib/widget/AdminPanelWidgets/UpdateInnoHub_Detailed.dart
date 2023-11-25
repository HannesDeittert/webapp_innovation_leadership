import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../datamanager/DetailedHubInfo.dart';

class UpdateInnoHub_Detailed extends StatelessWidget {
  final DetailedHubInfo hub;

  UpdateInnoHub_Detailed(this.hub);

  // Create controllers for each TextFormFields
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController headerImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with the values from the DetailedHubInfo object
    codeController.text = hub.code;
    nameController.text = hub.name;
    descriptionController.text = hub.detailedDescription;
    websiteController.text = hub.website;
    headerImageController.text = hub.headerImage;

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
              controller: codeController,
              decoration: InputDecoration(labelText: 'Code'),
            ),
            // Repeat this pattern for other TextFormFields
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Detailed Description'),
            ),
            TextFormField(
              controller: websiteController,
              decoration: InputDecoration(labelText: 'Website'),
            ),
            TextFormField(
              controller: headerImageController,
              decoration: InputDecoration(labelText: 'Header Image'),
            ),
          ],
        ),
      ),
    );
  }
}