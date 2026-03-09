import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notas_equipo_app/core/utils/routes_utils.dart';
import 'package:notas_equipo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notas_equipo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:notas_equipo_app/features/entry/data/datasources/entry_remote_datasource_impl.dart';
import 'package:notas_equipo_app/features/entry/data/repositories/entry_remote_repository_impl.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_bloc.dart';
import 'package:notas_equipo_app/features/entry/presentation/bloc/entry_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app/gate_app.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/entry/domain/usecases/create_list_entry.dart';
import 'features/entry/domain/usecases/create_reminder_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    // AUTH
    final authRemoteDatasource = AuthRemoteDatasource(supabaseClient);
    final authRepository = AuthRepositoryImpl(authRemoteDatasource);

    final signIn = SignIn(authRepository);
    final signUp = SignUp(authRepository);
    final signOut = SignOut(authRepository);

    // ENTRIES
    final entryRemoteDatasource = EntryRemoteDatasourceImpl(supabaseClient);
    final entryRepository = EntryRemoteRepositoryImpl(
      remoteDatasource: entryRemoteDatasource,
    );

    final createListEntry = CreateListEntry(entryRepository);
    final createReminderEntry = CreateReminderEntry(entryRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signIn: signIn,
            signUp: signUp,
            signOut: signOut,
            repository: authRepository,
          ),
        ),
        BlocProvider<EntryBloc>(
          create: (_) => EntryBloc(
            repository: entryRepository,
            createListEntry: createListEntry,
            createReminderEntry: createReminderEntry,
          )..add(LoadEntries()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AppGate(),
        routes: AppRoutes.getAppRoutes(),
      ),
    );
  }
}
