import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines/timelines.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/address_summary.dart';
import '../../../cart/presentation/components/order_item.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../../home/presentation/pages/product_detail_page.dart';
import '../../domain/repository/order_repository.dart';
import '../components/order_status_badge.dart';
import '../components/shop_info.dart';
import 'checkout_page.dart';
import 'review_add_page.dart';
import 'review_details_by_order_page.dart';

// const String _noVoucherMsg = 'Không áp dụng';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderDetail});

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  final OrderDetailEntity orderDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      bottomSheet: _buildBottomActionByOrderStatus(context, orderDetail.order.status),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // //# notification: not review yet,...
              // if (orderDetail.order.status == OrderStatus.COMPLETED)
              //   const Text.rich(
              //     textAlign: TextAlign.center,
              //     TextSpan(
              //       text: 'Chưa đánh giá sản phẩm',
              //       style: TextStyle(
              //         color: Colors.red,
              //         fontWeight: FontWeight.normal,
              //       ),
              //     ),
              //   ),

              //! order status
              _buildOrderStatus(),
              const SizedBox(height: 8),

              // //! address
              // _buildDeliveryAddress(),
              // const SizedBox(height: 8),

              //# summary info: transport + shipping method + order timeline
              _buildSummaryInfo(),
              const SizedBox(height: 8),

              //! order summary
              _buildShopInfoAndItems(), // shop info, list of items
              const SizedBox(height: 8),

              // //! shipping method
              // _buildShippingMethod(),
              // const SizedBox(height: 8),

              //! payment method
              _buildPaymentMethod(),
              const SizedBox(height: 8),

              //! total price
              _buildTotalPrice(),
              const SizedBox(height: 8),

              //! note
              _buildNote(),

              //? cancel button -> move to bottom sheet
              // if (orderDetail.order.status == OrderStatus.PENDING || orderDetail.order.status == OrderStatus.PROCESSING)
              //   _buildCancelButton(context),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildBottomActionByOrderStatus(BuildContext context, OrderStatus status) {
    Widget buildStatus(BuildContext context, OrderStatus status) {
      switch (status) {
        case OrderStatus.PENDING || OrderStatus.PROCESSING:
          return _buildCancelButton(context);
        case OrderStatus.COMPLETED:
          return _buildReviewBtn();
        case OrderStatus.CANCEL:
          return _buildRePurchaseBtn(context);

        default:
          throw UnimplementedError('Not implement for status: $status');
      }
    }

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          //# chat
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.blue.shade300,
              ),
              child: const Text('Chat với cửa hàng'),
            ),
          ),

          //# cancel - add review - view review
          Expanded(
            child: buildStatus(context, status),
          ),
        ],
      ),
    );
  }

  Widget _buildRePurchaseBtn(BuildContext context) {
    return _buildBottomActionBtn(
      context,
      label: 'Mua lại',
      onPressed: () async {
        final Map<int, int> rePurchaseItems = {}; // cre a list to store productVariantId and quantity for re-purchase

        for (var item in orderDetail.order.orderItems) {
          rePurchaseItems.addAll({item.productVariant.productVariantId: item.quantity});
        }

        final respEither = await sl<OrderRepository>().createByProductVariant(rePurchaseItems);

        respEither.fold(
          (error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(error.message!),
                ),
              );
          },
          (ok) {
            // context.pop(); // pop out the bottom sheet
            context.push(
              Uri(path: CheckoutPage.path, queryParameters: {'isCreateWithCart': 'false'}).toString(),
              extra: ok.data.order,
            );
          },
        );
      },
      backgroundColor: Colors.green.shade300,
    );
  }

  Widget _buildReviewBtn() {
    return FutureBuilder(
      future: sl<ProductRepository>().isOrderReviewed(orderDetail.order),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (error) => MessageScreen.error(error.message),
            (ok) => ok
                ? ElevatedButton(
                    onPressed: () {
                      context.push(ReviewDetailsByOrderPage.path, extra: orderDetail.order);
                    },
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Xem đánh giá'),
                  )
                : IconTextButton(
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const RoundedRectangleBorder(),
                    ),
                    // child: Text('Đánh giá sản phẩm'),
                    label: 'Đánh giá sản phẩm',
                    leadingIcon: Icons.warning_amber_rounded,
                    iconSize: 20,
                    iconColor: Colors.red,
                    onPressed: () {
                      context.push(ReviewAddPage.path, extra: orderDetail.order);
                    },
                  ),
          );
        }
        return const Text(
          'Đang tải...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        );
      },
    );
  }

  Widget _buildSummaryInfo() {
    return Wrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Thông tin vận chuyển',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          text: 'Mã vận đơn: ',
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: orderDetail.transport!.transportId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // child: Text.rich(
                      //   'Mã vận đơn:',
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(fontSize: 12)
                      // ),
                    ),
                    //btn copy
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: orderDetail.transport!.transportId));
                        Fluttertoast.showToast(msg: 'Đã sao chép mã vận đơn');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          _buildShippingMethod(),
          const SizedBox(height: 2),
          _buildDeliveryAddress(),
          Timeline.tileBuilder(
            padding: const EdgeInsets.all(8),
            theme: TimelineThemeData(nodePosition: 0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            builder: TimelineTileBuilder.fromStyle(
              contentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        StringHelper.convertDateTimeToString(
                          orderDetail.transport!.transportHandleDtOs[index].createAt,
                          pattern: 'dd-MM-yyyy\nHH:mm',
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '(${orderDetail.transport!.transportHandleDtOs[index].transportStatus}) ${orderDetail.transport!.transportHandleDtOs[index].messageStatus}',
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: orderDetail.transport!.transportHandleDtOs.length,
            ),
          ),
        ],
      ),
    );
  }

  Wrapper _buildOrderStatus() {
    return Wrapper(
      child: Column(
        children: [
          //# order status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trạng thái đơn hàng',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              OrderStatusBadge(status: orderDetail.order.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          text: 'Ghi chú: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: orderDetail.order.note ?? '(không có)',
              style: TextStyle(
                color: orderDetail.order.note == null ? Colors.grey : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tổng cộng',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          _totalSummaryPriceItem('Tổng tiền hàng:', orderDetail.order.totalPrice),
          _totalSummaryPriceItem('Phí vận chuyển:', orderDetail.order.shippingFee),

          _totalSummaryPriceItem('Giảm giá hệ thống:', orderDetail.order.discountSystem),
          _totalSummaryPriceItem('Giảm giá cửa hàng:', orderDetail.order.discountShop),

          // total price
          const Divider(thickness: 0.2, height: 4),
          _totalSummaryPriceItem(
            'Tổng thanh toán:',
            orderDetail.order.paymentTotal,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _totalSummaryPriceItem(String title, int price, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          StringHelper.formatCurrency(price),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Wrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Phương thức thanh toán',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(widget.order.paymentMethod),
          Text(StringHelper.getPaymentName(orderDetail.order.paymentMethod)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return AddressSummary(
      address: orderDetail.order.address,
      color: Colors.white,
      suffixIcon: null,

      // margin: const EdgeInsets.all(2),
      // decoration: BoxDecoration(
      //   // border: Border.all(color: Colors.grey),
      //   borderRadius: BorderRadius.circular(8),
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 2,
      //       offset: const Offset(0, 1), // changes position of shadow
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildShippingMethod() {
    return Wrapper(
      useBoxShadow: false,
      border: Border.all(color: Colors.grey.shade500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Phương thức vận chuyển',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // method name
          Text(orderDetail.order.shippingMethod),
        ],
      ),
    );
  }

  Widget _buildShopInfoAndItems() {
    return Wrapper(
      child: Column(
        children: [
          //! shop info --circle shop avatar
          ShopInfo(shop: orderDetail.order.shop),

          //! list of items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderDetail.order.orderItems.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            itemBuilder: (context, index) {
              final item = orderDetail.order.orderItems[index];
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailPage(productId: item.productVariant.productId);
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: OrderItem(item),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return ElevatedButton(
      //color red
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade200,
        shape: const RoundedRectangleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () async {
        final isConfirm = await showDialogToConfirm(
          context: context,
          title: 'Hủy đơn hàng',
          content: 'Bạn có chắc chắn muốn hủy đơn hàng này?',
          confirmText: 'Hủy đơn hàng',
          confirmBackgroundColor: Colors.red.shade300,
        );

        if (isConfirm) {
          final resp = await sl<OrderRepository>().getOrderCancel(orderDetail.order.orderId!);

          resp.fold(
            (error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
            },
            (ok) {
              showDialogToAlert(
                context,
                title: const Text('Hủy đơn hàng thành công!'),
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [],
              );
              context.go(path, extra: ok.data);
            },
          );
        }
      },
      child: const Text('Hủy đơn hàng'),
    );
  }
}

Widget _buildBottomActionBtn(
  BuildContext context, {
  required String label,
  required void Function() onPressed,
  required Color backgroundColor,
}) {
  return ElevatedButton(
    //color red
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    onPressed: onPressed,
    child: Text(label),
  );
}

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.border,
    this.useBoxShadow = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final bool useBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        boxShadow: useBoxShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
