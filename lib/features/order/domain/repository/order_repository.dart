import 'package:vtv_common/vtv_common.dart';

abstract class OrderRepository {
  //! Create Temp Order
  //* With Cart
  FRespData<OrderDetailEntity> createOrderByCartIds(List<String> cartIds);
  FRespData<OrderDetailEntity> createUpdateWithCart(
      PlaceOrderWithCartParam params); // Use to change order status (in checkout page)
  //* With Product Variant
  FRespData<OrderDetailEntity> createByProductVariant(int productVariantId, int quantity);
  FRespData<OrderDetailEntity> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  //! Place Order
  FRespData<OrderDetailEntity> placeOrderWithCart(PlaceOrderWithCartParam params);
  FRespData<OrderDetailEntity> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();

  //! Purchase - Manage orders
  /// Get all orders
  FRespData<MultiOrderEntity> getListOrders();

  /// Get orders by status
  /// - [status] is enum OrderStatus string name (e.g. 'PENDING')
  FRespData<MultiOrderEntity> getListOrdersByStatus(String status);

  /// Get order detail by orderId
  FRespData<OrderDetailEntity> getOrderDetail(String orderId);
  /// Cancel order
  FRespData<OrderDetailEntity> getOrderCancel(String orderId);
}
