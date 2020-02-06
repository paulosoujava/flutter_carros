import 'dart:convert';
import 'package:carros/api/api_response.dart';
import 'package:carros/entity/user.dart';
import 'package:carros/utils/prefs.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse<User>> doLogin(String login,
      String password) async {
    try {
      var url = 'http://carros-springboot.herokuapp.com/api/v2/login';
      Map<String, String> headers = {"Content-Type": "application/json"};
      var params = {'username': login, 'password': password};

      var response =
      await http.post(url, body: json.encode(params), headers: headers);
      Map map = json.decode(response.body);

      if (response.statusCode == 200) {
        User user = User.fromJson(map);
        user.save();
       //Prefs.setString("user.prefs", response.body);
        return ApiResponse.ok(user);
      }else
        return ApiResponse.error(map['error']);
    } catch (error, exception) {
      return ApiResponse.error("servidor indisponivel");
    }
  }
}
