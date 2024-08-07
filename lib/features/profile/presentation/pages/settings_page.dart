import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import '../../../../config/themes/theme_provider.dart';
import 'address_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = 'settings';
  static const String path = '/user/settings';

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required void Function()? onPressed,
    Color? backgroundColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            backgroundColor ?? Theme.of(context).buttonTheme.colorScheme?.primaryContainer.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarSetting(context),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddress(context),
              _buildChangePassword(context),
              _buildIntroduction(context),
              const Spacer(),
              _buildLogout(context),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBarSetting(BuildContext context) {
    return AppBar(
      title: const Text('Cài đặt'),
      actions: [
        // dev page button
        IconButton(
          onPressed: () {
            GoRouter.of(context).go('/dev');
          },
          icon: const Icon(Icons.developer_mode),
        ),

        //# toggle theme
        ToggleButtons(
          borderRadius: BorderRadius.circular(8),
          isSelected: [!isDarkMode(context), isDarkMode(context)],
          onPressed: (index) {
            context.read<ThemeProvider>().toggleTheme();
          },
          children: const [
            Icon(Icons.light_mode),
            Icon(Icons.dark_mode),
          ],
        ),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return _buildButton(context, backgroundColor: Colors.red.shade200, title: 'Đăng xuất', onPressed: () {
      showDialogToConfirm(
        context: context,
        title: 'Đăng xuất',
        content: 'Bạn có chắc chắn muốn đăng xuất?',
        // confirmTextColor: Colors.red,
        confirmBackgroundColor: Colors.red.shade300,
        // confirmTextColor: Colors.red.shade900,
        confirmText: 'Đăng xuất',
        dismissText: 'Thoát',
        onConfirm: () async {
          final refreshToken = context.read<AuthCubit>().state.auth!.refreshToken;
          context.read<AuthCubit>().logout(refreshToken);
          // GoRouter.of(context).go('/user');
        },
      );
    });
  }

  Widget _buildIntroduction(BuildContext context) {
    return _buildButton(context, title: 'Giới thiệu', onPressed: () {
      showCrossPlatformAboutDialog(context: context);
    });
  }

  Widget _buildChangePassword(BuildContext context) {
    return _buildButton(
      context,
      title: 'Thay đổi mật khẩu',
      onPressed: () {
        GoRouter.of(context).go('/user/settings/change-password');
      },
    );
  }

  Widget _buildAddress(BuildContext context) {
    return _buildButton(
      context,
      title: 'Địa chỉ',
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const AddressPage(),
        // ));
        GoRouter.of(context).go(AddressPage.path, extra: false); //extra: false >> avoid pop
      },
    );
  }
}
