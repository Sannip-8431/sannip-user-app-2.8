import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/auth/widgets/web_registration_stepper_widget.dart';
import 'package:sannip/features/business/controllers/business_controller.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/images.dart';
import 'package:sannip/util/styles.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            businessController.businessIndex == 1
                ? RegistrationStepperWidget(
                    status: businessController.businessPlanStatus)
                : const SizedBox(height: Dimensions.paddingSizeLarge),
            SizedBox(height: context.height * 0.2),
            Image.asset(Images.checked, height: 90, width: 90),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text('congratulations'.tr,
                style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              'your_registration_has_been_completed_successfully'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ]),
        ),
      );
    });
  }
}
