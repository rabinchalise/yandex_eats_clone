import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_eats_clone/auth/auth.dart';
import 'package:yandex_eats_clone/auth/login/login.dart';
import 'package:yandex_eats_clone/auth/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SignUpCubit(userRepository: context.read<UserRepository>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            const WelcomeImage(),
            const SizedBox(height: AppSpacing.lg),
            const SignUpForm(),
            const Spacer(),
            SignUpFooter(
              text: 'Sign in',
              onTap: () {
                context.read<AuthCubit>().changeAuth(showLogin: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
