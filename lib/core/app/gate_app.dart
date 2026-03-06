import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';
import 'package:notas_equipo_app/core/utils/widgets_utils.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:notas_equipo_app/features/auth/presentation/pages/login_page.dart';
import 'package:notas_equipo_app/features/entry/presentation/pages/home_page.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return Scaffold(
            backgroundColor: AppStyles.primaryColor,
            body: WidgetsUtils.loader(AppStyles.secondaryColor),
          );
        }
        if (state is Authenticated) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
