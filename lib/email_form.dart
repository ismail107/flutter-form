import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fata/utils/config.dart';

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();


  Future<void> _submitForm() async {
    // Send form data to Laravel backend
    final Dio dio = Dio();
    final String apiUrl = 'https://mobileform.wapoloo.online/api/submit-form';
    final Map<String, dynamic> formData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'age': _ageController.text,
    };

    try {
      final Response response = await dio.post(apiUrl, data: formData);
      print(response.data);

      // Clear text fields after successful form submission
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _ageController.clear();


      // Show success message to user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Form submitted successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 422) {
          // Validation error occurred
          Map<String, dynamic> errorData = error.response!.data['errors'];
          String errorMessage = '';

          // Check for specific fields' errors
          if (errorData.containsKey('email')) {
            errorMessage += 'Email: ${errorData['email'][0]}\n';
          }
          if (errorData.containsKey('phone')) {
            errorMessage += 'Phone Number: ${errorData['phone'][0]}\n';
          }
          // Add more fields' error handling if needed
          if (errorData.containsKey('name')) {
            errorMessage += 'Name: ${errorData['name'][0]}\n';
          }

          if (errorData.containsKey('age')) {
            errorMessage += 'Age: ${errorData['age'][0]}\n';
          }
          // Show error message to user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Validation Error'),
                content: Text(errorMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Other types of errors
          print('Error submitting form: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration Form',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make title text bold
            fontSize: 20, // Adjust title font size
          ),
        ),
        backgroundColor: Colors.blue, // Set background color of the app bar
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.person_outlined),
                  prefixIconColor: Config.primaryColor,
                  border: Config.outlinedBorder,
                  focusedBorder: Config.focusBorder,
                  errorBorder: Config.errorBorder,
                ),
              ),
              Config.spaceSmall,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.email_outlined),
                  prefixIconColor: Config.primaryColor,
                  border: Config.outlinedBorder,
                  focusedBorder: Config.focusBorder,
                  errorBorder: Config.errorBorder,
                ),
              ),
              Config.spaceSmall,
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                // Changed to TextInputType.phone
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.phone_outlined),
                  prefixIconColor: Config.primaryColor,
                  border: Config.outlinedBorder,
                  focusedBorder: Config.focusBorder,
                  errorBorder: Config.errorBorder,
                ),
              ),
              Config.spaceSmall,
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                // Changed to TextInputType.number
                cursorColor: Config.primaryColor,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.date_range_outlined),
                  prefixIconColor: Config.primaryColor,
                  border: Config.outlinedBorder,
                  focusedBorder: Config.focusBorder,
                  errorBorder: Config.errorBorder,
                ),
              ),
              Config.spaceSmall,
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 3,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
