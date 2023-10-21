import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final String authKey = 'x-api-token';

  final Dio _dio = Dio();
  final _baseUrl = 'http://localhost:8000';

  Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(authKey) ?? '';
  }

  Future<bool> isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(authKey);
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('$_baseUrl/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(authKey, response.data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> refreshAuthToken() async {
    try {
      // add header x-api-token
      final response = await _dio.post('$_baseUrl/auth/refresh',
          options: Options(headers: {
            'x-api-token': await getAuthToken(),
          }));

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(authKey, response.data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
