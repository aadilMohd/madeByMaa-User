import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/register.dart';
import 'package:stackfood_multivendor/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import '../../../common/widgets/custom_snackbar_widget.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';

class Otp extends StatefulWidget {
  final String phone;

  const Otp({super.key, required this.phone});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    loading21 = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.cardColor,
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        children: [
          Text(
            "Confirm Your Number",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: Dimensions.fontSizeOverLarge),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Enter the code we’ve sent to your number",
            style: TextStyle(
              color: Get.theme.disabledColor,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF512DA8),
            showFieldAsBox: true,
            fieldHeight: 48,
            contentPadding: const EdgeInsets.all(5),
            fieldWidth: 48,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            onCodeChanged: (String code) {
              setState(() {
                otpController.text = code;
                // isOtpComplete = code.length == 4;
              });
            },
            onSubmit: (String code) {
              setState(() {
                otpController.text = code;
                if (otpController.text.length < 4) {
                  showCustomSnackBar("OTP must be 6 digits", isError: true);
                } else {
                  // isOtpComplete = true;
                }
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn’t received any code?",
                style: TextStyle(
                    fontFamily: 'Poppins', color: Get.theme.disabledColor),
              ),
              InkWell(
                onTap: () {
                  _login();
                },
                child: const Text(
                  " Send Again",
                  style: TextStyle(
                      color: Color(0xff007AFF), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Obx(() => Get.find<AuthController>().isLoadingotp.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : InkWell(
                  onTap: () {
                    otp();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xff090018),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: Get.theme.cardColor,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  otp() {
    Get.find<AuthController>()
        .loginOtp(phone: widget.phone, otp: otpController.text)
        .then((value) {
      print("======${value}");

      if (value.isSuccess) {
        print("====----==${value.isSuccess}");

        if (Get.find<AuthController>().isSignup == 0) {
          // if (Get.find<AuthController>().status.toString() == "false") {
          Get.offAll(() => Register(
                phone_number: widget.phone,
              ));
        } else {
          Get.offAll(() => const DashboardScreen(pageIndex: 0));
        }
      } else {
        value.message == "Forbidden"
            ? showCustomSnackBar("Invalid Otp")
            : showCustomSnackBar(value.message);
      }
    });
  }

  bool loading21 = false;
  _login() async {
    setState(() {
      loading21 = true;
    });
    String phone = "+91${widget.phone}";

    //   Get.find<AuthController>().login1(phone).then((status) async {
    //   if (status.isSuccess) {
    //     Get.to(() => Otp());
    //   } else {
    //     showCustomSnackBar(status.message);
    //   }
    // }

    Get.find<AuthController>().login1(phone).then((value) {
      if (value.isSuccess) {
        Get.to(() => Otp(
              phone: phone,
            ));
        setState(() {
          loading21 = false;
        });
      } else {
        showCustomSnackBar(value.message);
      }
    });
  }
}
