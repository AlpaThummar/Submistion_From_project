import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:submistion_from_project/user_page.dart';
import 'package:submistion_from_project/main.dart';
import 'package:submistion_from_project/user_page.dart';

import 'package:submistion_from_project/user_page.dart';

import 'main.dart';

class Registration_from extends StatefulWidget {
 //const Registration_from({Key? key}) : super(key: key);

  Map ? m;
  Registration_from([this.m]);

  static Database? database;

  @override
  State<Registration_from> createState() => _Registration_fromState();
}

class _Registration_fromState extends State<Registration_from> {
  TextEditingController t1_name = TextEditingController();
  TextEditingController t2_contact = TextEditingController();
  TextEditingController t3_email = TextEditingController();
  TextEditingController t4_pass = TextEditingController();

  Box box = Hive.box('login_data');
  bool tamp=false;

  String Gender = "Male";
  bool check = false;
  bool check1 = false;
  bool check2 = false;
  List<DropdownMenuItem> dd = [];
  List<DropdownMenuItem> mm = [];
  List<DropdownMenuItem> yy = [];
  String day = "Day", month = "Month", year = "Year",date="",skill="";



  bool is_img = false;
  bool name_ = false;
  bool contact_ = false;
  bool email_ = false;
  bool password_ = false;


  ImagePicker picker = ImagePicker();


