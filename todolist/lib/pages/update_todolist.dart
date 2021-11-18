import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;  // package สำหรับ request ข้อมูล
import 'dart:async';  // package สำหรับ request ข้อมูล


class UpdatePage extends StatefulWidget {
  final v1,v2,v3;
  const UpdatePage(this.v1,this.v2,this.v3);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  var _v1, _v2, _v3;
  TextEditingController todo_title = TextEditingController(); //ระบุรายการที่ต้องทำ
  TextEditingController todo_detail = TextEditingController(); //ระบุรายละเอียด

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1;  //id
    _v2 = widget.v2;  //title
    _v3 = widget.v3;  //detail
    todo_title.text = _v2;
    todo_detail.text = _v3;
  }


  // clearTextInput() {
  //   todo_title.clear();
  //   todo_detail.clear();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (Color(0xff009999)),
        title: Text('แก้ไขรายการ',
        style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'iannnnnDUCK',
          )
        ),
        actions: [
          IconButton(onPressed: () {
             print("Delete ID : $_v1");
             deleteTodo();
             Navigator.pop(context,'delete');

          }, icon: Icon(Icons.delete,color: Colors.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),
              Image.asset(
                'assets/images/logo_todolist.png',
                width: 320,
                height: 200,
              ),
            SizedBox(height: 40),
            //ช่องกรอกข้อมูล title
              TextField(
                controller: todo_title,
                decoration: InputDecoration(
                    // hintText: 'Input message',
                    // suffixIcon: IconButton(
                    //   onPressed: todo_title.clear,
                    //   icon: Icon(Icons.clear),
                    // ),
                    labelText: 'รายการที่ต้องทำ',
                    labelStyle: TextStyle(
                      fontSize: 22,
                      fontFamily: 'iannnnnDUCK',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(17.0),
                      ),
                    ))),
              SizedBox(height: 30,),
              //ช่องกรอกข้อมูล detail
              TextField(
                minLines: 4,
                maxLines: 8,
                controller: todo_detail,
                decoration: InputDecoration(
                    // hintText: 'Input message',
                    // suffixIcon: IconButton(
                    //   onPressed: todo_detail.clear,
                    //   icon: Icon(Icons.clear),
                    // ),
                    labelText: 'รายละเอียด',
                    labelStyle: TextStyle(
                      fontSize: 22,
                      fontFamily: 'iannnnnDUCK',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(17.0),
                      ),
                    ),
                    // filled: true,
                    // fillColor: Color(0xffA3DAD8),
                    )),
              SizedBox(height: 30,),

              //ปุ่มเพิ่มข้อมูล
              Padding(
              padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
              // padding: const EdgeInsets.all(130),
              child: ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("แก้ไขรายการ"),
                onPressed: () {
                  print('----------------------------');
                  print('title: ${todo_title.text}');
                  print('detail: ${todo_detail.text}');
                  updateTodo();
                  
                  final snackBar = SnackBar(
                    content: const Text('อัพเดทรายการเรียบร้อยแล้ว'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                
                  
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xff009999)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(50, 10, 50, 10)),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 28, fontFamily: 'iannnnnDUCK'))),
              ),
              ),

          ], 
        ),
      ),
      
    );
  }


  Future updateTodo() async {  //async เป็นฟังก์ที่ใช้สำหรับการรอระยะเวลาจากฝั่ง server ให้ server response
    // var url = Uri.https('3972-2405-9800-ba10-19fe-31ab-c4b4-8011-5416.ngrok.io', '/api/create-todolist');
    var url = Uri.http('192.168.1.105:8000', '/api/update-todolist/$_v1');
    Map<String, String> header = {"Content-type":"application/json"};
    String jsondata = '{"title":"${todo_title.text}","detail":"${todo_detail.text}"}';
    var response = await http.put(url, headers: header, body: jsondata);
    print('-----result-----');
    print(response.body);
  } 

  Future deleteTodo() async {
    var url = Uri.http('192.168.1.105:8000', '/api/delete-todolist/$_v1');
    Map<String, String> header = {"Content-type":"application/json"};
    var response = await http.delete(url, headers: header);
    print('-----result-----');
    print(response.body);

  }
}