import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:submistion_from_project/main.dart';
import 'package:submistion_from_project/main.dart';

import 'package:submistion_from_project/registration_from.dart';

class User_page extends StatefulWidget {
  const User_page({Key? key}) : super(key: key);

  @override
  State<User_page> createState() => _User_pageState();
}

class _User_pageState extends State<User_page> {
  List<Map> l = [];
  List  main=[];
  List  user=[];

  bool t = false;

  Box box=Hive.box('login_data');

  Map ? m ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (box.get("isLogin")??0){
      m= box.get("user_data");
      print("Data:${m}");
    }
    get_data();
  }

  get_data() async {
    String sql = "select * from reg_data ";
    l = await login_page.database!.rawQuery(sql);
    String sql1="select * from reg_data where id='${m!['id']}'";
    main = await login_page.database!.rawQuery(sql1);
    String sql2="select * from reg_data where ref_id='${main[0]['id']}'";
    user=await login_page.database!.rawQuery(sql2);

    print(l);
    t = true;
    setState(() {});
  }

  Future check_login(BuildContext context) async {

    if(box.get("isLogin")==false){
      await  Navigator.push(context, MaterialPageRoute(builder: (context) {
        return login_page();

      },));

    }
  }

  @override
  Widget build(BuildContext context) {
    check_login(context);
    return Scaffold(
      drawer: Drawer(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(children: [
       UserAccountsDrawerHeader( currentAccountPicture: l[0]['images'],
             accountName: Text("Name: ${m!['name']}"), accountEmail: Text("Email:${m!['email']}")),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text("Log Out"),
                onTap: () {
                  box.put("isLogin", false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return login_page();

                  },));
                },
              ),
            ),
          )
        ]),
      ),
      appBar: AppBar( actions: [Wrap(children: [IconButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Registration_from();
        },));


      }, icon: Icon(Icons.add))],)],
        title: Text("Student Details"),
      ),
      body: (t == true)
          ? ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text("${l[index]['name']}"),
                  subtitle: Text("${l[index]['contact']}"),
                      leading: CircleAvatar(backgroundImage: FileImage(File("${l[index]['images']}")),),
                      trailing: Wrap(children: [
                        IconButton(onPressed: () {
                        String sql="delete From reg_data where id= ${l[index]['id']}";
                          login_page.database!.rawDelete(sql);
                            setState(() {});
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return User_page();
                            },));

                      }, icon: Icon(Icons.delete)),

                        IconButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return Registration_from(l[index]);
                          },));

                        }, icon: Icon(Icons.edit)),


                      ]),
                ));
              },
            )
          : CircularProgressIndicator(),
    );

  }
}
