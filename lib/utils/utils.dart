import 'package:jiffy/jiffy.dart';

class Utils{
  static String timeDiff({required String time}){
   return Jiffy.parse(time).fromNow();
  }
    

}