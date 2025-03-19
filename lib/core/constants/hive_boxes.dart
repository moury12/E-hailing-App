import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes{
  static Box getUserRole()=>Hive.box(userRole);

}