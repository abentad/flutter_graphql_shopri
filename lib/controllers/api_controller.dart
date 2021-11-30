import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:shopri/constants/api_path.dart';
import 'package:shopri/controllers/query_controller.dart';
import 'package:shopri/views/home_screen.dart';
import 'package:transition/transition.dart' as transition;

class ApiController extends GetxController {
  Map<String, dynamic>? _loggedInUserInfo;
  Map<String, dynamic>? get loggedInUserInfo => _loggedInUserInfo;
  //local
  String? _token;
  GraphQLClient? _client;
  final List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;
  int? _totalPage;
  String apiTokenStorageKey = "apiToken";
  final storage = const FlutterSecureStorage();

//
//
//
//
//
//
//
//
//
  //* will set loggedInUserInfo variable to the value passed through this function
  void setLoggedInUserInfo(Map<String, dynamic> userInfo) {
    _loggedInUserInfo = userInfo;
    update();
  }

  //* gets auth token from secure storage
  Future<String?> getAuthToken() async {
    String? apiToken = await storage.read(key: apiTokenStorageKey);
    if (apiToken == null) {
      return null;
    } else {
      _token = apiToken;
      update();
      return apiToken;
    }
  }

  //*will check if there is actually a token in secure storage
  Future<bool> checkIfUserIsLoggedIn() async {
    String? apiToken = await getAuthToken();
    if (apiToken == null) {
      return false;
    }
    return true;
  }

  //*will set client of graphql api with the auth token as a header
  void setClient() {
    final _httpLink = HttpLink(kbaseUrl);
    final _authLink = AuthLink(getToken: () async => 'Bearer $_token');
    Link _link = _authLink.concat(_httpLink);
    _client = GraphQLClient(cache: GraphQLCache(), link: _link);
  }

  //! this should be replaced with sign in with phone only using firebase
  Future<bool> signInWithEmailandPass({required String email, required String password}) async {
    final QueryOptions options = QueryOptions(
      document: gql(Get.find<QueryController>().loginUserByEmailandPass(email: email, password: password)),
      variables: <String, dynamic>{},
    );
    final QueryResult result = await _client!.query(options);
    _loggedInUserInfo = result.data!['loginUser'];
    print(_loggedInUserInfo);
    await storage.write(key: apiTokenStorageKey, value: _loggedInUserInfo!['token']);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    update();
    return true;
  }

  //* signs in user using auth token found in _token variable
  void signInWithToken(BuildContext context) async {
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().loginUserByToken), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    }
    _loggedInUserInfo = result.data!['loginUserByToken'];
    if (_loggedInUserInfo != null) {
      Navigator.pushReplacement(
        context,
        transition.Transition(
            child: HomeScreen(
              userInfo: _loggedInUserInfo,
            ),
            transitionEffect: transition.TransitionEffect.FADE,
            curve: Curves.easeIn),
      );
    }
  }

  //* fetchs products by using the page passed through it
  Future<String> getProducts(int page) async {
    if (page == 1) {
      _products.clear();
      _totalPage = 0;
      update();
    }
    if (page <= _totalPage! || page == 1) {
      print("page to load " + page.toString());
      Future.delayed(const Duration(seconds: 2), () async {
        final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().getProducts(page)), variables: <String, dynamic>{});
        final QueryResult result = await _client!.query(options);
        if (result.hasException) {
          print(result.exception.toString());
          return "fail";
        }
        if (page == 1) {
          _totalPage = result.data!['products']['pages'];
          print("TotalPage: " + _totalPage.toString());
        }
        List productsFromApi = result.data!['products']['products'];
        for (var product in productsFromApi) {
          _products.add(product);
        }
        update();
      });
    } else {
      return "over";
    }
    return "done";
  }
}
