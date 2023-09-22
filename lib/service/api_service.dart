import 'package:dio/dio.dart';

import '../model/user_model.dart';

class ApiService {
  Dio dio = Dio();

  Future<User?> getUserDetails(int userId) async {
    try {
      final response = await dio.request("https://reqres.in/api/users/$userId");
      if (response.statusCode == 200) {
        final user = response.data;
        final userDetails = User.fromJson(user["data"]);
        return userDetails;
      }
    } catch (e) {
      print("Catched Error${e}");
      return null;
    }
    return null;
  }

  Future<List<User>> getAllUsersApi(int page) async {
    try {
      final response = await dio.request(
        'https://reqres.in/api/users?page=$page',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = (response.data["data"]);
        final List<User> users = dataList.map((e) => User.fromJson(e)).toList();
        return users;
      }

      return [];
    } catch (e) {
      print("Catched Error${e}");
      return [];
    }
  }
}
