import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routeInformationProvider: appRouter.routeInformationProvider,
        routeInformationParser: appRouter.routeInformationParser,
        routerDelegate: appRouter.routerDelegate,
        theme: ThemeData(fontFamily: 'Trispace'),
      ),
    );
  }
}
