import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import 'common/widgets/custom_button_widget.dart';
import 'common/widgets/custom_snackbar_widget.dart';
import 'common/widgets/custom_text_field_widget.dart';
import 'common/widgets/footer_view_widget.dart';
import 'features/address/controllers/address_controller.dart';
import 'features/address/domain/models/address_model.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/language/controllers/localization_controller.dart';
import 'features/location/controllers/location_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'helper/custom_validator.dart';
import 'helper/responsive_helper.dart';

class CustomBottomSheet extends StatefulWidget {

  final bool fromCheckout;
  final int? zoneId;
  final AddressModel? address;
  final bool forGuest;
  final ScrollController scrollController;
  final bool otherSelect;
  final TextEditingController addressController;
  final TextEditingController levelController;
  final FocusNode addressNode;
  final FocusNode levelNode;
  final FocusNode nameNode;

   CustomBottomSheet({
    required this.scrollController,
    required this.otherSelect,
    required this.addressController,
     required this.levelController,
     required  this.addressNode,
     required this.levelNode,
     required   this.nameNode,
    required this.fromCheckout,
    this.zoneId,
    this.address,
    required this.forGuest,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> with WidgetsBindingObserver{
  final ScrollController scrollController = ScrollController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonNumberController =
      TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _levelNode = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  bool isKeyboardVisible = false;

  // CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  bool _otherSelect = false;
  bool isDesktop = false;

  String? _countryDialCode =
      Get.find<AuthController>().getUserCountryCode().isNotEmpty
          ? Get.find<AuthController>().getUserCountryCode()
          : CountryCode.fromCountryCode(
                  Get.find<SplashController>().configModel!.country!)
              .dialCode;

  @override
  initState() {
    super.initState();

  _initCall();
  }

  void _initCall() {

  // Get.find<LocationController>().streetName = widget.address!.stateName;
  // Get.find<LocationController>().countryName = widget.address!.countryName;
  // Get.find<LocationController>().stateName  =  widget.address!.stateName;
  // Get.find<LocationController>().cityName  =  widget.address!.cityName;
  // Get.find<LocationController>().pincode  =  widget.address!.pincode;


    WidgetsBinding.instance.addObserver(this);
    Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }

    if (widget.address?.id==null) {
      _initialPosition = LatLng(
        double.parse(
            Get.find<SplashController>().configModel?.defaultLocation?.lat ??
                '0'),
        double.parse(
            Get.find<SplashController>().configModel?.defaultLocation?.lng ??
                '0'),
      );
      _addressController.text = widget.address!.address!;// _pickAddress
    } else {
      Get.find<LocationController>().updateAddress(widget.address!);
print('000000000${widget.address!.description}');
     if(widget.address!.description!=null) {
       _descriptionController.text = widget.address!.description!;
     }
      _initialPosition = LatLng(
        double.parse(widget.address?.latitude ?? '0'),
        double.parse(widget.address?.longitude ?? '0'),

      );

      if(widget.address?.address!=null){
      _addressController.text = widget.address!.address!;
      _levelController.text = Get.find<LocationController>().cityName??"";
      }

      if (widget.address?.addressType == 'home') {
        Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
      } else if (widget.address?.addressType == 'office') {
        Get.find<LocationController>().setAddressTypeIndex(1, notify: false);
      } else {
        Get.find<LocationController>().setAddressTypeIndex(2, notify: false);
        _levelController.text = Get.find<LocationController>().cityName??"";
        // _levelController.text = widget.address?.addressType ?? '';
        _otherSelect = true;
      }
      _contactPersonNumberController.text = "+91 ${widget.address!.contactPersonNumber??" "}";
     // _splitPhoneNumber(widget.address!.contactPersonNumber!);
      _contactPersonNameController.text =
          widget.address!.contactPersonName ?? '';
      _emailController.text = widget.address!.email ?? '';
      _streetNumberController.text = widget.address!.road ?? '';
      _houseController.text = widget.address!.house ?? '';
      _floorController.text = widget.address!.floor ?? '';
    }
    //isDesktop = ResponsiveHelper.isDesktop(context);
  }


  // void _splitPhoneNumber(String number) async {
  //   PhoneValid phoneNumber = await CustomValidator.isPhoneValid(number);
  //   _countryDialCode = '+${phoneNumber.countryCode}';
  //   _contactPersonNumberController.text =
  //       phoneNumber.phone.replaceFirst('+${phoneNumber.countryCode}', '');
  // }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    final isVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0;
    if (isVisible != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = isVisible;
      });
    }
  }
  LocationController locationController = Get.find<LocationController>();
  @override
  Widget build(BuildContext context) {

    return Container(

        padding: const EdgeInsets.all(16.0),
        color: const Color(0xffFBF8FF),
        child: ListView(
          controller: widget.scrollController,
          children: [
            Container(
                color: const Color(0xffFBF8FF),
                child: Center(
                    child: Image.asset(
                  Images.up,
                  height: 10,
                  width: 50,
                ))),
            Text(
              "Enter Complete Address ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff524A61),
                  fontSize: Dimensions.fontSizeLarge),
            ),
            const Divider(),
            // Text('label_as'.tr, style: robotoRegular),
            // const SizedBox(height: Dimensions.paddingSizeSmall),
            // SizedBox(
            //   height: 30,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: locationController.addressTypeList.length,
            //     itemBuilder: (context, index) => Padding(
            //       padding:
            //           const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
            //       child: InkWell(
            //         onTap: () {
            //           _otherSelect = index == 2;
            //           locationController.setAddressTypeIndex(index,
            //               notify: true);
            //           setState(() {});
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: Dimensions.paddingSizeDefault,
            //               vertical: Dimensions.paddingSizeExtraSmall),
            //           decoration: BoxDecoration(
            //             borderRadius:
            //                 BorderRadius.circular(Dimensions.radiusDefault),
            //             color: locationController.addressTypeIndex == index
            //                 ?  const Color(0xff090018)
            //                 : null,
            //             border: Border.all(
            //                 color: locationController.addressTypeIndex == index
            //                     ? Theme.of(context).cardColor
            //                     :  const Color(0xff090018),),
            //           ),
            //           child: Row(children: [
            //             SizedBox(
            //               height: 13,
            //               width: 13,
            //               child: Image.asset(
            //                 index == 0
            //                     ? Images.home2
            //                     : index == 1
            //                         ? Images.bag2
            //                         : Images.addLocation,
            //                 color: locationController.addressTypeIndex == index
            //                     ? Theme.of(context).cardColor
            //                     : const Color(0xff090018),
            //               ),
            //             ),
            //             SizedBox(
            //                 width: ResponsiveHelper.isDesktop(context)
            //                     ? Dimensions.paddingSizeSmall
            //                     : Dimensions.paddingSizeSmall),
            //             // ResponsiveHelper.isDesktop(context)
            //             //     ?
            //             Text(
            //                     index == 0
            //                         ? 'home'.tr
            //                         : index == 1
            //                             ? 'office'.tr
            //                             : 'others'.tr,
            //                     style: robotoRegular.copyWith(
            //                       fontSize: Dimensions.fontSizeSmall,
            //                       color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor :  const Color(0xff090018),
            //                     ),
            //                   )
            //                 // : const SizedBox(),
            //           ]),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //     height: _otherSelect ? 10: 0),
            // _otherSelect
            //     ? CustomTextFieldWidget(
            //         hintText: '${'level_name'.tr} (${'optional'.tr})',
            //         labelText: 'level_name'.tr,
            //         inputType: TextInputType.text,
            //         controller: _levelController,
            //         focusNode: _levelNode,
            //         nextFocus: _addressNode,
            //         capitalization: TextCapitalization.words,
            //         showBorder: true,
            //       )
            //     : const SizedBox(),

             SizedBox(
                 height:_otherSelect?

                 Dimensions.paddingSizeOverLarge:0),
            CustomTextFieldWidget(
              hintText: "Enter Address",
              labelText: "Enter Address",
              // hintText: 'delivery_address'.tr,
              // labelText: 'delivery_address'.tr,
              required: true,
              inputType: TextInputType.streetAddress,
              focusNode: _addressNode,
              nextFocus: _nameNode,
              controller: _addressController,
              onChanged: (text) => locationController.setPlaceMark(text),
              showBorder: true,
            ),
            // SizedBox(
            //     height: ResponsiveHelper.isDesktop(context)
            //         ? Dimensions.paddingSizeLarge
            //         : Dimensions.paddingSizeOverLarge),
            FooterViewWidget(
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Expanded(
                                  flex: 6,
                                  child: addressSectionWidget(
                                      locationController, isDesktop)),
                              const SizedBox(
                                  width: Dimensions.paddingSizeLarge),
                              Expanded(
                                  flex: 4,
                                  child: informationSectionWidget(
                                      locationController, isDesktop)),
                            ])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              addressSectionWidget(
                                  locationController, isDesktop),
                              informationSectionWidget(
                                  locationController, isDesktop),
                            ]),
                ),
              ),
            ),
            SizedBox(height: isKeyboardVisible?Get.height*0.35:0,),

          ],
        ));
  }

  Widget addressSectionWidget(
      LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop
          ? BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            )
          : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : 0),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // const SizedBox(height: Dimensions.paddingSizeSmall),
        // Center(
        //     child: Text(
        //   'add_the_location_correctly'.tr,
        //   style: robotoRegular.copyWith(
        //       color: Get.theme.disabledColor,
        //       fontSize: Dimensions.fontSizeExtraSmall),
        // )),
        SizedBox(height: Dimensions.paddingSizeLarge),
      ]),
    );
  }

  Widget informationSectionWidget(
      LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop
          ? BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            )
          : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeOverLarge : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomTextFieldWidget(
          labelText: "Receiver’s Name",
          hintText: "Receiver’s Name",
          // hintText: 'contact_person_name'.tr,
          // labelText: 'contact_person_name'.tr,
          required: true,
          inputType: TextInputType.name,
          controller: _contactPersonNameController,
          focusNode: _nameNode,
          nextFocus: _numberNode,
          capitalization: TextCapitalization.words,
          showBorder: true,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        CustomTextFieldWidget(
          hintText: 'receiver_phone_number'.tr,
          labelText: 'receiver_phone_number'.tr,
           required: true,
          controller: _contactPersonNumberController,
          focusNode: _numberNode,
          nextFocus: widget.forGuest ? _emailFocus : _streetNode,
          inputType: TextInputType.phone,
          onChanged: (String value) {

            _contactPersonNumberController.text =  "+91 ${value.replaceAll("91", "")}";

          },
          //isPhone: true,
          // onCountryChanged: (CountryCode countryCode) {
          //   _countryDialCode = countryCode.dialCode;
          // },
          //
          // countryDialCode:
          // _countryDialCode ??
          //     Get.find<LocalizationController>().locale.countryCode,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        widget.forGuest
            ? CustomTextFieldWidget(
                hintText: '${'email'.tr} (${'optional'.tr})',
                labelText: 'email'.tr,
                controller: _emailController,
                focusNode: _emailFocus,
                nextFocus: _streetNode,
                inputType: TextInputType.emailAddress,
              )
            : const SizedBox(),
        SizedBox(height: widget.forGuest ? Dimensions.paddingSizeOverLarge : 0),
        Text("Save Address As",style: TextStyle(color: Get.theme.hintColor,fontWeight: FontWeight.w500),),
        const Divider(thickness: 1,),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        SizedBox(
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: locationController.addressTypeList.length,
            itemBuilder: (context, index) => Padding(
              padding:
              const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
              child: InkWell(
                onTap: () {
                  _otherSelect = index == 2;

                  locationController.setAddressTypeIndex(index,
                      notify: true);
                  setState(() {});
                },
                child:

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(Dimensions.radiusDefault),
                    color: locationController.addressTypeIndex == index
                        ? index==2?const Color(0xffE0E0E0):  const Color(0xff090018)
                        : null,
                    border: Border.all(
                      color: locationController.addressTypeIndex == index
                          ? Theme.of(context).cardColor
                          :  const Color(0xff090018),),
                  ),
                  child:
                  (index == 2&&_otherSelect)
                      ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Aligns items properly
                    children: [
                      const Icon(
                        Icons.add_location_outlined,
                        color: Color(0xff090018),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        // padding: EdgeInsets.all(Dimensions.paddingSizeSmall2+2),
                        height: 30,width: 100,
                        child: TextFormField(
                          cursorHeight: 18,style: TextStyle(fontSize: Dimensions.fontSizeSmall),
                          controller: _levelController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4), // Adds padding for better spacing
                            isDense: true, // Reduces overall height of the field
                            border: InputBorder.none, // Removes border lines
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )

                      :

                  Row(children: [
                    SizedBox(
                      height: 13,
                      width: 13,
                      child: Image.asset(
                        index == 0
                            ? Images.home2
                            : index == 1
                            ? Images.bag2
                            : Images.addLocation,
                        color: locationController.addressTypeIndex == index
                            ? Theme.of(context).cardColor
                            : const Color(0xff090018),
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.paddingSizeSmall
                            : Dimensions.paddingSizeSmall),
                    // ResponsiveHelper.isDesktop(context)
                    //     ?
                    Text(
                      index == 0
                          ? 'home'.tr
                          : index == 1
                          ? 'office'.tr
                          : 'others'.tr,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: locationController.addressTypeIndex == index ? Theme.of(context).cardColor :  const Color(0xff090018),
                      ),
                    )
                    // : const SizedBox(),
                  ]),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault,),


        CustomTextFieldWidget(
          hintText: '${'street_number'.tr} (${'optional'.tr})',
          labelText: "Flat / House no. / Floor / Building",
          inputType: TextInputType.streetAddress,

          focusNode: _streetNode,
          nextFocus: _houseNode,
          controller: _streetNumberController,
        ),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        // Row(children: [
        //   Expanded(
        //     child: CustomTextFieldWidget(
        //       hintText: '${'house'.tr} (${'optional'.tr})',
        //       labelText: 'house'.tr,
        //       inputType: TextInputType.text,
        //       focusNode: _houseNode,
        //       nextFocus: _floorNode,
        //       controller: _houseController,
        //     ),
        //   ),
        //   const SizedBox(width: Dimensions.paddingSizeLarge),
        //   Expanded(
        //     child: CustomTextFieldWidget(
        //       hintText: '${'floor'.tr} (${'optional'.tr})',
        //       labelText: 'floor'.tr,
        //       inputType: TextInputType.text,
        //       focusNode: _floorNode,
        //       inputAction: TextInputAction.done,
        //       controller: _floorController,
        //     ),
        //   ),
        // ]),
        // const SizedBox(height: Dimensions.paddingSizeOverLarge),

         CustomTextFieldWidget(
          hintText: 'Add Description',
          labelText: "Add Description (Optional)",
          inputType: TextInputType.streetAddress,
      controller: _descriptionController,

      /*    focusNode: _streetNode,
          nextFocus: _houseNode,*/
          // controller: _streetNumberController,
        ),

        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        !isDesktop ? GetBuilder<AddressController>(builder: (addressController) {
          return CustomButtonWidget(color: const Color(0xff090018),
            radius: Dimensions.paddingSizeSmall,
            width: Dimensions.webMaxWidth,
            margin: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeSmall),
            buttonText: widget.forGuest ? 'continue'.tr : widget.address!.id == null ? 'save_location'.tr : 'update_address'.tr,
            isLoading: addressController.isLoading,
            onPressed: locationController.loading ? null : () => _onSaveButtonPressed(locationController),
          );
        }) : const SizedBox(),
        isDesktop
            ? GetBuilder<AddressController>(builder: (addressController) {
                return CustomButtonWidget(
                  radius: Dimensions.paddingSizeSmall,
                  width: Dimensions.webMaxWidth,
                  margin: EdgeInsets.all(
                      isDesktop ? 0 : Dimensions.paddingSizeSmall),
                  buttonText: widget.forGuest
                      ? 'continue'.tr
                      : widget.address!.id == null
                          ? 'save_location'.tr
                          : 'update_address'.tr,
                  isLoading: addressController.isLoading,
                  onPressed:
                  // locationController.loading
                  //     ? null
                  //     :
                      () =>
                      _onSaveButtonPressed(locationController),
                );
              })
            : const SizedBox(),
        const SizedBox(height:  Dimensions.paddingSizeLarge),
      ]),
    );
  }

  void _onSaveButtonPressed(LocationController locationController) async {
    String numberWithCountryCode = _contactPersonNumberController.text.trim();
       // _countryDialCode!
         // "+91${_contactPersonNumberController.text.trim().replaceAll("91", "")}";
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    AddressModel? addressModel = _prepareAddressModel(
        locationController, phoneValid.isValid, numberWithCountryCode);
    if (addressModel == null) {
      return;
    }

    if (widget.forGuest) {
      addressModel.email = _emailController.text;
      Get.back(result: addressModel);
    } else {
      if (widget.address!.id == null) {
        _addAddress(addressModel);
      } else {
        _updateAddress(addressModel);
      }
    }
  }

  AddressModel? _prepareAddressModel(LocationController locationController,
      bool isValid, String numberWithCountryCode) {
    if (_contactPersonNameController.text.isEmpty) {
      showCustomSnackBar('please_provide_contact_person_name'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {

      print("-=-=---=-${locationController.pincode}");

      AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        addressType: locationController.addressTypeIndex==2?_levelController.text:locationController
            .addressTypeList[locationController.addressTypeIndex],
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: numberWithCountryCode,
        address: _addressController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        road: _streetNumberController.text.trim(),
        house: _houseController.text.trim(),
        floor: _floorController.text.trim(),
        description: _descriptionController.text.trim(),
        pincode: locationController.pincode,
      );


      return addressModel;
    }
    return null;
  }

  void _addAddress(AddressModel addressModel) {
    addressModel.streetName= Get.find<LocationController>().streetName;
    addressModel.countryName= Get.find<LocationController>().countryName;
    addressModel.stateName= Get.find<LocationController>().stateName;
    addressModel.cityName= Get.find<LocationController>().cityName;
    addressModel.pincode= Get.find<LocationController>().pincode;
    Get.find<AddressController>()
        .addAddress(addressModel, widget.fromCheckout, widget.zoneId)
        .then((response) {
          print("pppppppppp${response.isSuccess}");
          print("ppppppqqqq${response.message!.toLowerCase()}");
      if (response.isSuccess|| response.message!.toLowerCase() == "Successfully added".toLowerCase()) {

        Get.back(result: addressModel);
        //Get.offAllNamed(RouteHelper.getAddressRoute());
        showCustomSnackBar('new_address_added_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _updateAddress(AddressModel addressModel) {
    addressModel.streetName= Get.find<LocationController>().streetName??widget.address!.stateName;
    addressModel.countryName= Get.find<LocationController>().countryName??widget.address!.countryName;
    addressModel.stateName= Get.find<LocationController>().stateName ?? widget.address!.stateName;
    addressModel.cityName= Get.find<LocationController>().cityName ?? widget.address!.cityName;
    addressModel.pincode= Get.find<LocationController>().pincode ?? widget.address!.pincode;
    Get.find<AddressController>()
        .updateAddress(addressModel, widget.address!.id)
        .then((response) {
      if (response.isSuccess) {
        Get.back();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }
}
