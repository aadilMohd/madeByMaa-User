import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scratcher/widgets.dart';
import 'package:stackfood_multivendor/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';

class MealByMaa extends StatefulWidget {
  const MealByMaa({super.key});

  @override
  State<MealByMaa> createState() => _MealByMaaState();
}

class _MealByMaaState extends State<MealByMaa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 3,
        surfaceTintColor: Get.theme.cardColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          
         
          
        ),
        centerTitle: true,
        title: Text("meal_by_maa".tr,style: const TextStyle(fontWeight: FontWeight.w500),),
      ),
      body:




        
        
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Image.asset(
              Images.mealByMaaLogo,
              height: 202,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Coming Soon!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(onTap: (){
                  Get.to(()=>const DashboardScreen(pageIndex: 0));
                },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        "Back",
                        style: TextStyle(
                            color: Get.theme.cardColor,
                            fontSize: Dimensions.fontSizeExtraLarge),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );

  }
}
