import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/presentation/components/custom_widgets.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../service_locator.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../../domain/repository/order_repository.dart';
import '../components/purchase_order_item.dart';

String _buttonText(int index) {
  switch (index) {
    case 0:
      return 'Tất cả';
    case 1:
      return 'Chờ xác nhận';
    case 2:
      return 'Đang giao';
    case 3:
      return 'Đã giao';
    default:
      return 'Tất cả';
  }
}

String _getEmptyMessage(int index) {
  switch (index) {
    case 0:
      return 'Không có đơn hàng nào';
    case 1:
      return 'Không có đơn hàng chờ xác nhận nào';
    case 2:
      return 'Không có đơn hàng đang giao nào';
    case 3:
      return 'Không có đơn hàng đã giao nào';
    default:
      return 'Không có đơn hàng nào';
  }
}

Widget _buildTabBarView({required int index}) {
  return FutureBuilder(
    future: _callFuture(index),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final respEither = snapshot.data!;

        return respEither.fold(
          (error) => MessageScreen.error(error.message),
          (ok) {
            if (ok.data.orders.isEmpty) {
              return MessageScreen.error(
                _getEmptyMessage(index),
                const Icon(Icons.remove_shopping_cart_rounded),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: ok.data.orders.length,
              itemBuilder: (context, index) {
                return PurchaseOrderItem(
                  order: ok.data.orders[index],
                );
              },
            );
          },
        );
      } else if (snapshot.hasError) {
        return MessageScreen.error(snapshot.error.toString());
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

FRespData<OrdersResp>? _callFuture(int index) {
  switch (index) {
    case 0: // All purchase orders
      return sl<OrderRepository>().getListOrders();
    case 1: // Pending purchase orders
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.PENDING.name);
    case 2: // Shipping purchase orders
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.SHIPPING.name);
    case 3: // Completed purchase orders
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.COMPLETED.name);
    default:
      return null;
  }
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  static const String routeName = 'purchase';
  static const String path = '/user/purchase';

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  List<int> _totalOrdersAt = List.generate(4, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn mua hàng'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              _buildTapButton(_buttonText(0), _totalOrdersAt[0]),
              _buildTapButton(_buttonText(1), _totalOrdersAt[1]),
              _buildTapButton(_buttonText(2), _totalOrdersAt[2]),
              _buildTapButton(_buttonText(3), _totalOrdersAt[3]),
            ],
          ),
        ),
        body: TabBarView(
          children: List.generate(
            4,
            // _buildTabBarView,
            (index) => RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: _buildTabBarView(index: index),
            ),
          ),
        ),
      ),
    );
  }

  Badge _buildTapButton(String text, int total, {Color? backgroundColor}) {
    return Badge(
      label: Text(total.toString()),
      backgroundColor: backgroundColor,
      isLabelVisible: total > 0,
      child: Tab(text: text),
    );
  }
}
