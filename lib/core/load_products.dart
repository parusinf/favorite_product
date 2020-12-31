import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:favorite_product/core.dart';

/// Выбор CSV файла и загрузка продуктов
Future chooseAndLoadProducts(BuildContext context) async {
  final l10n = L10n.of(context);
  if (!(await Permission.storage.request().isGranted)) {
    throw l10n.permissionDenied;
  }
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );
  if (result == null) {
    throw l10n.fileNotSelected;
  }
  await loadProducts(context, result.files.single.path);
}

/// Заргузка продуктов
Future loadProducts(BuildContext context, String fileName) async {
  final l10n = L10n.of(context);
  if (!(await Permission.storage.request().isGranted)) {
    throw l10n.permissionDenied;
  }
  final file = File(fileName);
  final content = file.readAsStringSync();
  await parseProducts(context, content);
}

/// Разбор продуктов
Future parseProducts(BuildContext context, String content) async {
  final db = Provider.of<Db>(context, listen: false);
  final l10n = L10n.of(context);
  final rows = content.split('\n');
  for (int i = 0; i < rows.length && isNotEmpty(rows[i]); i++) {
    Product product;
    if (rows[i].contains(';')) {
      product = await _parseCsv(db, l10n, rows[i]);
    } else {
      product = await _parseTxt(db, l10n, rows[i]);
    }
    await db.productsDao.insert2(
        groupId: product.groupId,
        nomenclatureId: product.nomenclatureId,
        cost: product.cost,
        date: product.date,
    );
  }
}

Future<Product> _parseTxt(Db db, L10n l10n, String row) async {
  final words = row.split(' ');
  if (words.length > 1 && !isDigit(words.last)) {
    words.removeLast();
  }
  final cost = stringToDouble(words.last);
  if (cost == null || words.length < 2) {
    throw l10n.fileFormatError;
  }
  words.removeLast();
  final name = words.join(' ');
  return Product(
      id: null,
      groupId: db.activeGroupStream.value.id,
      nomenclatureId: await _nomenclatureId(db, name, null),
      cost: cost,
      date: today(),
  );
}

Future<Product> _parseCsv(Db db, L10n l10n, String row) async {
  final fields = row.split(';');
  if (fields.length != 4) {
    throw l10n.fileFormatError;
  }
  final cost = stringToDouble(fields[3]);
  final date = stringToDate(fields[0]);
  if (cost == null || date == null) {
    throw l10n.fileFormatError;
  }
  return Product(
    id: null,
    groupId: db.activeGroupStream.value.id,
    nomenclatureId: await _nomenclatureId(db, fields[1], fields[2]),
    cost: cost,
    date: date,
  );
}

Future<int> _nomenclatureId(Db db, String name, String categoryName) async =>
    (await db.nomenclaturesDao.find(name) ??
        await db.nomenclaturesDao.insert2(
            name: name,
            categoryId: categoryName != null ? await _categoryId(db, categoryName) : null,
        )
    ).id;

Future<int> _categoryId(Db db, String name) async =>
    (await db.categoriesDao.find(name) ?? await db.categoriesDao.insert2(name: name)).id;
