import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes{
  static Box getUserRole()=>Hive.box(userRole);
  static Box getUserData()=>Hive.box(userBoxName);
  static Box getAuthData()=>Hive.box(authBox);
  static Box getData()=>Hive.box(authBox);
  static Box getLanguage()=>Hive.box('languageBox');
  static Box getRattingData()=>Hive.box("ratingData");

}