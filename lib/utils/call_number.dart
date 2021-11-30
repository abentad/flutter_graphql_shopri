import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Future<bool?> callNumber(String number) async {
  bool? res = await FlutterPhoneDirectCaller.callNumber("0" + number);
  return res;
}
