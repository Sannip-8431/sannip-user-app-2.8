import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sannip/features/language/controllers/language_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/features/auth/controllers/auth_controller.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/helper/custom_validator.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/helper/validate_check.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/common/widgets/custom_button.dart';
import 'package:sannip/common/widgets/custom_snackbar.dart';
import 'package:sannip/common/widgets/custom_text_field.dart';
import 'package:sannip/common/widgets/footer_view.dart';

class GuestTrackOrderInputViewWidget extends StatefulWidget {
  const GuestTrackOrderInputViewWidget({super.key});

  @override
  State<GuestTrackOrderInputViewWidget> createState() =>
      _GuestTrackOrderInputViewWidgetState();
}

class _GuestTrackOrderInputViewWidgetState
    extends State<GuestTrackOrderInputViewWidget> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _orderFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.isDesktop(context)
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(
              horizontal: Dimensions.radiusExtraLarge,
              vertical: Dimensions.paddingSizeLarge),
      child: Center(
        child: SingleChildScrollView(
          child: FooterView(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(children: [
                SizedBox(height: ResponsiveHelper.isDesktop(context) ? 100 : 0),
                CustomTextField(
                  labelText: 'order_id'.tr,
                  titleText: 'write_order_id'.tr,
                  controller: _orderIdController,
                  focusNode: _orderFocus,
                  nextFocus: _phoneFocus,
                  inputType: TextInputType.number,
                  showTitle: ResponsiveHelper.isDesktop(context),
                  required: true,
                  validator: (value) =>
                      ValidateCheck.validateEmptyText(value, null),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                CustomTextField(
                  titleText: 'enter_phone_number'.tr,
                  labelText: 'phone'.tr,
                  controller: _phoneNumberController,
                  focusNode: _phoneFocus,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                  isPhone: true,
                  showTitle: ResponsiveHelper.isDesktop(context),
                  onCountryChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryDialCode ??
                      Get.find<LocalizationController>().locale.countryCode,
                  required: true,
                  validator: (value) =>
                      ValidateCheck.validateEmptyText(value, null),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                GetBuilder<OrderController>(builder: (orderController) {
                  return CustomButton(
                    buttonText: 'track_order'.tr,
                    isLoading: orderController.isLoading,
                    width: ResponsiveHelper.isDesktop(context)
                        ? 300
                        : double.infinity,
                    onPressed: () async {
                      String phone = _phoneNumberController.text.trim();
                      String orderId = _orderIdController.text.trim();
                      String numberWithCountryCode = _countryDialCode! + phone;
                      PhoneValid phoneValid =
                          await CustomValidator.isPhoneValid(
                              numberWithCountryCode);
                      numberWithCountryCode = phoneValid.phone;

                      if (orderId.isEmpty) {
                        showCustomSnackBar('please_enter_order_id'.tr);
                      } else if (phone.isEmpty) {
                        showCustomSnackBar('enter_phone_number'.tr);
                      } else if (!phoneValid.isValid) {
                        showCustomSnackBar('invalid_phone_number'.tr);
                      } else {
                        orderController
                            .trackOrder(orderId, null, false,
                                contactNumber: numberWithCountryCode,
                                fromGuestInput: true)
                            .then((response) {
                          if (response!.isSuccess) {
                            Get.toNamed(RouteHelper.getGuestTrackOrderScreen(
                                orderId, numberWithCountryCode));
                          }
                        });
                      }
                    },
                  );
                })
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
