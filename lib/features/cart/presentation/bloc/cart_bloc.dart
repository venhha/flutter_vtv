import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/cart.dart';
import 'package:vtv_common/core.dart';

import '../../domain/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository, this._secureStorage) : super(CartInitial()) {
    on<InitialCart>(_onInitialCart);
    on<EmptyCart>(_onEmptyCart);
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCart>(_onUpdateCart);
    on<DeleteCart>(_onDeleteCart);
    on<DeleteCartByShopId>(_onDeleteCartByShopId);
    on<SelectCart>(_onSelectCart);
    on<UnSelectCart>(_onUnSelectCart);
  }

  final CartRepository _cartRepository;
  final SecureStorageHelper _secureStorage;

  void _onInitialCart(InitialCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    // check if user is logged in
    final isLoggedIn = await _secureStorage.isLogin;
    if (!isLoggedIn) {
      emit(const CartError(message: 'Bạn cần đăng nhập để xem giỏ hàng'));
      return;
    }
    final resp = await _cartRepository.getCarts();

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) => emit(CartLoaded(ok.data!)),
    );
  }

  void _onEmptyCart(EmptyCart event, Emitter<CartState> emit) async => emit(CartInitial());

  void _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.getCarts();

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) => emit(CartLoaded(ok.data!, message: event.message ?? ok.message, selectedCartIds: event.selectedCartIds)),
    );
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.addToCart(event.productVariantId, event.quantity);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        add(FetchCart(message: ok.message));
      },
    );
  }

  void _onUpdateCart(UpdateCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final prevState = state as CartLoaded;

    final resp = await _cartRepository.updateCart(event.cartId, event.quantity);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        final newCartState = prevState.cart.copyWith(
          cartByShopDTOs: prevState.cart.cartByShopDTOs.map(
            (cartsByShop) {
              if (cartsByShop.shopId == prevState.cart.cartByShopDTOs[event.shopIndex].shopId) {
                return cartsByShop.copyWith(
                  carts: cartsByShop.carts.map(
                    (c) {
                      if (c.cartId == event.cartId) {
                        // only one item in cart, remove it -> fetch cart
                        //? check if there is only one item in cart and user decrease quantity
                        if (c.quantity == 1 && event.quantity == -1) {
                          add(const FetchCart()); // fetch cart
                        } else {
                          return c.copyWith(quantity: c.quantity + event.quantity);
                        }
                      }
                      return c;
                    },
                  ).toList(),
                );
              }
              return cartsByShop;
            },
          ).toList(),
        );
        emit(prevState.copyWith(cart: newCartState));
      },
    );
  }

  void _onDeleteCart(DeleteCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final prevState = state as CartLoaded;

    final resp = await _cartRepository.deleteCart(event.cartId);

    //UnSelectCart cartId in selectedCartIds if it exists
    if (prevState.selectedCartIds.contains(event.cartId)) {
      // add(UnSelectCart(event.cartId)); >> _BUG emit unexpected new state
      prevState.selectedCartIds.remove(event.cartId);
    }

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        emit(CartSuccess(message: ok.message));
        add(FetchCart(selectedCartIds: prevState.selectedCartIds));
      },
    );
  }

  void _onDeleteCartByShopId(DeleteCartByShopId event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.deleteCartByShopId(event.shopId);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        emit(CartSuccess(message: ok.message));
        add(const FetchCart());
      },
    );
  }

  void _onSelectCart(SelectCart event, Emitter<CartState> emit) async {
    final prev = (state as CartLoaded);
    // emit(prev.copyWith(selectedCartIds: prev.selectedCartIds..add(event.cartId)));
    emit(prev.copyWith(
      selectedCartIds: [...prev.selectedCartIds, event.cartId],
    ));
  }

  void _onUnSelectCart(UnSelectCart event, Emitter<CartState> emit) async {
    final prev = (state as CartLoaded);
    // emit(prev.copyWith(selectedCartIds: prev.selectedCartIds..remove(event.cartId)));
    emit(prev.copyWith(
      selectedCartIds: prev.selectedCartIds.where((id) => id != event.cartId).toList(),
    ));
  }
}
