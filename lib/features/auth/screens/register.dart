import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/add_profile_photo.dart';

import '../../../common/widgets/custom_text_field_widget.dart';
import '../../../common/widgets/validate_check.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../language/controllers/localization_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../domain/models/signup_body_model.dart';

class Register extends StatefulWidget {
  final phone_number;
  const Register({super.key, this.phone_number});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController(
      text: widget.phone_number
          .toString() //.startsWith("+91")?widget.phone_number.toString().replaceAll("+91", ""):widget.phone_number.toString().replaceAll("91", "")
      );

  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;
  GlobalKey<FormState>? _formKeySignUp;

  @override
  void initState() {
    super.initState();
    _formKeySignUp = GlobalKey<FormState>();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
  }

  bool isChecked = false;
  void toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
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
            "Setup Your Profile",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: Dimensions.fontSizeOverLarge),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Enter the information & unlock better experience",
            style: TextStyle(
              color: Get.theme.disabledColor,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: const Color(0xffFBF8FF),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name & Number",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xff524A61)),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      labelText: "First Name*",
                      filled: true,
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      labelText: "Last Name*",
                      filled: true,
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
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                  hintText: 'enter_phone_number'.tr,
                  labelText: 'phone'.tr,
                  showLabelText: true,
                  required: true, readonly: true,
                  controller: _phoneController,
                  // focusNode: _phoneFocus,
                  // nextFocus: ResponsiveHelper.isDesktop(context) ? _passwordFocus : _emailFocus,
                  inputType: TextInputType.phone,
                  isPhone: true,
                  onCountryChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryDialCode != null
                      ? CountryCode.fromCountryCode(Get.find<SplashController>()
                              .configModel!
                              .country!)
                          .code
                      : Get.find<LocalizationController>().locale.countryCode,
                  validator: (value) => ValidateCheck.validateEmptyText(
                      value, "phone_number_field_is_required".tr),
                ),

                // SizedBox(height: 50,
                //   child: TextFormField(
                //     controller: _phoneController,
                //
                //     keyboardType: TextInputType.phone,maxLength: 10,
                //
                //     decoration: InputDecoration(counterText: "",
                //       contentPadding: const EdgeInsets.symmetric(vertical: 5),
                //       labelText: "Phone Number*",
                //       fillColor: Colors.white,
                //       filled: true,
                //       prefixIcon: const Padding(
                //         padding: EdgeInsets.only(left: 8.0, right: 8.0),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               ' +91',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 16,
                //               ),
                //             ),
                //             SizedBox(
                //               height: 30,
                //               child: VerticalDivider(
                //                 color: Colors.grey,
                //                 thickness: 2,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide: const BorderSide(
                //           color: Colors.grey,
                //           width: 1.5,
                //         ),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide: const BorderSide(
                //           color: Colors.grey,
                //           width: 1.5,
                //         ),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         borderSide: const BorderSide(
                //           color: Colors.grey,
                //           width: 1.5,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      labelText: "Enter Email*",
                      filled: true,
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
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: const Color(0xffFBF8FF),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Referral Code ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xff524A61)),
                    ),
                    Text(
                      "(Optional)",
                      style: TextStyle(color: Get.theme.disabledColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _referCodeController,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      labelText: "Enter Code",
                      filled: true,
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: toggleCheckbox,
              ),
              const Text(
                "I agree with all ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Color(0xff524A61)),
              ),
              const Text(
                "Terms & Conditions",
                style: TextStyle(
                    color: Color(0xff5E1EAA), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: isChecked == false
                ? null
                : () {
                    register();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: isChecked == false
                      ? Get.theme.disabledColor
                      : const Color(0xff090018),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "Signup",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Get.theme.cardColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeLarge),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  register() async {
    SignUpBodyModel? signUpModel = SignUpBodyModel(
        phone: _phoneController.text,
        email: _emailController.text,
        fName: _firstNameController.text,
        lName: _lastNameController.text,
        refCode: _referCodeController.text);

    Get.find<AuthController>().registration1(signUpModel).then((value) {
      if (value.isSuccess) {
        Get.to(() => const AddProfilePhoto());
      } else {
        showCustomSnackBar(value.message);
      }
    });
  }
}
