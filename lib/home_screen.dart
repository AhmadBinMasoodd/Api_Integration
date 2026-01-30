import 'dart:convert';

import 'package:api_integration/example_two.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/Post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<List<PostModel>> getPostApi() async {
    List<PostModel> postList = [];

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (Map<String, dynamic> i in data) {
        postList.add(PostModel.fromJson(i));
      }
    }
    return postList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API'),centerTitle: true,),
      body: Column(
        children: [

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExampleTwo()),
              );
            },
            child: const Text('Example Two'),
          ),

          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {

                // 🔄 Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ❌ Error
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                // 📭 Empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                // ✅ Data loaded
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title\n${snapshot.data![index].title}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Description\n${snapshot.data![index].body}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
