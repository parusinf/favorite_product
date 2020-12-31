import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:favorite_product/core.dart';

/// Справка
class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => HelpPageState();
}

/// Состояние справки
class HelpPageState extends State<HelpPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(L10n.of(context).help),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.ondemand_video),
          onPressed: () => launchUrl(_scaffoldKey, 'https://youtu.be/oQKwnLZZsNo'),
        ),
      ],
    ),
    body: Markdown(data: _fetchHelp()),
  );

  String _fetchHelp() {
    return '''
# Любимый продукт

## О приложении

Формируйте рейтинг продуктов для оптимизации затрат:

1. Добавляйте продукты с их стоимостью.
2. Открывайте электронные чеки в приложении.
3. Обменивайтесь списками продуктов через Telegram.

## Использование

### Жесты

* Выбор: _тап_
* Редактирование: _двойной тап_
* Удаление: _свайп влево или вправо_

### Демо
[Видео-демонстрация](https://youtu.be/oQKwnLZZsNo)

## Выпуск

2020.12.7+3

## Автор

Павел Никитин

[parusinf@gmail.com](mailto:parusinf@gmail.com)
''';
  }
}