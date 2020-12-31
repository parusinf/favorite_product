import 'package:favorite_product/db/db.dart';

Future initialDatabase(Db db) async {
  await db.groupsDao.insert2(name: 'ВкусВилл');
  await db.categoriesDao.insert2(name: 'Фрукты');
  await db.categoriesDao.insert2(name: 'Варёнка');
  await db.categoriesDao.insert2(name: 'Выпечка');
  await db.categoriesDao.insert2(name: 'Животка');
  await db.categoriesDao.insert2(name: 'Сладости');
  await db.categoriesDao.insert2(name: 'Прочее');
}