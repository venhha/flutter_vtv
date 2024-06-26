import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';

import '../../../features/cart/presentation/components/cart_badge.dart';
import '../../../features/chat/presentation/pages/customer_chat_room_page.dart';
import '../../../features/home/presentation/components/search/simple_search_bar.dart';
import '../../../features/home/presentation/pages/search_page.dart';

AppBar appBarBuilder(
  BuildContext context, {
  Widget? title,
  bool showSettingButton = false,
  bool showSearchBar = true,
  bool showChat = false,
  TextEditingController? searchController,
  Widget? leading,
  void Function(String)? onSearchSubmitted,
  bool clearOnSubmit = false,
  bool automaticallyImplyLeading = false,
  Color? backgroundColor,
  PreferredSizeWidget? bottom,
  double? scrolledUnderElevation,

  /// if true, push screen on nav stack
  bool pushOnNav = false,
}) {
  // title & search bar can't be shown at the same time
  assert(title == null || showSearchBar == false, 'title & search bar can\'t be shown at the same time');

  return AppBar(
    scrolledUnderElevation: scrolledUnderElevation,
    title: title,
    backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    actions: [
      // search bar
      if (showSearchBar)
        Expanded(
          child: SimpleSearchBar(
            searchController: searchController,
            clearOnSubmit: clearOnSubmit,
            onSubmitted: (text) {
              if (onSearchSubmitted != null) {
                onSearchSubmitted(text);
              } else {
                // context.go(SearchPage.path, extra: text);
                context.go(Uri(path: SearchPage.path, queryParameters: {'q': text}).toString());
              }
            },
          ),
        ),
      // icon cart badge (number of items in cart)
      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status != AuthStatus.authenticated) return const SizedBox.shrink();

          return Row(
            children: [
              // chat icon
              if (showChat)
                IconButton(
                  onPressed: () => context.push(CustomerChatRoomPage.path),
                  icon: const Icon(Icons.chat_outlined),
                ),

              // cart icon
              const CartBadge(),
            ],
          );
        },
      ),

      // icon settings
      if (showSettingButton)
        IconButton.outlined(
          onPressed: () => context.go('/user/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),

      const SizedBox(width: 8),
    ],
  );
}


// return Badge(
//   label: BlocBuilder<AuthCubit, AuthState>(
//     builder: (context, state) {
//       if (state.status != AuthStatus.authenticated) return const SizedBox.shrink();
//       return BlocBuilder<CartBloc, CartState>(
//         builder: (context, state) {
//           if (state is CartLoaded) {
//             return Text(state.cart.count.toString());
//           }
//           return const SizedBox.shrink();
//         },
//       );
//     },
//   ),
//   backgroundColor: Colors.orange,
//   child: IconButton.outlined(
//     onPressed: () => context.go(CartPage.route),
//     icon: const Icon(Icons.shopping_cart_outlined),
//   ),
// );