import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:sannip/features/order/controllers/order_controller.dart';
import 'package:sannip/helper/auth_helper.dart';
import 'package:sannip/helper/responsive_helper.dart';
import 'package:sannip/util/dimensions.dart';
import 'package:sannip/util/styles.dart';
import 'package:sannip/common/widgets/custom_app_bar.dart';
import 'package:sannip/common/widgets/menu_drawer.dart';
import 'package:sannip/features/order/widgets/guest_track_order_input_view_widget.dart';
import 'package:sannip/features/order/widgets/order_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = AuthHelper.isLoggedIn();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<OrderController>().getRunningOrders(1);
      Get.find<OrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
          title: 'my_orders'.tr,
          backButton: ResponsiveHelper.isDesktop(context)),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<OrderController>(
        builder: (orderController) {
          return _isLoggedIn
              ? Column(children: [
                  Container(
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Column(children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeSmall),
                              child: Text('my_orders'.tr, style: robotoMedium),
                            ))
                          : const SizedBox(),
                      Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Align(
                            alignment: ResponsiveHelper.isDesktop(context)
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: Container(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 300
                                  : MediaQuery.of(context).size.width,
                              color: ResponsiveHelper.isDesktop(context)
                                  ? Colors.transparent
                                  : Theme.of(context).cardColor,
                              child: ButtonsTabBar(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? (300 / 2)
                                    : (MediaQuery.of(context).size.width / 2),
                                height: 55,
                                backgroundColor: Theme.of(context).primaryColor,
                                borderColor: Theme.of(context).primaryColor,
                                contentCenter: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                unselectedBorderColor:
                                    Theme.of(context).primaryColor,
                                borderWidth: 1,
                                unselectedBackgroundColor:
                                    Theme.of(context).cardColor,
                                buttonMargin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                unselectedLabelStyle: robotoBold.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeDefault),
                                controller: _tabController,
                                labelStyle: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.white),
                                tabs: [
                                  Tab(text: 'ongoing'.tr),
                                  Tab(text: 'past'.tr),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OrderViewWidget(isRunning: true),
                      OrderViewWidget(isRunning: false),
                    ],
                  )),
                ])
              : const GuestTrackOrderInputViewWidget();
        },
      ),
    );
  }
}
