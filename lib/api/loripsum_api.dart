import 'package:carros/bloc/generic_bloc.dart';
import 'package:http/http.dart' as http;

class LoripsumBloc extends GenericBloc<String> {

  static String lorim;

  fetch() async {
    try {
      String s = lorim ?? await getLoripsum();
      lorim = s;
      add(s);
    } catch (e) {
      addError("Eu devia ter estudado mais...");
    }
  }

  static Future<String> getLoripsum() async {
    try {
      var url = 'https://loripsum.net/api';

      print("GET > $url");

      var response = await http.get(url);

      String text = response.body;

      text = text.replaceAll("<p>", "");
      text = text.replaceAll("</p>", "");

      return text;
    } catch (e) {
      return e.toString();
    }
  }
}
