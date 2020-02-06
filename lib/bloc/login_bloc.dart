import 'dart:async';

import 'package:carros/api/api_response.dart';
import 'package:carros/api/login_api.dart';
import 'package:carros/bloc/generic_bloc.dart';
import 'package:carros/entity/user.dart';

class LoginBloc extends GenericBloc<bool> {
  Future<ApiResponse<User>> doLogin(String login, String pass) async {
    add(true);
    ApiResponse response = await LoginApi.doLogin(login, pass);
    add(false);
    return response;
  }
}
