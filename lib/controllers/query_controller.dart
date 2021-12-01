import 'dart:io';

import 'package:get/get.dart';

class QueryController extends GetxController {
  String getProducts(int page) {
    return """
        query{
          products(page: 1, limit: 15){
            count
            pages
            products{
              id
              views
              name
              price
              description
              category
              image
              datePosted
              images{
                image_id
                url
              }
              poster{
                id
                deviceToken 
                username
                email
                phoneNumber
                profile_image
                dateJoined
              }
            }
          }
        }
    """;
  }

  final String loginUserByToken = """
      mutation{
        loginUserByToken{
          id
          username
          email
          profile_image
          phoneNumber
          dateJoined
        }
      }
  """;

  String loginUserByEmailandPass({required String email, required String password}) {
    return """
        mutation{
          loginUser(data: {email: "$email", password: "$password"}){
            token
            user{
              id
              deviceToken
              username
              email
              phoneNumber
              profile_image
              dateJoined 
            }
          }
        }
    """;
  }

  String signUpUser() {
    return r"""
        mutation ($file: Upload!, $deviceToken: String!, $username: String!, $email: String!, $phoneNumber: String!, $dateJoined: String!) {
            createUser(
              data: {deviceToken: $deviceToken, username: $username, email: $email, phoneNumber: $phoneNumber, dateJoined: $dateJoined}
              file: $file
            ) {
              token
              user {
                id
                deviceToken
                username
                email
                phoneNumber
                profile_image
                dateJoined
              }
            }
          }
    """;
  }

  String findUserByPhoneNumber({required String phoneNumber}) {
    return """
        {
          userByPhone(phoneNumber: "$phoneNumber"){
            token
            user{
              id
              deviceToken
              username
              email
              phoneNumber
              profile_image
              dateJoined
            }
          }
        }
    """;
  }
}
