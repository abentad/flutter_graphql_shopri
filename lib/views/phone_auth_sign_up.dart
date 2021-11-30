import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopri/controllers/api_controller.dart';
import 'package:shopri/utils/phone_number_corrector.dart';
import 'package:shopri/views/components/custom_material_button.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PhoneAuthSignUp extends StatefulWidget {
  const PhoneAuthSignUp({Key? key}) : super(key: key);

  @override
  _PhoneAuthSignUpState createState() => _PhoneAuthSignUpState();
}

class _PhoneAuthSignUpState extends State<PhoneAuthSignUp> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(child: Center(child: Lottie.asset('assets/sms.json', height: size.height * 0.25, width: size.width * 0.25, repeat: false))),
            const Text('OTP Verification', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: RichText(
                text: const TextSpan(
                  text: 'We will send you a',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' One Time Password',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: ' on this mobile number',
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.06),
            const Text('Enter Mobile Number', style: TextStyle(color: Colors.grey, fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextFormField(
                autofocus: true,
                onChanged: (value) {},
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                cursorColor: Colors.black,
                style: const TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text("+251", style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomMaterialButton(
                onPressed: () {
                  if (_phoneNumberController.text.isNotEmpty) {
                    String phone = checkPhoneNumber(_phoneNumberController.text);
                    if (phone != "error") {
                      Get.find<ApiController>().verifyPhone(phone, context);
                      // Navigator.push(
                      //     context, transition.Transition(child: PhoneOtpVerificationScreen(phoneNumber: phone), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
                    }
                  }
                },
                btnLabel: "Continue",
              ),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}

class PhoneOtpVerificationScreen extends StatefulWidget {
  const PhoneOtpVerificationScreen({Key? key, required this.phoneNumber, required this.verificationId, required this.forceResend}) : super(key: key);
  final String phoneNumber;
  final String verificationId;
  final int? forceResend;

  @override
  _PhoneOtpVerificationScreenState createState() => _PhoneOtpVerificationScreenState();
}

class _PhoneOtpVerificationScreenState extends State<PhoneOtpVerificationScreen> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: Colors.grey.shade400),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(child: Center(child: Lottie.asset('assets/sms.json', height: size.height * 0.25, width: size.width * 0.25, repeat: false))),
            const Text('OTP Verification', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: RichText(
                text: TextSpan(
                  text: 'Enter the OTP sent to',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' ${widget.phoneNumber}',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PinPut(
                fieldsCount: 6,
                autofocus: true,
                withCursor: false,
                cursorColor: Colors.black,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                eachFieldWidth: size.width * 0.12,
                eachFieldHeight: size.height * 0.08,
                // onSubmit: (String pin) => _showSnackBar(pin),
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomMaterialButton(
                onPressed: () {
                  Get.find<ApiController>().checkCode(widget.verificationId, _pinPutController.text.trim(), context);
                },
                btnLabel: "Verify",
              ),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
