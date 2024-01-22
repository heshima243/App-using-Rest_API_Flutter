import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vimeo_api/screen/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListTodo'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['id'] as int; 
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateEditPage(item);
                    
                    } else if (value == 'delete') {
                      deleteByid(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      const PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void navigateEditPage(Map<String, dynamic> item) {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(todo: item),
    );
    Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });

    const url = 'https://fakestoreapi.com/products';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        setState(() {
          items = jsonResponse;
          isLoading = false;
          print('Items available: $jsonResponse');
        });
      } else {
      
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
     
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteByid(int id) async {
    
    try {
     
      print('Deleting item with ID: $id');

      // Construct the delete URL
      final url = Uri.parse('https://fakestoreapi.com/products/$id');

    
      final headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

     
      final response = await http.delete(url, headers: headers);

      
      if (response.statusCode == 200) {
        // Remove the item from the list
        final filtered = items.where((element) => element['id'] != id).toList();

        setState(() {
          items = filtered;
        });
        print('Item deleted successfully.');
      } else {
      
        print('Error deleting item: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      
      print('Error deleting item: $error');
    }
  }
}
