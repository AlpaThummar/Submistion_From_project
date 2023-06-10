import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:submistion_from_project/registration_from.dart';
import 'package:submistion_from_project/registration_from.dart';
import 'package:path/path.dart';
import 'package:submistion_from_project/user_page.dart';
import 'package:submistion_from_project/user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  var box = await Hive.openBox('login_data');
  runApp(
      MaterialApp(
    home: login_page(),debugShowCheckedModeBanner: false,
  ));
}

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);
  static Database? database;
  @override
  State<login_page> createState() => _login_pageState();

}

class _login_pageState extends State<login_page> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Box box=Hive.box('login_data');

  bool tamp=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();
    tamp=box.get('isLogin') ?? false ;
    create_deb();

  }

  check_login(BuildContext context){
    if(tamp==true)
      {
        Future.delayed(Duration.zero).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return User_page();
          },));
        });

      }

  }

  permission() async {
    var status = await Permission.camera.status;
    var status1 = await Permission.storage.status;
    if (status.isDenied && status1.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }
  create_deb() async { //for creat the data based


    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cdmi.db');
    login_page.database  = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE reg_data (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, ref_id INTEGER, contact TEXT, email TEXT, pass Text, gender TEXT,skill TEXT, data TEXT,images FILE)');
        });
  }

  @override
  Widget build(BuildContext context) {
    check_login(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xff50878e),
        Color(0xff80b7be),
        Color(0xff9dd4db),
        Color(0xff50878e),
      ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Baseline(
                            baseline: 10,
                            baselineType: TextBaseline.alphabetic,
                            child: Icon(
                              Icons.account_circle,
                              size: 120,
                              color: Color(0xff00264d),
                            ),
                          )),
                      SizedBox(),
                      TextField(
                        controller: user,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter EMAIL ID",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      TextField(
                        controller: pass,
                        //obscureText: true,// for direct hid the password
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter Passwrod",
                            labelStyle: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            String email=user.text;
                            String password=pass.text;

                            String sql= "select * from reg_data where email ='$email' and pass ='$password'";

                            print(sql);

                            List<Map> l= await login_page.database!.rawQuery(sql);

                            if(l.length==1)
                              {
                                box.put("isLogin", true);
                                box.put("user_data", l[0]);

                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return User_page();
                                  },));
                              }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invelid User and Pass")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff00264d),
                              minimumSize: Size(200, 40)),
                          child: Text("LOGIN")),
                      //SizedBox(height: 2,),

                      ElevatedButton(
                          onPressed: () {

                            box.put("ref_id", 0);

                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Registration_from();
                            },));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff00264d),
                              minimumSize: Size(200, 40),
                              ),
                          child: Text("New Registration"))
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(),
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff1e404a),
                            Color(0xff358f9a),
                            Color(0xff266672)
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topRight)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
