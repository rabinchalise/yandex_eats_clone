import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:form_fields/form_fields.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_eats_clone/app/app.dart';

class UserUpdateEmailForm extends StatefulWidget {
  const UserUpdateEmailForm({super.key});

  @override
  State<UserUpdateEmailForm> createState() => _UserUpdateEmailFormState();
}

class _UserUpdateEmailFormState extends State<UserUpdateEmailForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obsecure;

  @override
  void initState() {
    _obsecure = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    _obsecure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Update email'),
        centerTitle: false,
        titleTextStyle: context.headlineSmall,
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: ShadForm(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 462,
                  ),
                  child: Column(
                    children: [
                      ShadInputFormField(
                        id: 'email',
                        label: const Text('Email'),
                        placeholder: const Text('abc@gmail.com'),
                        validator: (value) {
                          final email = Email.dirty(value);
                          return email.errorMessage;
                        },
                        prefix: const Padding(
                          padding: EdgeInsets.all(
                            AppSpacing.sm,
                          ),
                          child: ShadImage.square(
                            LucideIcons.mail,
                            size: AppSpacing.lg,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _obsecure,
                        child: const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: ShadImage.square(
                            LucideIcons.lock,
                            size: AppSpacing.lg,
                          ),
                        ),
                        builder: (context, obsecure, prefix) {
                          return ShadInputFormField(
                            id: 'password',
                            label: const Text('Password'),
                            placeholder: const Text('123456'),
                            prefix: prefix,
                            obscureText: obsecure,
                            suffix: ShadButton.secondary(
                              width: AppSpacing.xlg + AppSpacing.sm,
                              height: AppSpacing.xlg + AppSpacing.sm,
                              padding: EdgeInsets.zero,
                              decoration: const ShadDecoration(
                                secondaryBorder: ShadBorder.none,
                                secondaryFocusedBorder: ShadBorder.none,
                              ),
                              icon: ShadImage.square(
                                obsecure ? LucideIcons.eyeOff : LucideIcons.eye,
                                size: AppSpacing.lg,
                              ),
                              onPressed: () =>
                                  _obsecure.value = !_obsecure.value,
                            ),
                            validator: (value) {
                              final password = Password.dirty(value);
                              return password.errorMessage;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: AppSpacing.md,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ShadButton(
              width: double.infinity,
              child: const Text('Update email'),
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                final email =
                    _formKey.currentState?.value['email'].toString() ?? '';
                final password =
                    _formKey.currentState?.value['passowrd'].toString() ?? '';

                context.read<AppBloc>().add(
                      AppUpdateAccountEmailRequested(
                        email: email,
                        password: password,
                      ),
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: 10.seconds,
                    content: const Text(
                      'Verification email sent. Please check your new email'
                      ' and verify.',
                    ),
                  ),
                );
                final mailInboxUrl =
                    Uri.parse('https://mail.google.com/mail/u/0/#inbox');
                void logout() {
                  context.read<AppBloc>().add(AppLogoutRequested());
                }

                await launchUrl(mailInboxUrl);
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
