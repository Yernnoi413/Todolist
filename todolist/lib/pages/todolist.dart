import 'package:flutter/material.dart';
import 'package:todolist/pages/add.dart';
import 'package:todolist/pages/update_todolist.dart';

import 'dart:convert'; // package สำหรับ http, request ข้อมูล
import 'package:http/http.dart' as http; // package สำหรับ http, request ข้อมูล
import 'dart:async'; // package สำหรับ http, request ข้อมูล

class Todolist extends StatefulWidget {
  // const Todolist({ Key? key }) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List todolistitems = ['a', 'b', 'c', 'd'];

  @override
  void initState() {
    //พิมพ์ ini Enter
    // TODO: implement initState
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage())).then((value) 
          {
            setState(() {
              getTodolist();
            });
          });
        },
        child: Icon(Icons.add, color: Colors.white), //เพิ่มปุ่ม Add
      ),
      appBar: AppBar(
        backgroundColor: (Color(0xff009999)),
        title: Text('All Todolist',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'iannnnnDUCK',
            )),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getTodolist();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
      ),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.checklist_rtl_rounded),
              title: Text("${todolistitems[index]['title']}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePage(
                            todolistitems[index]['id'],
                            todolistitems[index]['title'],
                            todolistitems[index]['detail']))).then((value) {
                  setState(() {
                    print(value);
                    if (value == 'delete') {
                      final snackBar = SnackBar(
                          content: const Text('ลบรายการเรียบร้อยแล้ว'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    getTodolist();
                  });
                });
              },
            ),
          );
        });
  }

  Future<void> getTodolist() async {
    List alltodo = [];
    var url = Uri.http('192.168.1.105:8000', '/api/all-todolist');
    var response = await http.get(url);
    // var result = json.decode(response.body);
    var result = utf8.decode(response.bodyBytes);
    print(result);
    setState(() {
      todolistitems = jsonDecode(result);
    });
  }
}
