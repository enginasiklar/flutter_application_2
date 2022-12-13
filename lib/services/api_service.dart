import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_application_2/constants.dart';
import 'package:flutter_application_2/model/user_model.dart';

class ApiService {
  Future<List<UserModel>> getUsers() async {
    final response = await http
        .get(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<UserModel> model = userModelFromJson(response.body);
      return model;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
