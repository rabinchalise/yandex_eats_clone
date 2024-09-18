import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_eats_clone/app/app.dart';

class UserCredentialsForm extends StatelessWidget {
  const UserCredentialsForm({required this.formKey, super.key});
  final GlobalKey<ShadFormState> formKey;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Column(
      children: [
        ShadForm(
          key: formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isPotrait ? 462 : double.infinity,
            ),
            child: Column(
              children: [
                ShadInputFormField(
                  readOnly: true,
                  onPressed: () => context.pushNamed(
                    AppRoutes.updateEmail.name,
                  ),
                  label: const Text('Email'),
                  placeholder: const Text('Email'),
                  initialValue: user.email,
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
                const SizedBox(height: AppSpacing.md),
                ShadInputFormField(
                  id: 'username',
                  label: const Text('Username'),
                  placeholder: const Text('Username'),
                  initialValue: user.name,
                  prefix: const Padding(
                    padding: EdgeInsets.all(
                      AppSpacing.sm,
                    ),
                    child: ShadImage.square(
                      LucideIcons.user,
                      size: AppSpacing.lg,
                    ),
                  ),
                  validator: (value) {
                    final username = Username.dirty(value);

                    return username.errorMessage;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
