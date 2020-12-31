import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/ui/home_page.dart';
import 'package:favorite_product/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ru_RU';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<Db>(
    create: (_) => Db(),
    dispose: (_, db) => db.close(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => L10n.of(context).favoriteProduct,
      localizationsDelegates: [
        const L10nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        typography: Typography.material2018(),
      ),
      home: HomePage(),
    ),
  );
}