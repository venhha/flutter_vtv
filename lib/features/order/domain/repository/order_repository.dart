import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';

import '../../../../core/constants/typedef.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../entities/voucher_entity.dart';

abstract class OrderRepository {
  //! Create Temp Order
  FRespData<OrderResp> createOrderByCartIds(List<String> cartIds);
  /// Use to change order status (in checkout page)
  FRespData<OrderResp> createUpdateWithCart(PlaceOrderParam param);
  FRespData<OrderResp> createByProductVariant(int productVariantId, int quantity);

  // Place order
  FRespData<OrderResp> placeOrder(PlaceOrderParam params);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();

  //! Purchase - Manage orders
  /// Get all orders
  FRespData<OrdersResp> getListOrders();
  /// Get orders by status
  /// - [status] is enum OrderStatus string name (e.g. 'PENDING')
  FRespData<OrdersResp> getListOrdersByStatus(String status);
}
