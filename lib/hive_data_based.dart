import 'package:hive/hive.dart';

@HiveType(typeId: 0)

class form_data extends HiveObject{
       @HiveField(0)
      String name;
       @HiveField(1)
       String pass;
       @HiveField(2)
  String img_pass;

       form_data(this.name, this.pass, this.img_pass);
}