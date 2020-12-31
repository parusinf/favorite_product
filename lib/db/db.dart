import 'dart:io';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:favorite_product/db/initial_database.dart';

part 'db.g.dart';

/// Представление категории
class CategoryView extends Category {
  final int count; // Количество номенклатур в категории

  CategoryView({
    @required int id,
    @required String name,
    this.count,
  }) : super(
    id: id,
    name: name,
  );
}

/// Представление номенклатуры
class NomenclatureView extends Nomenclature {
  final Category category;
  final int count; // Количество продуктов с номенклатурой

  NomenclatureView({
    @required int id,
    @required String name,
    this.category,
    this.count,
  }) : super(
    id: id,
    name: name,
    categoryId: category?.id,
  );
}

/// Представление группы
class GroupView extends Group {
  final double cost;   // Стоимость продуктов в группе
  final int count;     // Количество продуктов в группе

  GroupView({
    @required int id,
    @required String name,
    this.cost = 0,
    this.count = 0,
  }) : super(
    id: id,
    name: name,
  );
}

/// Группа с признаком активности
class GroupWithActiveSing {
  GroupView groupView;
  bool isActive;
  GroupWithActiveSing(this.groupView, this.isActive);
}

/// Представление продукта
class ProductView extends Product {
  NomenclatureView nomenclature;
  final int count; // Количество продуктов при группировке

  ProductView({
    @required int id,
    @required int groupId,
    @required double cost,
    DateTime date,
    this.nomenclature,
    this.count = 0,
  }) : super(
    id: id,
    groupId: groupId,
    nomenclatureId: nomenclature.id,
    cost: cost,
    date: date,
  );
}

/// База данных
@UseMoor(
  include: {'model.moor'},
  tables: [
    Categories,    // Категории
    Nomenclatures, // Номенклатуры
    Groups,        // Группы
    Products,      // Продукты
    Settings,      // Настройки
  ],
  daos: [
    CategoriesDao,
    NomenclaturesDao,
    GroupsDao,
    ProductsDao,
    SettingsDao
  ]
)
class Db extends _$Db {
  final activeGroupStream = BehaviorSubject<GroupView>();
  final groupsStream = BehaviorSubject<List<GroupWithActiveSing>>();
  final productsStream = BehaviorSubject<List<ProductView>>();
  final productsByNomenclaturesStream = BehaviorSubject<List<ProductView>>();
  final productsByWordsStream = BehaviorSubject<List<ProductView>>();
  final productsByCategoriesStream = BehaviorSubject<List<ProductView>>();

  /// Создание потоков данных
  Db() : super(_openConnection()) {
    // Отслеживание активной группы
    Rx.concat([settingsDao.watchActiveGroup()]).listen(activeGroupStream.add);

    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<GroupWithActiveSing>>(
        groupsDao.watch(),
        activeGroupStream,
        (groups, selected) => groups.map((group) =>
            GroupWithActiveSing(group, group?.id == selected?.id)).toList()
    ).listen(groupsStream.add);

    // Отслеживание продуктов в активной группе
    Rx.concat([activeGroupStream.switchMap(productsDao.watch)])
        .listen(productsStream.add);

    // Отслеживание продуктов по номенклатурам в активной группе
    Rx.concat([activeGroupStream.switchMap(productsDao.watchNomenclatures)])
        .listen(productsByNomenclaturesStream.add);

    // Отслеживание продуктов по словам в активной группе
    Rx.concat([activeGroupStream.switchMap(productsDao.watchWords)])
        .listen(productsByWordsStream.add);

    // Отслеживание продуктов по категориям в активной группе
    Rx.concat([activeGroupStream.switchMap(productsDao.watchCategories)])
        .listen(productsByCategoriesStream.add);
  }

  /// При модернизации модели нужно увеличить версию схемы и прописать миграцию
  @override
  int get schemaVersion => 1;

  /// Формирование графика и группы по умолчанию
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) {
      return migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        transaction(() async {
          await initialDatabase(this);
        });
      }
    }
  );

  @override
  Future close() async {
    await activeGroupStream.close();
    await groupsStream.close();
    await productsStream.close();
    await productsByNomenclaturesStream.close();
    await productsByWordsStream.close();
    await productsByCategoriesStream.close();
    super.close();
  }
}

