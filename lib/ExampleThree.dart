import 'dart:convert';

import 'package:api_integration/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Examplethree extends StatefulWidget {
  const Examplethree({super.key});

  @override
  State<Examplethree> createState() => _ExamplethreeState();
}

class _ExamplethreeState extends State<Examplethree> {
  List<User> user=[];
  Future<List<User>> getUsers()async{
    final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data=jsonDecode(response.body.toString());
    if(response.statusCode==200){
      for(Map<String,dynamic> i in data){
        user.add(User.fromJson(i));
      }
      return user;
    }else{
      return user;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Users'),
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(future: getUsers(), builder: (context,AsyncSnapshot<List<User>> snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else{
              return ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            ReuseableRow(title: 'Name', value: snapshot.data![index].name),
                            ReuseableRow(title: 'Username', value: snapshot.data![index].username),
                            ReuseableRow(title: 'Email', value: snapshot.data![index].email),
                            ReuseableRow(title: 'Address', value: snapshot.data![index].address!.city.toString() + snapshot.data![index].address.geo.lat.toString()) ,


                          ],
                        ),
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
