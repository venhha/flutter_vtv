import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/cart/domain/repository/cart_repository.dart';
import 'package:flutter_vtv/features/cart/domain/response/cart_resp.dart';

import '../data_sources/cart_data_source.dart';

class CartRepositoryImpl extends CartRepository {
  CartRepositoryImpl(this._cartDataSource);

  final CartDataSource _cartDataSource;

  @override
  FRespData<CartResp> getCarts() async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _cartDataSource.getCarts(),
    );
  }

  @override
  FResp addToCart(int productVariantId, int quantity) {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () =>
          _cartDataSource.addToCart(productVariantId, quantity),
    );
  }

  @override
  FResp deleteCart(String cartId) async {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => _cartDataSource.deleteToCart(cartId),
    );
  }

  @override
  FResp deleteCartByShopId(String cartId) async {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => _cartDataSource.deleteToCartByShopId(cartId),
    );
  }

  @override
  FResp updateCart(String cartId, int quantity) async {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => _cartDataSource.updateCart(cartId, quantity),
    );
  }
}