/// Помещает файл базы данных в каталог документов приложения
LazyDatabase _openConnection() => LazyDatabase(() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'db.sqlite'));
  return VmDatabase(file);
});

// Категории -------------------------------------------------------------------
@UseDao(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<Db> with _$CategoriesDaoMixin {
  CategoriesDao(Db db) : super(db);

  /// Добавление
  Future<Category> insert2({
    @required String name,
  }) async {
    final id = await into(db.categories).insert(
      CategoriesCompanion(
        name: Value(name),
      ),
    );
    return Category(
      id: id,
      name: name,
    );
  }

  /// Исправление
  Future<bool> update2(Category category) async =>
      await update(db.categories).replace(category);

  /// Удаление
  Future<bool> delete2(Category category) async =>
      (await delete(db.categories).delete(category)) > 0 ? true : false;

  /// Отслеживание
  Stream<List<Category>> watch() =>
      db._categoriesView().map((row) =>
          CategoryView(
            id: row.id,
            name: row.name,
            count: row.count,
          )
      ).watch();

  /// Поиск
  Future<Category> find(String name) async =>
      await (select(db.categories)..where((e) =>
          e.name.equals(name)
      )).getSingle();
}

// Номенклатуры ----------------------------------------------------------------
@UseDao(tables: [Nomenclatures])
class NomenclaturesDao extends DatabaseAccessor<Db> with _$NomenclaturesDaoMixin {
  NomenclaturesDao(Db db) : super(db);

  /// Добавление
  Future<Nomenclature> insert2({
    @required String name,
    int categoryId,
  }) async {
    final id = await into(db.nomenclatures).insert(
      NomenclaturesCompanion(
        name: Value(name),
        categoryId: Value(categoryId),
      ),
    );
    return Nomenclature(
      id: id,
      name: name,
      categoryId: categoryId,
    );
  }

  /// Исправление
  Future<bool> update2(Nomenclature nomenclature) async =>
      await update(db.nomenclatures).replace(nomenclature);

  /// Удаление
  Future<bool> delete2(Nomenclature nomenclature) async =>
      (await delete(db.nomenclatures).delete(nomenclature)) > 0 ? true : false;

  /// Отслеживание
  Stream<List<Nomenclature>> watch() =>
      db._nomenclaturesView().map((row) =>
          NomenclatureView(
            id: row.id,
            name: row.name,
            category: Category(id: row.categoryId, name: row.categoryName),
            count: row.count,
          )
      ).watch();

  /// Поиск
  Future<Nomenclature> find(String name) async =>
      await (select(db.nomenclatures)..where((e) => e.name.equals(name))).getSingle();
}

// Группы ----------------------------------------------------------------------
@UseDao(tables: [Groups])
class GroupsDao extends DatabaseAccessor<Db> with _$GroupsDaoMixin {
  GroupsDao(Db db) : super(db);

  /// Добавление
  Future<Group> insert2({
    @required String name,
  }) async {
    final id = await into(db.groups).insert(
      GroupsCompanion(
        name: Value(name),
      ),
    );
    final group = Group(id: id, name: name);
    await db.settingsDao.setActiveGroup(group);
    return group;
  }

  /// Исправление
  Future<bool> update2(Group group) async =>
      await update(db.groups).replace(group);

  /// Удаление
  Future<bool> delete2(Group group) async {
    final previousGroup = await db.groupsDao.getPrevious(group);
    await db.settingsDao.setActiveGroup(previousGroup);
    return (await delete(db.groups).delete(group)) > 0 ? true : false;
  }

  /// Отслеживание
  Stream<List<GroupView>> watch() =>
      db._groupsView().map((row) =>
          GroupView(
            id: row.id,
            name: row.name,
            cost: row.cost,
            count: row.count,
          )
      ).watch();

  /// Поиск
  Future<Group> find(String name) async =>
      await (select(db.groups)..where((e) =>
          e.name.equals(name)
      )).getSingle();

  /// Предыдущая группа перед заданной
  Future<Group> getPrevious(Group group) async =>
    await db._previousGroup(group.name).map((row) =>
        Group(
          id: row.id,
          name: row.name,
        )
    ).getSingle() ?? _getFirst();

  /// Первая группа организации в алфавитном порядке
  Future<Group> _getFirst() async =>
      await db._firstGroup().map((row) =>
          Group(
            id: row.id,
            name: row.name,
          )
      ).getSingle();
}

// Продукты --------------------------------------------------------------------
@UseDao(tables: [Products])
class ProductsDao extends DatabaseAccessor<Db> with _$ProductsDaoMixin {
  ProductsDao(Db db) : super(db);

  /// Добавление
  Future<Product> insert2({
    @required int groupId,
    @required int nomenclatureId,
    @required double cost,
    @required DateTime date,
  }) async {
    final id = await into(db.products).insert(
        ProductsCompanion(
          groupId: Value(groupId),
          nomenclatureId: Value(nomenclatureId),
          cost: Value(cost),
          date: Value(date),
        )
    );
    return Product(
      id: id,
      groupId: groupId,
      nomenclatureId: nomenclatureId,
      cost: cost,
      date: date,
    );
  }

  /// Исправление
  Future<bool> update2(Product product) async =>
      await update(db.products).replace(product);

  /// Удаление
  Future<bool> delete2(Product product) async =>
      (await delete(db.products).delete(product)) > 0 ? true : false;

  /// Отслеживание
  Stream<List<Product>> watch(Group group) =>
      db._productsInGroup(group?.id).map((row) => ProductView(
        id: row.id,
        groupId: row.groupId,
        nomenclature: NomenclatureView(
          id: row.nomenclatureId, 
          name: row.nomenclatureName,
          category: Category(id: row.categoryId, name: row.categoryName),
        ),
        cost: row.cost,
        date: row.date,
      )).watch();

  /// Отслеживание продуктов с группировкой по номенклатурам
  Stream<List<ProductView>> watchNomenclatures(Group group) =>
      db._productsByNomenclatures(group?.id).map((row) => ProductView(
        id: 0,
        groupId: group?.id,
        nomenclature: NomenclatureView(
          id: null,
          name: row.name,
        ),
        cost: row.cost,
        count: row.count,
      )).watch();

  /// Отслеживание продуктов с группировкой по словам
  Stream<List<ProductView>> watchWords(Group group) =>
      db._productsByWords(group?.id).map((row) => ProductView(
        id: 0,
        groupId: group?.id,
        nomenclature: NomenclatureView(
          id: null,
          name: row.name,
        ),
        cost: row.cost,
        count: row.count,
      )).watch();

  /// Отслеживание продуктов с группировкой по категориям
  Stream<List<ProductView>> watchCategories(Group group) =>
      db._productsByCategories(group?.id).map((row) => ProductView(
        id: null,
        groupId: group?.id,
        nomenclature: NomenclatureView(
          id: null,
          name: row.name,
        ),
        cost: row.cost,
        count: row.count,
      )).watch();
}

// Настройки -------------------------------------------------------------------
@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Db> with _$SettingsDaoMixin {
  SettingsDao(Db db) : super(db);

  /// Добавление настройки
  Future<Setting> insert2(String name, {
    String textValue,
    int intValue,
    DateTime dateValue,
  }) async {
    final id = await into(db.settings).insert(
        SettingsCompanion(
          name: Value(name),
          textValue: Value(textValue),
          intValue: Value(intValue),
          dateValue: Value(dateValue),
        )
    );
    return Setting(
      id: id,
      name: name,
      textValue: textValue,
      intValue: intValue,
      dateValue: dateValue,
    );
  }

  /// Удаление настройки
  void delete2(String settingName) =>
      delete(db.settings).where((row) => row.name.equals(settingName));

  /// Активная группа
  Stream<GroupView> watchActiveGroup() =>
      db._activeGroupStream().map((row) =>
          GroupView(
            id: row.id,
            name: row.name,
            cost: row.cost,
          )
      ).watchSingle();

  /// Установка активной группы
  Future setActiveGroup(Group group) async {
    if (group == null)
      delete2('activeGroupStream');
    else {
      final count = await db._setActiveGroup(group.id);
      if (count == 0) {
        insert2('activeGroupStream', intValue: group.id);
      }
    }
  }
}