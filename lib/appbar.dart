import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor/bottomsheet_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'common/widgets/custom_snackbar_widget.dart';
import 'features/address/domain/models/address_model.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/location/controllers/location_controller.dart';
import 'features/location/screens/pick_map_screen.dart';
import 'features/location/widgets/location_search_dialog.dart';
import 'features/location/widgets/permission_dialog.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'features/splash/controllers/theme_controller.dart';
import 'helper/custom_validator.dart';
import 'helper/route_helper.dart';

class AppBarDummy extends StatefulWidget {
  final bool fromCheckout;
  final int? zoneId;
  final AddressModel? address;
  final bool forGuest;
  const AppBarDummy(
      {super.key,
      required this.fromCheckout,
      this.zoneId,
      this.address,
      required this.forGuest});

  @override
  State<AppBarDummy> createState() => _AppBarDummyState();
}

class _AppBarDummyState extends State<AppBarDummy> {
  // final ScrollController scrollController = ScrollController();
  // final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _contactPersonNameController = TextEditingController();
  // final TextEditingController _contactPersonNumberController = TextEditingController();
  // final TextEditingController _streetNumberController = TextEditingController();
  // final TextEditingController _houseController = TextEditingController();
  // final TextEditingController _floorController = TextEditingController();
  // final TextEditingController _levelController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final FocusNode _addressNode = FocusNode();
  // final FocusNode _nameNode = FocusNode();
  // final FocusNode _numberNode = FocusNode();
  // final FocusNode _streetNode = FocusNode();
  // final FocusNode _houseNode = FocusNode();
  // final FocusNode _floorNode = FocusNode();
  // final FocusNode _levelNode = FocusNode();
  // final FocusNode _emailFocus = FocusNode();
  // CameraPosition? _cameraPosition;
  // late LatLng _initialPosition;
  // bool _otherSelect = false;
  // String? _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
  //     ? Get.find<AuthController>().getUserCountryCode()
  //     : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _initCall();
  // }
  //
  // void _initCall() {
  //   Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
  //   if (Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
  //     Get.find<ProfileController>().getUserInfo();
  //   }
  //   if (widget.address == null) {
  //     _initialPosition = LatLng(
  //       double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
  //       double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
  //     );
  //   } else {
  //     Get.find<LocationController>().updateAddress(widget.address!);
  //     _initialPosition = LatLng(
  //       double.parse(widget.address?.latitude ?? '0'),
  //       double.parse(widget.address?.longitude ?? '0'),
  //     );
  //
  //     if (widget.address?.addressType == 'home') {
  //       Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
  //     } else if (widget.address?.addressType == 'office') {
  //       Get.find<LocationController>().setAddressTypeIndex(1, notify: false);
  //     } else {
  //       Get.find<LocationController>().setAddressTypeIndex(2, notify: false);
  //       _levelController.text = widget.address?.addressType ?? '';
  //       _otherSelect = true;
  //     }
  //
  //     _splitPhoneNumber(widget.address!.contactPersonNumber!);
  //     _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
  //     _emailController.text = widget.address!.email ?? '';
  //     _streetNumberController.text = widget.address!.road ?? '';
  //     _houseController.text = widget.address!.house ?? '';
  //     _floorController.text = widget.address!.floor ?? '';
  //   }
  // }
  //
  // void _splitPhoneNumber(String number) async {
  //   PhoneValid phoneNumber = await CustomValidator.isPhoneValid(number);
  //   _countryDialCode = '+${phoneNumber.countryCode}';
  //   _contactPersonNumberController.text = phoneNumber.phone.replaceFirst('+${phoneNumber.countryCode}', '');
  // }

