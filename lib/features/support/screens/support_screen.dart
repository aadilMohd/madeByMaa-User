import 'package:stackfood_multivendor/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/support/widgets/custom_card_widget.dart';
import 'package:stackfood_multivendor/features/support/widgets/element_widget.dart';
import 'package:stackfood_multivendor/features/support/widgets/web_support_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../helper/route_helper.dart';
import '../../chat/domain/models/conversation_model.dart';
import '../../notification/domain/models/notification_body_model.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ChatController>(builder: (chatController) {
      ConversationsModel? conversation;
      if(chatController.searchConversationModel != null) {
        conversation = chatController.searchConversationModel;
        // _decideResult(chatController.searchConversationModel);
      }else {
        conversation = chatController.conversationModel;
      }
      return Scaffold(
       floatingActionButton:
        // !ResponsiveHelper.isDesktop(context)
        //     ?
        // (chatController.conversationModel != null && chatController.showFloatingButton)
        //     ?
        FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => Get.toNamed(
              RouteHelper.getChatRoute(
                notificationBody: NotificationBodyModel(
                  notificationType: NotificationType.message,
                  adminId: 0,
                ),
              ),
            ),
            child:
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: const BoxDecoration(shape: BoxShape.circle,color: Color(0xff007AFF)),child: Center(child: Image.asset(Images.floatButton),),)

          // ClipOval(
          //   child: CustomImageWidget(
          //     image: '${Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl}/${Get.find<SplashController>().configModel!.favIcon}',
          //   ),
          // ),
        ),

            // : null
            // : null,
        appBar: AppBar(
          centerTitle: true,
          title: Text('help_support'.tr,style: TextStyle(fontWeight: FontWeight.w500),),
        ),
        // appBar: CustomAppBarWidget(title: 'help_support'.tr, bgColor: Theme.of(context).primaryColor),
        // endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: Center(
            child: ResponsiveHelper.isDesktop(context) ? SingleChildScrollView(
              controller: scrollController,
              child: const FooterViewWidget(child: SizedBox(
                  width: double.infinity, height: 650, child: WebSupportScreen())),
            ) :
            ListView(padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              children: [
                Text("Contact Us",style: TextStyle(fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.w500),),
                SizedBox(height: Dimensions.paddingSizeExtraOverLarge,),

                ElementWidget(
                    image: Images.call, title: "Call Us",
                    subTitle: Get.find<SplashController>().configModel!.phone!,
                    onTap: ()async {
                      if(await canLaunchUrlString('tel:${Get.find<SplashController>().configModel!.phone}')) {
                        launchUrlString('tel:${Get.find<SplashController>().configModel!.phone}', mode: LaunchMode.externalApplication);
                      }else {
                        showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel!.phone}');
                      }
                    }
                ),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                ElementWidget(
                  image: Images.mail, title: 'email_us'.tr,
                  subTitle: Get.find<SplashController>().configModel!.email!,
                  onTap: () {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: Get.find<SplashController>().configModel!.email,
                    );
                    launchUrlString(emailLaunchUri.toString(), mode: LaunchMode.externalApplication);
                  },
                ),
              ],
            )
        ),
      );
    },);
  }
}
