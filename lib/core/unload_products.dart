import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_share_content/flutter_share_content.dart';
import 'package:favorite_product/core.dart';

/// Выгрузка продуктов активной группы в CSV файл
Future unloadProducts(BuildContext context) async {
  final db = Provider.of<Db>(context, listen: false);
  final buffer = new StringBuffer();

  if (!(await Permission.storage.request().isGranted)) {
    throw L10n.of(context).permissionDenied;
  }

  // Цикл по продуктам активной группы
  for (final product in db.productsStream.value.reversed) {
    buffer.write(
        '${dateToString(product.date)};'
        '${product.nomenclature.name};'
        '${product.nomenclature.category?.name ?? ''};'
        '${doubleToString(product.cost, thousandSeparator: false)}\n'
    );
  }

  // Запись файла
  final filename = '${db.activeGroupStream.value.name}.csv'.replaceAll(' ', '_');
  final directory = await getExternalStorageDirectory();
  final file = File(p.join(directory.path, filename));
  file.writeAsStringSync(buffer.toString(), flush: true);

  // Отправка файла
  FlutterShareContent.shareContent(imageUrl: file.path);
}