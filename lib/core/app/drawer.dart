import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_event.dart';
import '../theme/styles_utils.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: AppStyles.primaryColor,
      width: size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // DrawerHeader(child: Text('Usuario', style: AppStyles.bigTextStyle)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            padding: EdgeInsets.only(bottom: size.height * 0.08),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.07),
              ),
              tileColor: AppStyles.secondaryColor,
              leading: Icon(Icons.logout, color: AppStyles.primaryWhite),
              title: Text(
                textAlign: TextAlign.center,
                AppStyles.logoutText,
                style: AppStyles.bigTextFieldStyle,
              ),
              onTap: () => _logOut(context),
            ),
          ),
        ],
      ),
    );
  }

  _logOut(BuildContext context) {
    Navigator.pop(context);
    context.read<AuthBloc>().add(SignOutEvent());
  }
}
