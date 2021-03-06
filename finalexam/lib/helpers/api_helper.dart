
import 'dart:convert';

import 'package:finalexam/Models/finals.dart';
import 'package:finalexam/Models/response.dart';
import 'package:finalexam/Models/token.dart';
import 'package:finalexam/helpers/constans.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

  static Future<Response> post(String controller, Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    
    var url = Uri.parse('${Constans.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  static Future<Response> getFinals(Token token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
   var decodeJson = jsonDecode(body);
    return Response(isSuccess: true, result: Finals.fromJson(decodeJson));
  }

    static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }
  
}