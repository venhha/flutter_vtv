import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/components/custom_widgets.dart';
import 'package:flutter_vtv/features/auth/presentation/components/not_logged_widget.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_cubit.dart';
import '../components/logged_widget.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  static const String routeName = 'user';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          log('code ${state.code} message ${state.message}');
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
          if (state.code == 200) {
            context.go('/user/login');
          }
        } else if (state.status == AuthStatus.authenticated) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
          context.go('/user');
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const NotLoggedWidget();
        } else if (state.status == AuthStatus.authenticated) {
          return LoggedWidget(userInfo: state.auth!.userInfo);
        } else {
          return loadingWidget;
        }
      },
    );
  }
}