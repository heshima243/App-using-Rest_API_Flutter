import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map<String, dynamic>? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'] ?? '';
      priceController.text = (todo['price'] ?? '').toString();
      descriptionController.text = todo['description'] ?? '';
      imageController.text = todo['image'] ?? '';
      categoryController.text = todo['category'] ?? '';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Page' : 'Add Page')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(hintText: 'price'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: imageController,
            decoration: const InputDecoration(hintText: 'image'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: 'category'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Edith Post' : 'Create Post '))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    // get the Data from form
    final title = titleController.text;
    final price = priceController.text;
    final description = descriptionController.text;
    final image = imageController.text;
    final category = categoryController.text;

    final body = {
      'title': title,
      'price': double.parse(price),
      'description': description,
      'image': image,
      'category': category,
    };

    // Submit data to the server
    const url = 'https://fakestoreapi.com/products';
    final uri = Uri.parse(url);
    try {
      try {
        final response = await http.post(
          uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          showSuccessMessage('Creation success');
          titleController.text = '';
          descriptionController.text = '';
          imageController.text = '';
          categoryController.text = '';
        } else {
          print('Server response: ${response.statusCode} - ${response.body}');
          showErrorMessage('Creation failed');
        }
      } catch (error) {
        print('Error during HTTP request: $error');
        showErrorMessage('Creation failed');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      showErrorMessage('Creation failed');
    }
  }

  Future<void> updateData() async {
    // get the Data from form
    final todo = widget.todo;
    if (todo == null) {
      print('you can not call updated without todo data');
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final price = priceController.text;
    final description = descriptionController.text;
    final image = imageController.text;
    final category = categoryController.text;

    final body = {
      'title': title,
      'price': double.parse(price),
      'description': description,
      'image': image,
      'category': category,
    };

    // Submit data to the server
    final url = 'https://fakestoreapi.com/products/$id';
    final uri = Uri.parse(url);
    try {
      try {
        final response = await http.put(
          uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          showSuccessMessage('update success');
        } else {
          print('Server response: ${response.statusCode} - ${response.body}');
          showErrorMessage('update failed');
        }
      } catch (error) {
        print('Error during HTTP request: $error');
        showErrorMessage('updated failed');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      showErrorMessage('update failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color.fromARGB(255, 119, 48, 43));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
