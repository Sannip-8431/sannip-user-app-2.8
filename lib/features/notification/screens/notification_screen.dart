import 'package:sannip/features/notification/controllers/notification_controller.dart';
import 'package:sannip/features/splash/controllers/splash_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/date_converter.dart';
import 'package:sannip/helper/route_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/custom_image.dart';
import 'package:sannip/common/widgets/footer_view.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/common/widgets/no_data_screen.dart';
import 'package:sannip/common/widgets/not_logged_in_screen.dart';
import 'package:sannip/features/notification/widgets/notification_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if (Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if (AuthHelper.isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'notification'.tr,
            onBackPressed: () {
              if (widget.fromNotification) {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              } else {
                Get.back();
              }
            }),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: AuthHelper.isLoggedIn()
            ? GetBuilder<NotificationController>(
                builder: (notificationController) {
                if (notificationController.notificationList != null) {
                  notificationController.saveSeenNotificationCount(
                      notificationController.notificationList!.length);
                }
                List<DateTime> dateTimeList = [];
                return notificationController.notificationList != null
                    ? notificationController.notificationList!.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await notificationController
                                  .getNotificationList(true);
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: FooterView(
                                child: SizedBox(
                                    width: Dimensions.webMaxWidth,
                                    child: ListView.builder(
                                      itemCount: notificationController
                                          .notificationList!.length,
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DateTime originalDateTime =
                                            DateConverter.dateTimeStringToDate(
                                                notificationController
                                                    .notificationList![index]
                                                    .createdAt!);
                                        DateTime convertedDate = DateTime(
                                            originalDateTime.year,
                                            originalDateTime.month,
                                            originalDateTime.day);
                                        bool addTitle = false;
                                        if (!dateTimeList
                                            .contains(convertedDate)) {
                                          addTitle = true;
                                          dateTimeList.add(convertedDate);
                                        }
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              addTitle
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          bottom: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      child: Text(DateConverter
                                                          .dateTimeStringToDateOnly(
                                                              notificationController
                                                                  .notificationList![
                                                                      index]
                                                                  .createdAt!)),
                                                    )
                                                  : const SizedBox(),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return NotificationDialogWidget(
                                                            notificationModel:
                                                                notificationController
                                                                        .notificationList![
                                                                    index]);
                                                      });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Row(children: [
                                                    ClipOval(
                                                        child: CustomImage(
                                                      isNotification: true,
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${notificationController.notificationList![index].imageFullUrl}',
                                                    )),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                    Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                          Text(
                                                            notificationController
                                                                    .notificationList![
                                                                        index]
                                                                    .data!
                                                                    .title ??
                                                                '',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall),
                                                          ),
                                                          Text(
                                                            notificationController
                                                                    .notificationList![
                                                                        index]
                                                                    .data!
                                                                    .description ??
                                                                '',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: robotoRegular
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall),
                                                          ),
                                                        ])),
                                                  ]),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Divider(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    thickness: 1),
                                              ),
                                            ]);
                                      },
                                    )),
                              ),
                            ),
                          )
                        : NoDataScreen(
                            text: 'no_notification_found'.tr, showFooter: true)
                    : const Center(child: CircularProgressIndicator());
              })
            : NotLoggedInScreen(callBack: (value) {
                _loadData();
                setState(() {});
              }),
      ),
    );
  }
}
