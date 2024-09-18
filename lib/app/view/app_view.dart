import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone/app/app.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router(context.read<AppBloc>());
    return ShadApp.materialRouter(
      title: 'Yandex Eats Clone',
      debugShowCheckedModeBanner: false,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      themeMode: ThemeMode.system,
      materialThemeBuilder: (context, theme) {
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            surfaceTintColor: AppColors.transparent,
          ),
          textTheme: theme.brightness == Brightness.light
              ? const AppTheme().textTheme
              : const AppDarkTheme().textTheme,
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
      routerConfig: router,
    );
  }
}
