import 'package:lottie/lottie.dart';
import 'package:sannip/features/auth/screens/sign_in_screen.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/footer_view.dart';

class NotLoggedInScreen extends StatelessWidget {
  final Function(bool success) callBack;
  const NotLoggedInScreen({super.key, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: FooterView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        Images.notLoggedIn,
                        width: MediaQuery.of(context).size.height * 0.35,
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        'oops_you_have_not_signed_in'.tr,
                        style: robotoBold.copyWith(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        'kindly_sign_in'.tr,
                        style: robotoRegular.copyWith(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            color: Theme.of(context).disabledColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                    ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
          child: CustomButton(
              width: MediaQuery.of(context).size.width * 0.7,
              radius: 100,
              buttonText: 'sign_in'.tr,
              onPressed: () async {
                if (!ResponsiveHelper.isDesktop(context)) {
                  await Get.toNamed(
                      RouteHelper.getSignInRoute(Get.currentRoute));
                } else {
                  Get.dialog(const SignInScreen(
                          exitFromApp: true, backFromThis: true))
                      .then((value) => callBack(true));
                }
                if (Get.find<OrderController>().showBottomSheet) {
                  Get.find<OrderController>().showRunningOrders();
                }
                callBack(true);
              }),
        ),
      ],
    );
  }
}
