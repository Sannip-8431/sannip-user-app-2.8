import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/features/checkout/controllers/checkout_controller.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class NoteAndPrescriptionSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final int? storeId;
  NoteAndPrescriptionSection({
    super.key,
    required this.checkoutController,
    this.storeId,
  });

  FocusNode textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('additional_note'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            CustomTextField(
              controller: checkoutController.noteController,
              titleText: 'please_provide_extra_napkin'.tr,
              showLabelText: false,
              maxLines: 3,
              inputType: TextInputType.multiline,
              inputAction: TextInputAction.done,
              capitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            /*storeId == null && Get.find<SplashController>().configModel!.moduleConfig!.module!.orderAttachment! ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('prescription'.tr, style: robotoMedium),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '(${'max_size_2_mb'.tr})',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ImagePickerWidget(
            image: '', rawFile: checkoutController.rawAttachment,
            onTap: () => checkoutController.pickImage(),
          ),
        ],
      ) : const SizedBox(),*/
          ])
        : mobileNoteWidget(context);
  }

  Widget mobileNoteWidget(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      onTap: () {
        textFocusNode.requestFocus();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => Padding(
              padding: MediaQuery.of(con).viewInsets,
              child: bottomSheetWidget(con)),
        );
      },
      leading: Icon(
        Icons.menu,
        color: Theme.of(context).disabledColor,
        size: 25,
      ),
      title: Text(
        checkoutController.noteController.text.isNotEmpty
            ? checkoutController.noteController.text
            : 'do_you_have_any_instructions?'.tr,
        style: robotoRegular.copyWith(
            color: Theme.of(context).disabledColor,
            fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).disabledColor,
        size: 30,
      ),
    );
  }

  Widget bottomSheetWidget(BuildContext context) {
    return Container(
      width: 550,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context)
            ? const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(
                Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('additional_note'.tr,
                style:
                    robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            InkWell(
              onTap: () {
                checkoutController.noteController.clear();
                checkoutController.noteController.text == '';
                Future.delayed(const Duration(milliseconds: 200), () {
                  Get.back();
                });
              },
              child: Icon(Icons.clear, color: Theme.of(context).disabledColor),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          CustomTextField(
            controller: checkoutController.noteController,
            titleText: 'please_provide_extra_napkin'.tr,
            showLabelText: false,
            focusNode: textFocusNode,
            maxLines: 3,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.done,
            capitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text('add_note_bottomSheet_description'.tr,
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomButton(
              buttonText: 'add'.tr,
              onPressed: () {
                Get.back();
              }),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ]),
      ),
    );
  }
}