  // void _initCall() {
  //   Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
  //   if (Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
  //     Get.find<ProfileController>().getUserInfo();
  //   }
  //   if (widget.address == null) {
  //     _initialPosition = LatLng(
  //       double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
  //       double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
  //     );
  //   } else {
  //     Get.find<LocationController>().updateAddress(widget.address!);
  //     _initialPosition = LatLng(
  //       double.parse(widget.address?.latitude ?? '0'),
  //       double.parse(widget.address?.longitude ?? '0'),
  //     );
  //
  //     if (widget.address?.addressType == 'home') {
  //       Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
  //     } else if (widget.address?.addressType == 'office') {
  //       Get.find<LocationController>().setAddressTypeIndex(1, notify: false);
  //     } else {
  //       Get.find<LocationController>().setAddressTypeIndex(2, notify: false);
  //       _levelController.text = widget.address?.addressType ?? '';
  //       _otherSelect = true;
  //     }
  //
  //     _splitPhoneNumber(widget.address!.contactPersonNumber!);
  //     _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
  //     _emailController.text = widget.address!.email ?? '';
  //     _streetNumberController.text = widget.address!.road ?? '';
  //     _houseController.text = widget.address!.house ?? '';
  //     _floorController.text = widget.address!.floor ?? '';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (locationController) {
        return Scaffold(
          bottomNavigationBar: ElevatedButton(
            child: Image.asset(
              Images.down,
              height: 10,
              width: 50,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.3,
                    minChildSize: 0.2,
                    maxChildSize: 0.8,
                    builder: (context, scrollController) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 50, // Just a demo list for content
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Item $index'),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          body: ListView(
            children: [],
          ),
        );
      },
    );
  }
  // Widget addressSectionWidget(LocationController locationController, bool isDesktop) {
  //   return Container(
  //     decoration: isDesktop ? BoxDecoration(
  //       color: Get.theme.cardColor,
  //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
  //       boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
  //     ) : const BoxDecoration(),
  //     padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : 0),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Container(
  //         height: isDesktop ? 260 : 145,
  //         width: Get.width,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
  //           border: Border.all(width: 1.5, color: Get.theme.primaryColor.withOpacity(0.5)),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
  //           child: Stack(clipBehavior: Clip.none, children: [
  //
  //             GoogleMap(
  //               initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
  //               minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
  //               onTap: isDesktop ? null : (latLng) {
  //                 Get.toNamed(
  //                   RouteHelper.getPickMapRoute('add-address', false),
  //                   arguments: PickMapScreen(
  //                     fromAddAddress: true,
  //                     fromSignUp: false,
  //                     googleMapController: locationController.mapController,
  //                     route: null,
  //                     canRoute: false,
  //                   ),
  //                 );
  //               },
  //               zoomControlsEnabled: false,
  //               compassEnabled: false,
  //               indoorViewEnabled: true,
  //               mapToolbarEnabled: false,
  //               onCameraIdle: () {
  //                 locationController.updatePosition(_cameraPosition, true);
  //               },
  //               onCameraMove: ((position) => _cameraPosition = position),
  //               onMapCreated: (GoogleMapController controller) {
  //                 locationController.setMapController(controller);
  //                 if (widget.address == null) {
  //                   locationController.getCurrentLocation(true, mapController: controller);
  //                 }
  //               },
  //               gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
  //                 Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  //                 Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
  //                 Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
  //                 Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
  //                 Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
  //               },
  //               style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
  //             ),
  //
  //             locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
  //
  //             Center(
  //               child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50) : const CircularProgressIndicator(),
  //             ),
  //
  //             Positioned(
  //               bottom: 10, right: 0,
  //               child: InkWell(
  //                 onTap: () => _checkPermission(() {
  //                   locationController.getCurrentLocation(true, mapController: locationController.mapController);
  //                 }),
  //                 child: Container(
  //                   width: 30, height: 30,
  //                   margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Get.theme.cardColor),
  //                   child: Icon(Icons.my_location, color: Get.theme.primaryColor, size: 20),
  //                 ),
  //               ),
  //             ),
  //
  //             Positioned(
  //               top: 10, right: 0,
  //               child: InkWell(
  //                 onTap: () {
  //                   Get.toNamed(
  //                     RouteHelper.getPickMapRoute('add-address', false),
  //                     arguments: PickMapScreen(
  //                       fromAddAddress: true, fromSignUp: false,
  //                       googleMapController: locationController.mapController,
  //                       route: null, canRoute: false,
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   width: 30, height: 30,
  //                   margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Get.theme.cardColor),
  //                   child: Icon(Icons.fullscreen, color: Get.theme.primaryColor, size: 20),
  //                 ),
  //               ),
  //             ),
  //
  //             Positioned(
  //               top: 10,
  //               left: 10,
  //               child: LocationSearchDialog(
  //                 mapController: locationController.mapController,
  //                 fromAddress: true,
  //                 pickedLocation: _addressController.text,
  //                 callBack: (Position? position) {
  //                   if (position != null) {
  //                     _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
  //                     locationController.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
  //                     locationController.updatePosition(_cameraPosition, true);
  //                   }
  //                 },
  //                 child: Container(
  //                   height: 30,
  //                   width: 200,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
  //                     color: Get.theme.cardColor,
  //                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
  //                   ),
  //                   padding: const EdgeInsets.only(left: 10),
  //                   alignment: Alignment.centerLeft,
  //                   child: Text('search'.tr, style: robotoRegular.copyWith(color: Get.theme.hintColor)),
  //                 ),
  //               ),
  //
  //             ),
  //           ]),
  //         ),
  //       ),
  //
  //     ]),Fadd fund
  //   );
  // }
  // void _checkPermission(Function onTap) async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   if (permission == LocationPermission.denied) {
  //     showCustomSnackBar('you_have_to_allow'.tr);
  //   } else if (permission == LocationPermission.deniedForever) {
  //     Get.dialog(const PermissionDialog());
  //   } else {
  //     onTap();
  //   }
  // }
}
