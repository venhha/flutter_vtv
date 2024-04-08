import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/cart/presentation/components/cart_badge.dart';
import '../../../features/home/presentation/components/search_components/search_bar.dart';
import '../../../features/home/presentation/pages/search_page.dart';

AppBar buildAppBar(
  BuildContext context, {
  Widget? title,
  bool showSettingButton = false,
  bool showSearchBar = true,
  TextEditingController? searchController,
  Widget? leading,
  Function(String)? onSubmittedCallback,
  bool clearOnSubmit = false,
  bool automaticallyImplyLeading = false,
  Color? backgroundColor,
  PreferredSizeWidget? bottom,
  double? scrolledUnderElevation,
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
          child: SearchBarComponent(
            controller: searchController,
            clearOnSubmit: clearOnSubmit,
            onSubmitted: (text) {
              if (onSubmittedCallback != null) {
                onSubmittedCallback(text);
              } else {
                context.go(SearchPage.path, extra: text);
              }
            },
          ),
        ),
      // icon cart badge (number of items in cart)
      CartBadge(pushOnNav: pushOnNav),

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
