import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ExampleFour extends StatefulWidget {
  const ExampleFour({super.key});

  @override
  State<ExampleFour> createState() => _ExampleFourState();
}

class _ExampleFourState extends State<ExampleFour> {
  var data;
  Future<void> getUserApi()async{
    final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    if(response.statusCode==200){
      data=jsonDecode(response.body.toString());

    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(future: getUserApi(), builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Text('Loading...');
                }else{
                  return ListView.builder(itemCount: data.length,itemBuilder: (context,index){
                      return Card(
                        child: Column(
                          children: [
                            ReuseableRow(title: 'Name', value: data[index]['name'].toString()),
                            ReuseableRow(title: 'Username', value: data[index]['name'].toString()),
                            ReuseableRow(title: 'Address', value: data[index]['address']['street'].toString()),
                            ReuseableRow(title: 'Lat', value: data[index]['address']['geo']['lat'].toString())

                          ],
                        ),
                      );
                  });
                }
          }))
        ],
      ),
    );
  }
}
class ReuseableRow extends StatelessWidget {
  String title,value;
  ReuseableRow({Key? key,required this.title,required this.value}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(this.title.toString()),
        Text(this.value.toString()),
      ],
    );
  }
}