  PickedFile? images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dd.add(DropdownMenuItem(
        child: Text("Day"),value: "Day",));
    mm.add(DropdownMenuItem(
      child: Text("Month"),value: "Month",));
    yy.add(DropdownMenuItem(
      child: Text("Year"),value: "Year",));
    for( int i=1;i<=31;i++)
      {
        dd.add(DropdownMenuItem(
          child: Text("${i}"),value: "${i}",));
      }
    for( int i=1;i<=12;i++)
    {
      mm.add(DropdownMenuItem(
        child: Text("${i}"),value: "${i}",));
    }
    for( int i=1990;i<=2023;i++)
    {
      yy.add(DropdownMenuItem(
        child: Text("${i}"),value: "${i}",));
    }
    permission();
    tamp=box.get('isLogin') ?? false ;
    create_deb();
    if(widget.m!=null)
      {
          t1_name.text=widget.m!['name'];
          t2_contact.text=widget.m!['contact'];
          t3_email.text=widget.m!['email'];
          t4_pass.text=widget.m!['pass'];
          Gender=widget.m!['gender'];
          date=widget.m!['data'];
          skill=widget.m!['skill'];

           List d=widget.m!['data'].split("/");
           print(d);

          List l = widget.m!['skill'].split("/");
          if (l.contains("PHP")) {
            check = true;
          }
          if (l.contains("Android")) {
            check1 = true;
          }
          if (l.contains("Flutter")) {
            check2 = true;
          }

      }




  }

  create_deb() async { //for creat the data based


    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cdmi.db');
    Registration_from.database  = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE reg_data (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,ref_id INTEGER, contact TEXT, email TEXT, pass Text, gender TEXT,skill TEXT, data TEXT,images FILE)');
        });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.m!=null)?Text("Update Details", textAlign: TextAlign.center,):Text("Registration Details", textAlign: TextAlign.center,),
        backgroundColor: Color(0xff00264d),),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            child: TextField(
              controller: t1_name,
              decoration: InputDecoration(errorText: (name_=true) ? "Enter Your Name" : null,hintText: "Enter name"),
            ),
          ),
          Card(
            child: TextField(
              controller: t2_contact,
              decoration: InputDecoration(errorText: (contact_=true) ? "Enter Your Contact No" : null,hintText: "Enter Contact"),
            ),
          ),
          Card(
            child: TextField(
              controller: t3_email,
              decoration: InputDecoration(errorText: (email_=true) ? "Enter Your Email Id" : null,hintText: "Enter Email"),
            ),
          ),
          Card(
            child: TextField(
              controller: t4_pass,
              decoration: InputDecoration(errorText:  (password_=true)?"Enter Your Password":null ,hintText: "Enter Passwrod"),
            ),
          ),
          Row(children: [ Container(child: Text("Select Gender"),),
            RadioMenuButton(
                value: "Male", groupValue: Gender, onChanged: (value) {
              Gender = value!;
              setState(() {});
            }, child: Text("Male")),
            RadioMenuButton(
                value: "Female", groupValue: Gender, onChanged: (value) {
              Gender = value!;
              setState(() {});
            }, child: Text("Female"))

          ],),
          Row(

            children: [ Container(child: Text("Select Skill"),),
              SizedBox(width: 5,),
              CheckboxMenuButton(value: check, onChanged: (value) {
                check = value as bool;
                setState(() {});
              }, child: Text("PHP")),
              CheckboxMenuButton(value: check1, onChanged: (value) {
                check1 = value as bool;
                setState(() {});
              }, child: Text("Android")),
              CheckboxMenuButton(value: check2, onChanged: (value) {
                check2 = value as bool;
                setState(() {});
              }, child: Text("Flutter")),
            ],),
          Row(children: [ Container(child: Text("Select Birth date:-"),),
            SizedBox(width: 5,),

           DropdownButton(items: dd, value: day,onChanged: (value) {
             day=value;

             setState(() {});

           },),

            DropdownButton(items: mm, value: month,onChanged: (value) {
              month=value;
              setState(() {});

            },),

            DropdownButton(items: yy, value: year,onChanged: (value) {
              year=value;
              setState(() {});
              },)
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Container(
              child: Text("Upload Images"),
            ),
            SizedBox(width: 5,),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Upload the Images"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                images = await picker.getImage(
                                    source: ImageSource.camera);
                                is_img = true;

                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text("Camera")),
                          TextButton(
                              onPressed: () async {
                                images = await picker.getImage(
                                    source: ImageSource.gallery);
                                is_img = true;
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text("Gallary"))
                        ],
                      );
                    },
                  );
                },style: ElevatedButton.styleFrom(
                  primary: Color(0xff00264d),
    ),
                child: Text("Upload")),
            Container(
              height: 100,
              width: 100,
              child:(widget.m!=null)?(is_img == true)?Image.file(File(images!.path)):Image.file(File(widget.m!['images'])):
              (images!=null)?(Image.file(File(images!.path))):Icon(Icons.account_circle),
            )

          ],),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [


            ElevatedButton(onPressed: () async {
              String name= t1_name.text;
              String contact=t2_contact.text;
              String email=t3_email.text;
              String pass =t4_pass.text;
              //String date="${day}/${month}/${year}";
              print("Date:${date}");

              var dir_path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/Formphoto";
              Directory dir=Directory(dir_path);
              if(!await dir.exists())
              {
                dir.create();
              }
              String img_name="mying${Random().nextInt(1000)}.jpg";
              File file= File("${dir_path}/${img_name}");
              print("IMage Path:${file.path}");
              file.writeAsBytes(await images!.readAsBytes());

              String img=file.path;
               name_ = false;
               contact_ = false;
               email_ = false;
               password_ = false;

              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp = new RegExp(pattern);
              if (name == "") {
                name_ == true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  Name")));
                setState(() {});


              } else if (contact == "") {
                contact_ = true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  NUmber")));
                setState(() {});
              } else if(!regExp.hasMatch(contact)){

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  NUmber")));
                setState(() {});
              }

              else if (email == "") {
                email_ = true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  Mail ID")));
                setState(() {});
              }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email)){
                email_ = true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  Mail ID")));
                setState(() {});

              }
              else if (pass == "") {
                password_ = true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter YOur  Passwrod")));
                setState(() {});
              } else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                  .hasMatch(pass)){
                password_ = true;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter Your  Strong Passwrod")));
                setState(() {});
              }else {
                StringBuffer skill_=StringBuffer();
                if(check==true)
                {
                  skill_.write("PHP");

                }
                if(check1==true)
                {
                  if(skill_.length>0)
                  {
                    skill_.write("/");
                  }
                  skill_.write("Android");
                }
                if(check2==true)
                {
                  if(skill_.length>0)
                  {
                    skill_.write("/");
                  }

                  skill_.write("Flutter");
                }
                String skill=skill_.toString();

                if (widget.m != null) {

                  if (is_img = true) {
                    File f1 = File("${widget.m!['images']}");
                    f1.delete();

                    File file = File("${dir_path}/${img_name}");
                    img = file.path;
                    file.writeAsBytes(await images!.readAsBytes());
                  } else {
                    img = file.path;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Upload IMages")));
                  }
                } else {
                  if (is_img = true) {
                    File file = File("${dir_path}/${img_name}");
                    img = file.path;
                    file.writeAsBytes(await images!.readAsBytes());
                  } else {
                    img = file.path;
                  }
                }

                // int refid=0;


                // if(widget.m!=null){
                //
                //   // String sql="update reg_data set name='$name', contact='$contact',email ='$email',pass ='$pass',gender ='$Gender' skill='$skill',images='$img',data='$date' ";
                //   // login_page.database!.rawUpdate(sql);
                //   // // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   // //   return login_page();
                //   // // },));
                //
                // }
                if (widget.m!=null){
                  print("Hello");
                  String sql ="INSERT INTO reg_data (name,ref_id,contact,email,pass,gender,skill,images,data) values ('$name','${widget.m!['id'].toString()}','$contact','$email','$pass','$Gender','$skill','$img','$date') ";
                  login_page.database!.rawInsert(sql);
                }
                else{

                  print("Main_Hello");
                  String sql ="INSERT INTO reg_data (name,ref_id,contact,email,pass,gender,skill,images,data) values ('$name','${0}','$contact','$email','$pass','$Gender','$skill','$img','$date') ";
                    login_page.database!.rawInsert(sql).then((value) {
                      print("value:$value");
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return login_page();
                    },));

                }

              }



            },style: ElevatedButton.styleFrom(
              primary: Color(0xff00264d),
            ), child: Text("Submit")),

            ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return User_page();
            },));


            },style: ElevatedButton.styleFrom(
              primary: Color(0xff00264d),
            ), child: Text("View"))
          ],)



        ]),
      ),


    );
  }
}
