import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/appbar.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/otp.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

import '../../../common/widgets/custom_snackbar_widget.dart';

class Phone extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const Phone(
      {super.key, required this.exitFromApp, required this.backFromThis});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController phoneController = TextEditingController();

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Container(
          height: 378,
          decoration: BoxDecoration(
              color: const Color(0xffF55E1E).withOpacity(0.09),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraOverLarge,
                horizontal: Dimensions.paddingSizeExtraLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ' +91',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                loading21 == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () {
                          _login();
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              color: const Color(0xff090018),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  color: Get.theme.cardColor,
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        body: GetBuilder<AuthController>(
          builder: (controller) {
            return ListView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              children: [
                Text(
                  "Enter Phone Number For\nLogin or Signup",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: Dimensions.fontSizeOverLarge),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "We’ll send an OTP for verification",
                  style: TextStyle(
                    color: Get.theme.disabledColor,
                    fontFamily: 'Poppins',
                  ),
                )
              ],
            );
          },
        ));
  }

  bool loading21 = false;
  _login() async {
    setState(() {
      loading21 = true;
    });

    String phone = phoneController.text.trim();

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

    // setState(() {
    //   loading21 = false;
    // });
  }
}
