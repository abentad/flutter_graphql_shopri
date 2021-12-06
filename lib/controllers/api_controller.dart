import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:shopri/constants/api_path.dart';
import 'package:shopri/controllers/query_controller.dart';
import 'package:shopri/views/auth_choice.dart';
import 'package:shopri/views/home_screen.dart';
import 'package:shopri/views/phone_auth_sign_up.dart';
import 'package:shopri/views/user_info_sign_up_screen.dart';
import 'package:transition/transition.dart' as transition;
import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';

class ApiController extends GetxController {
  Map<String, dynamic>? _loggedInUserInfo;
  Map<String, dynamic>? get loggedInUserInfo => _loggedInUserInfo;
  String? _token;
  GraphQLClient? _client;
  final List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;
  int? _totalPage;
  String apiTokenStorageKey = "apiToken";
  final storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final List<File?> _productImages = [];
  List<File?> get productImages => _productImages;
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

  void addToProductImages(File? imageFile) {
    _productImages.add(imageFile);
    update();
  }

  void removeFromProductImages(int index) {
    _productImages.removeAt(index);
    update();
  }

  void setAuthToken(String token) async {
    _token = token;
    await storage.write(key: apiTokenStorageKey, value: _token);
    update();
  }

  //*will check if there is actually a token in secure storage
  Future<bool> checkIfUserIsLoggedIn() async {
    String? apiToken = await storage.read(key: apiTokenStorageKey);
    if (apiToken == null) {
      return false;
    } else {
      _token = apiToken;
      update();
      return true;
    }
  }

  //*will set client of graphql api with the auth token as a header
  void setClient() {
    final _httpLink = HttpLink(kbaseUrl);
    final _authLink = AuthLink(getToken: () async => 'Bearer $_token');
    Link _link = _authLink.concat(_httpLink);
    _client = GraphQLClient(cache: GraphQLCache(), link: _link);
  }

  void signUpUser(File file, String deviceToken, username, email, phoneNumber, BuildContext context) async {
    final myFile = await http.MultipartFile.fromPath('profileImage', file.path, contentType: MediaType('image', 'jpeg'));
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().signUpUser()),
      variables: <String, dynamic>{
        'file': myFile,
        'deviceToken': deviceToken,
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'dateJoined': DateTime.now().toString(),
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) print(result.exception.toString());
    if (result.data != null) {
      setAuthToken(result.data!['createUser']['token']);
      setLoggedInUserInfo(result.data!['createUser']['user']);
      if (_loggedInUserInfo != null) {
        Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
      }
    } else {
      print("data: $result.data");
    }
    update();
  }

  void addProduct(String name, String price, String? category, String description, BuildContext context) async {
    List<http.MultipartFile> _productMultipartImages = [];
    for (var xfile in _productImages) {
      final myFile = await http.MultipartFile.fromPath('productImage', File(xfile!.path).path, contentType: MediaType('image', 'jpeg'));
      _productMultipartImages.add(myFile);
    }
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().addProduct()),
      variables: <String, dynamic>{
        'files': _productMultipartImages,
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'datePosted': DateTime.now().toString(),
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) print(result.exception.toString());
    if (result.data != null) {
      Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.data!['createProduct']['name'] + " has been successfully added.", style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white));
    } else {
      print("data: $result.data");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Adding $name Failed", style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white));
    }
    update();
  }

  //* for verifying phoneNumber using firebase
  void verifyPhone(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      // * this call back gets called when the verification is done automatically
      verificationFailed: (error) => print(error),
      verificationCompleted: (phoneAuthCredential) async {
        Navigator.pop(context);
        UserCredential result = await _auth.signInWithCredential(phoneAuthCredential);
        if (result.user != null) {
          user = result.user;
          print("phoneNumber: " + user!.phoneNumber.toString());
          Map<String, dynamic>? _data = await findUserByPhoneNumberAndSignIn(phoneNumber);
          if (_data == null) {
            Navigator.pushReplacement(context, transition.Transition(child: UserInfoSignUpScreen(phoneNumber: phoneNumber), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
          } else {
            setAuthToken(_data['userByPhone']['token']);
            setLoggedInUserInfo(_data['userByPhone']['user']);
            if (_loggedInUserInfo != null) {
              Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong with sms code')));
        }
      },
      codeSent: (verificationId, forceResendingToken) async {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          builder: (context) => PhoneOtpVerificationScreen(phoneNumber: phoneNumber, verificationId: verificationId, forceResend: forceResendingToken),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    update();
  }

  //* is called from the PhoneOtpVerificationScreen
  void checkCode(String verificationId, String smsCode, BuildContext context, String phoneNumber) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    UserCredential result = await _auth.signInWithCredential(credential);
    if (result.user != null) {
      user = result.user;
      print("*phoneNumber: " + user!.phoneNumber.toString());
      Map<String, dynamic>? _data = await findUserByPhoneNumberAndSignIn(phoneNumber);
      if (_data == null) {
        Navigator.pushReplacement(context, transition.Transition(child: UserInfoSignUpScreen(phoneNumber: phoneNumber), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
      } else {
        setAuthToken(_data['userByPhone']['token']);
        setLoggedInUserInfo(_data['userByPhone']['user']);
        if (_loggedInUserInfo != null) {
          Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong with sms code')));
    }
    update();
  }

  void signOutUser(BuildContext context) async {
    await storage.write(key: apiTokenStorageKey, value: null);
    Navigator.pushAndRemoveUntil(context, transition.Transition(child: const AuthChoice(), transitionEffect: transition.TransitionEffect.LEFT_TO_RIGHT), (route) => false);
  }

  Future<Map<String, dynamic>?> findUserByPhoneNumberAndSignIn(String phoneNumber) async {
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().findUserByPhoneNumber(phoneNumber: phoneNumber)), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) print(result.exception.toString());
    Map<String, dynamic>? _data = result.data;
    return _data;
  }

  //* signs in user using auth token found in _token variable
  void signInWithToken(BuildContext context) async {
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().loginUserByToken), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) print(result.exception.toString());
    setLoggedInUserInfo(result.data!['loginUserByToken']);
    if (_loggedInUserInfo != null) {
      Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
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
    } else {
      return "over";
    }
    return "done";
  }
}
