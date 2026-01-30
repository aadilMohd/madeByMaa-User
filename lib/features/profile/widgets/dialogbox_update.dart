import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

class DialogBoxUpdate extends StatefulWidget {
  const DialogBoxUpdate({super.key});

  @override
  State<DialogBoxUpdate> createState() => _DialogBoxUpdateState();
}

class _DialogBoxUpdateState extends State<DialogBoxUpdate> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

backgroundColor: Colors.white,      title: SizedBox(width: Get.width,
  child: Column(
          children: [
            Image.asset(Images.checkLogo,height: 143,width: 141,),
            const SizedBox(height: 20,),
            Text("Information Updated!",style: TextStyle(fontSize: Dimensions.fontSizeExtraLarge),),
            const SizedBox(height: 20,),

            InkWell(onTap: (){
              Get.back();
            },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
              color: const Color(0xff090018),
                borderRadius: BorderRadius.circular(30),

              ),child: Center(child: Text("Save",style: TextStyle(color: Get.theme.cardColor,fontSize: Dimensions.fontSizeExtraLarge),),),),
            )
          ],
        ),
),

    );
  }
}
