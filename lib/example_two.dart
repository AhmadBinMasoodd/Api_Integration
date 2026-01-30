import 'dart:convert';
import 'package:api_integration/ExampleThree.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:api_integration/Models/Photos.dart';

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({super.key});

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {

  Future<List<Photos>> getPhotos() async {
    List<Photos> photoList = [];

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (Map<String, dynamic> i in data) {
        photoList.add(
          Photos(
            id: i['id'],
            title: i['title'],
            url: i['url'],
          ),
        );
      }
    }
    return photoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos API'),
        centerTitle: true,
      ),
      body: Column(
        children: [

          // 🔘 Example Three Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Examplethree(),
                  ),
                );
              },
              child: const Text('Example Three'),
            ),
          ),

          // 📸 Photos List
          Expanded(
            child: FutureBuilder<List<Photos>>(
              future: getPhotos(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading photos'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No photos found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(snapshot.data![index].url),
                      ),
                      title: Text(
                        'Notes Id: ${snapshot.data![index].id}',
                      ),
                      subtitle: Text(
                        snapshot.data![index].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
