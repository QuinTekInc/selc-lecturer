


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selc_lecturer/components/preferences_util.dart';
import 'package:selc_lecturer/models/models.dart';
import 'package:selc_lecturer/components/server_connector.dart' as connector;


class SelcProvider extends ChangeNotifier{

  Lecturer? _lecturer;
  Lecturer get lecturer => _lecturer!;


  int? currentSemester;
  bool enableEvaluations = true;


  List<ClassCourse> courses = [];


  Future<void> login({required String username, required String password}) async {

    final response = await connector.postRequest(
        endpoint: 'login/',
        body: jsonEncode({'username': username, 'password': password})
    );


    if(response.statusCode == 401 || response.statusCode == 403){
      throw Exception(jsonDecode(response.body)['message']);
    }

    if(response.statusCode != 200) throw Error();


    Map<String, dynamic> responseBody = jsonDecode(response.body);

    _lecturer = Lecturer.fromJson(responseBody);


    await saveAuthorizationToken(responseBody['auth_token']);

    currentSemester = responseBody['current_semester'];
    enableEvaluations = responseBody['enable_evaluations'];

    notifyListeners();

  }


  Future<void> logout() async {

    final response = await connector.getRequest(endpoint:'logout/');

    if(response.statusCode != 200){
      throw Error();
    }


    courses.clear();

  }


  Future<void> loadCourses() async {

    final response = await connector.getRequest(endpoint:'get-courses/');

    if(response.statusCode != 200){
      throw Error();
    }


    List<dynamic> responseBody = jsonDecode(response.body);

    courses = responseBody.map((jsonMap) => ClassCourse.fromJson(jsonMap)).toList();

    notifyListeners();

  }




  Future<List<QuestionnaireEvaluation>> loadQuestionnaireEvaluations(int classCourseId) async{

    final response = await connector.getRequest(endpoint: 'get-course-eval/$classCourseId');

    if(response.statusCode != 200){
      throw Error();
    }


    List<dynamic> responseBody = jsonDecode(response.body);

    return responseBody.map((jsonMap) => QuestionnaireEvaluation.fromJson(jsonMap)).toList();
  }


  Future<List<CategorySummary>> loadCategorySummary(int classCourseId) async{

    final response = await connector.getRequest(endpoint: 'get-course-cat-eval/$classCourseId');

    if(response.statusCode != 200){
      throw Error();
    }


    List<dynamic> responseBody = jsonDecode(response.body);

    return responseBody.map((jsonMap) => CategorySummary.fromJson(jsonMap)).toList();
  }



  Future<List<LecturerRatingSummary>> loadCourseLRatingSummary(int classCourseId) async{

    final response = await connector.getRequest(endpoint: 'get-course-lrating-eval/$classCourseId');

    if(response.statusCode != 200){
      throw Error();
    }


    List<dynamic> responseBody = jsonDecode(response.body);

    print(responseBody);

    return responseBody.map((jsonMap) => LecturerRatingSummary.fromJson(jsonMap)).toList();
  }

}