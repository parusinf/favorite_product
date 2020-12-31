// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  Category({@required this.id, @required this.name});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({int id, String name}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CategoriesCompanion copyWith({Value<int> id, Value<String> name}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, Category> {
  final GeneratedDatabase _db;
  final String _alias;
  Categories(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  Categories get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Categories createAlias(String alias) {
    return Categories(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Nomenclature extends DataClass implements Insertable<Nomenclature> {
  final int id;
  final String name;
  final int categoryId;
  Nomenclature({@required this.id, @required this.name, this.categoryId});
  factory Nomenclature.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Nomenclature(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      categoryId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}categoryId']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || categoryId != null) {
      map['categoryId'] = Variable<int>(categoryId);
    }
    return map;
  }

  NomenclaturesCompanion toCompanion(bool nullToAbsent) {
    return NomenclaturesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
    );
  }

  factory Nomenclature.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Nomenclature(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  Nomenclature copyWith({int id, String name, int categoryId}) => Nomenclature(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('Nomenclature(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, categoryId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Nomenclature &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId);
}

class NomenclaturesCompanion extends UpdateCompanion<Nomenclature> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  const NomenclaturesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  NomenclaturesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.categoryId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Nomenclature> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'categoryId': categoryId,
    });
  }

  NomenclaturesCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> categoryId}) {
    return NomenclaturesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['categoryId'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NomenclaturesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class Nomenclatures extends Table with TableInfo<Nomenclatures, Nomenclature> {
  final GeneratedDatabase _db;
  final String _alias;
  Nomenclatures(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('categoryId', $tableName, true,
        $customConstraints: 'REFERENCES categories (id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId];
  @override
  Nomenclatures get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'nomenclatures';
  @override
  final String actualTableName = 'nomenclatures';
  @override
  VerificationContext validateIntegrity(Insertable<Nomenclature> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['categoryId'], _categoryIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Nomenclature map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Nomenclature.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Nomenclatures createAlias(String alias) {
    return Nomenclatures(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  Group({@required this.id, @required this.name});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Group(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Group copyWith({int id, String name}) => Group(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Group && other.id == this.id && other.name == this.name);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  static Insertable<Group> custom({
    Expression<int> id,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GroupsCompanion copyWith({Value<int> id, Value<String> name}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class Groups extends Table with TableInfo<Groups, Group> {
  final GeneratedDatabase _db;
  final String _alias;
  Groups(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  Groups get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'groups';
  @override
  final String actualTableName = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Group.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Groups createAlias(String alias) {
    return Groups(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final int groupId;
  final int nomenclatureId;
  final double cost;
  final DateTime date;
  Product(
      {@required this.id,
      @required this.groupId,
      @required this.nomenclatureId,
      @required this.cost,
      @required this.date});
  factory Product.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Product(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      groupId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}groupId']),
      nomenclatureId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}nomenclatureId']),
      cost: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}cost']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || groupId != null) {
      map['groupId'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || nomenclatureId != null) {
      map['nomenclatureId'] = Variable<int>(nomenclatureId);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      nomenclatureId: nomenclatureId == null && nullToAbsent
          ? const Value.absent()
          : Value(nomenclatureId),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      nomenclatureId: serializer.fromJson<int>(json['nomenclatureId']),
      cost: serializer.fromJson<double>(json['cost']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'nomenclatureId': serializer.toJson<int>(nomenclatureId),
      'cost': serializer.toJson<double>(cost),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Product copyWith(
          {int id,
          int groupId,
          int nomenclatureId,
          double cost,
          DateTime date}) =>
      Product(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        nomenclatureId: nomenclatureId ?? this.nomenclatureId,
        cost: cost ?? this.cost,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('nomenclatureId: $nomenclatureId, ')
          ..write('cost: $cost, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          groupId.hashCode,
          $mrjc(
              nomenclatureId.hashCode, $mrjc(cost.hashCode, date.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.nomenclatureId == this.nomenclatureId &&
          other.cost == this.cost &&
          other.date == this.date);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> nomenclatureId;
  final Value<double> cost;
  final Value<DateTime> date;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.nomenclatureId = const Value.absent(),
    this.cost = const Value.absent(),
    this.date = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    @required int groupId,
    @required int nomenclatureId,
    @required double cost,
    @required DateTime date,
  })  : groupId = Value(groupId),
        nomenclatureId = Value(nomenclatureId),
        cost = Value(cost),
        date = Value(date);
  static Insertable<Product> custom({
    Expression<int> id,
    Expression<int> groupId,
    Expression<int> nomenclatureId,
    Expression<double> cost,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'groupId': groupId,
      if (nomenclatureId != null) 'nomenclatureId': nomenclatureId,
      if (cost != null) 'cost': cost,
      if (date != null) 'date': date,
    });
  }

  ProductsCompanion copyWith(
      {Value<int> id,
      Value<int> groupId,
      Value<int> nomenclatureId,
      Value<double> cost,
      Value<DateTime> date}) {
    return ProductsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      nomenclatureId: nomenclatureId ?? this.nomenclatureId,
      cost: cost ?? this.cost,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['groupId'] = Variable<int>(groupId.value);
    }
    if (nomenclatureId.present) {
      map['nomenclatureId'] = Variable<int>(nomenclatureId.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('nomenclatureId: $nomenclatureId, ')
          ..write('cost: $cost, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class Products extends Table with TableInfo<Products, Product> {
  final GeneratedDatabase _db;
  final String _alias;
  Products(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  GeneratedIntColumn _groupId;
  GeneratedIntColumn get groupId => _groupId ??= _constructGroupId();
  GeneratedIntColumn _constructGroupId() {
    return GeneratedIntColumn('groupId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES "groups" (id)');
  }

  final VerificationMeta _nomenclatureIdMeta =
      const VerificationMeta('nomenclatureId');
  GeneratedIntColumn _nomenclatureId;
  GeneratedIntColumn get nomenclatureId =>
      _nomenclatureId ??= _constructNomenclatureId();
  GeneratedIntColumn _constructNomenclatureId() {
    return GeneratedIntColumn('nomenclatureId', $tableName, false,
        $customConstraints: 'NOT NULL REFERENCES nomenclatures (id)');
  }

  final VerificationMeta _costMeta = const VerificationMeta('cost');
  GeneratedRealColumn _cost;
  GeneratedRealColumn get cost => _cost ??= _constructCost();
  GeneratedRealColumn _constructCost() {
    return GeneratedRealColumn('cost', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn('date', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, nomenclatureId, cost, date];
  @override
  Products get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'products';
  @override
  final String actualTableName = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('groupId')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['groupId'], _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('nomenclatureId')) {
      context.handle(
          _nomenclatureIdMeta,
          nomenclatureId.isAcceptableOrUnknown(
              data['nomenclatureId'], _nomenclatureIdMeta));
    } else if (isInserting) {
      context.missing(_nomenclatureIdMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost'], _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Product.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Products createAlias(String alias) {
    return Products(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String name;
  final String textValue;
  final int intValue;
  final DateTime dateValue;
  Setting(
      {@required this.id,
      @required this.name,
      this.textValue,
      this.intValue,
      this.dateValue});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Setting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      textValue: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}textValue']),
      intValue:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}intValue']),
      dateValue: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}dateValue']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || textValue != null) {
      map['textValue'] = Variable<String>(textValue);
    }
    if (!nullToAbsent || intValue != null) {
      map['intValue'] = Variable<int>(intValue);
    }
    if (!nullToAbsent || dateValue != null) {
      map['dateValue'] = Variable<DateTime>(dateValue);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      textValue: textValue == null && nullToAbsent
          ? const Value.absent()
          : Value(textValue),
      intValue: intValue == null && nullToAbsent
          ? const Value.absent()
          : Value(intValue),
      dateValue: dateValue == null && nullToAbsent
          ? const Value.absent()
          : Value(dateValue),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      textValue: serializer.fromJson<String>(json['textValue']),
      intValue: serializer.fromJson<int>(json['intValue']),
      dateValue: serializer.fromJson<DateTime>(json['dateValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'textValue': serializer.toJson<String>(textValue),
      'intValue': serializer.toJson<int>(intValue),
      'dateValue': serializer.toJson<DateTime>(dateValue),
    };
  }

  Setting copyWith(
          {int id,
          String name,
          String textValue,
          int intValue,
          DateTime dateValue}) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        textValue: textValue ?? this.textValue,
        intValue: intValue ?? this.intValue,
        dateValue: dateValue ?? this.dateValue,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('textValue: $textValue, ')
          ..write('intValue: $intValue, ')
          ..write('dateValue: $dateValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(textValue.hashCode,
              $mrjc(intValue.hashCode, dateValue.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.name == this.name &&
          other.textValue == this.textValue &&
          other.intValue == this.intValue &&
          other.dateValue == this.dateValue);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> textValue;
  final Value<int> intValue;
  final Value<DateTime> dateValue;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.textValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.dateValue = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.textValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.dateValue = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Setting> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> textValue,
    Expression<int> intValue,
    Expression<DateTime> dateValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (textValue != null) 'textValue': textValue,
      if (intValue != null) 'intValue': intValue,
      if (dateValue != null) 'dateValue': dateValue,
    });
  }

  SettingsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> textValue,
      Value<int> intValue,
      Value<DateTime> dateValue}) {
    return SettingsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      textValue: textValue ?? this.textValue,
      intValue: intValue ?? this.intValue,
      dateValue: dateValue ?? this.dateValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (textValue.present) {
      map['textValue'] = Variable<String>(textValue.value);
    }
    if (intValue.present) {
      map['intValue'] = Variable<int>(intValue.value);
    }
    if (dateValue.present) {
      map['dateValue'] = Variable<DateTime>(dateValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('textValue: $textValue, ')
          ..write('intValue: $intValue, ')
          ..write('dateValue: $dateValue')
          ..write(')'))
        .toString();
  }
}

class Settings extends Table with TableInfo<Settings, Setting> {
  final GeneratedDatabase _db;
  final String _alias;
  Settings(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        declaredAsPrimaryKey: true,
        hasAutoIncrement: true,
        $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        $customConstraints: 'NOT NULL');
  }

  final VerificationMeta _textValueMeta = const VerificationMeta('textValue');
  GeneratedTextColumn _textValue;
  GeneratedTextColumn get textValue => _textValue ??= _constructTextValue();
  GeneratedTextColumn _constructTextValue() {
    return GeneratedTextColumn('textValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _intValueMeta = const VerificationMeta('intValue');
  GeneratedIntColumn _intValue;
  GeneratedIntColumn get intValue => _intValue ??= _constructIntValue();
  GeneratedIntColumn _constructIntValue() {
    return GeneratedIntColumn('intValue', $tableName, true,
        $customConstraints: '');
  }

  final VerificationMeta _dateValueMeta = const VerificationMeta('dateValue');
  GeneratedDateTimeColumn _dateValue;
  GeneratedDateTimeColumn get dateValue => _dateValue ??= _constructDateValue();
  GeneratedDateTimeColumn _constructDateValue() {
    return GeneratedDateTimeColumn('dateValue', $tableName, true,
        $customConstraints: '');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, textValue, intValue, dateValue];
  @override
  Settings get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'settings';
  @override
  final String actualTableName = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('textValue')) {
      context.handle(_textValueMeta,
          textValue.isAcceptableOrUnknown(data['textValue'], _textValueMeta));
    }
    if (data.containsKey('intValue')) {
      context.handle(_intValueMeta,
          intValue.isAcceptableOrUnknown(data['intValue'], _intValueMeta));
    }
    if (data.containsKey('dateValue')) {
      context.handle(_dateValueMeta,
          dateValue.isAcceptableOrUnknown(data['dateValue'], _dateValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Setting.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Settings createAlias(String alias) {
    return Settings(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$Db extends GeneratedDatabase {
  _$Db(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  Categories _categories;
  Categories get categories => _categories ??= Categories(this);
  Index _categoriesIndex;
  Index get categoriesIndex => _categoriesIndex ??= Index('categories_index',
      'CREATE UNIQUE INDEX categories_index ON categories (name);');
  Nomenclatures _nomenclatures;
  Nomenclatures get nomenclatures => _nomenclatures ??= Nomenclatures(this);
  Index _nomenclaturesIndex;
  Index get nomenclaturesIndex => _nomenclaturesIndex ??= Index(
      'nomenclatures_index',
      'CREATE UNIQUE INDEX nomenclatures_index ON nomenclatures (name);');
  Groups _groups;
  Groups get groups => _groups ??= Groups(this);
  Index _groupsIndex;
  Index get groupsIndex => _groupsIndex ??= Index(
      'groups_index', 'CREATE UNIQUE INDEX groups_index ON "groups" (name);');
  Products _products;
  Products get products => _products ??= Products(this);
  Index _productsIndex;
  Index get productsIndex => _productsIndex ??= Index('products_index',
      'CREATE INDEX products_index ON products (nomenclatureId, groupId);');
  Settings _settings;
  Settings get settings => _settings ??= Settings(this);
  Index _settingsIndex;
  Index get settingsIndex => _settingsIndex ??= Index('settings_index',
      'CREATE UNIQUE INDEX settings_index ON settings (name);');
  CategoriesDao _categoriesDao;
  CategoriesDao get categoriesDao =>
      _categoriesDao ??= CategoriesDao(this as Db);
  NomenclaturesDao _nomenclaturesDao;
  NomenclaturesDao get nomenclaturesDao =>
      _nomenclaturesDao ??= NomenclaturesDao(this as Db);
  GroupsDao _groupsDao;
  GroupsDao get groupsDao => _groupsDao ??= GroupsDao(this as Db);
  ProductsDao _productsDao;
  ProductsDao get productsDao => _productsDao ??= ProductsDao(this as Db);
  SettingsDao _settingsDao;
  SettingsDao get settingsDao => _settingsDao ??= SettingsDao(this as Db);
  Selectable<CategoriesViewResult> _categoriesView() {
    return customSelect(
        'SELECT CAST((SELECT COUNT(*) FROM nomenclatures WHERE categoryId = C.id) AS INT) AS count,\n       C.name,\n       C.id\n  FROM categories C\n ORDER BY 1 DESC, 2',
        variables: [],
        readsFrom: {nomenclatures, categories}).map((QueryRow row) {
      return CategoriesViewResult(
        count: row.readInt('count'),
        name: row.readString('name'),
        id: row.readInt('id'),
      );
    });
  }

  Selectable<NomenclaturesViewResult> _nomenclaturesView() {
    return customSelect(
        'SELECT CAST((SELECT COUNT(*) FROM products WHERE nomenclatureId = N.id) AS INT) AS count,\n       N.name,\n       N.id,\n       N.categoryId,\n       C.name as categoryName\n  FROM nomenclatures N\n LEFT OUTER JOIN categories C ON C.id = N.categoryId\n ORDER BY 1 DESC, 2',
        variables: [],
        readsFrom: {products, nomenclatures, categories}).map((QueryRow row) {
      return NomenclaturesViewResult(
        count: row.readInt('count'),
        name: row.readString('name'),
        id: row.readInt('id'),
        categoryId: row.readInt('categoryId'),
        categoryName: row.readString('categoryName'),
      );
    });
  }

  Selectable<GroupsViewResult> _groupsView() {
    return customSelect(
        'SELECT CAST((SELECT IFNULL(SUM(cost), 0) FROM products WHERE groupId = G.id) AS REAL) AS cost,\n       CAST((SELECT COUNT(*) FROM products WHERE groupId = G.id) AS INT) AS count,\n       G.name,\n       G.id\n  FROM "groups" G\n ORDER BY 1 DESC, 2',
        variables: [],
        readsFrom: {products, groups}).map((QueryRow row) {
      return GroupsViewResult(
        cost: row.readDouble('cost'),
        count: row.readInt('count'),
        name: row.readString('name'),
        id: row.readInt('id'),
      );
    });
  }

  Selectable<Group> _firstGroup() {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE name = (SELECT MIN(name) FROM "groups")',
        variables: [],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<Group> _previousGroup(String groupName) {
    return customSelect(
        'SELECT *\n  FROM "groups"\n WHERE name = (SELECT MAX(name) FROM "groups" WHERE name < :groupName)',
        variables: [Variable.withString(groupName)],
        readsFrom: {groups}).map(groups.mapFromRow);
  }

  Selectable<ProductsInGroupResult> _productsInGroup(int groupId) {
    return customSelect(
        'SELECT P.id,\n       P.groupId,\n       P.nomenclatureId,\n       N.name AS nomenclatureName,\n       N.categoryId,\n       C.name AS categoryName,\n       P.cost,\n       P.date\n  FROM products P\n INNER JOIN nomenclatures N ON N.id = P.nomenclatureId\n LEFT OUTER JOIN categories C ON C.id = N.categoryId\n WHERE P.groupId = :groupId\n ORDER BY 1 DESC',
        variables: [Variable.withInt(groupId)],
        readsFrom: {products, nomenclatures, categories}).map((QueryRow row) {
      return ProductsInGroupResult(
        id: row.readInt('id'),
        groupId: row.readInt('groupId'),
        nomenclatureId: row.readInt('nomenclatureId'),
        nomenclatureName: row.readString('nomenclatureName'),
        categoryId: row.readInt('categoryId'),
        categoryName: row.readString('categoryName'),
        cost: row.readDouble('cost'),
        date: row.readDateTime('date'),
      );
    });
  }

  Selectable<ProductsByNomenclaturesResult> _productsByNomenclatures(
      int groupId) {
    return customSelect(
        'SELECT IFNULL(SUM(P.cost), 0) AS cost,\n       COUNT(*) AS count,\n       N.name\n  FROM products P\n INNER JOIN nomenclatures N ON N.id = P.nomenclatureId\n WHERE P.groupId = :groupId\n GROUP BY\n       N.name\n ORDER BY 1 DESC, 2 DESC',
        variables: [Variable.withInt(groupId)],
        readsFrom: {products, nomenclatures}).map((QueryRow row) {
      return ProductsByNomenclaturesResult(
        cost: row.readDouble('cost'),
        count: row.readInt('count'),
        name: row.readString('name'),
      );
    });
  }

  Selectable<ProductsByWordsResult> _productsByWords(int groupId) {
    return customSelect(
        'SELECT IFNULL(SUM(P.cost), 0) AS cost,\n       COUNT(*) AS count,\n       SUBSTR(N.name, 1, CASE INSTR(N.name, \' \') WHEN 0 then LENGTH(N.name) ELSE INSTR(N.name, \' \') - 1 END) AS name\n  FROM products P\n INNER JOIN nomenclatures N ON N.id = P.nomenclatureId\n WHERE P.groupId = :groupId\n GROUP BY\n       SUBSTR(N.name, 1, CASE INSTR(N.name, \' \') WHEN 0 then LENGTH(N.name) ELSE INSTR(N.name, \' \') - 1 END)\n ORDER BY 1 DESC, 2 DESC',
        variables: [Variable.withInt(groupId)],
        readsFrom: {products, nomenclatures}).map((QueryRow row) {
      return ProductsByWordsResult(
        cost: row.readDouble('cost'),
        count: row.readInt('count'),
        name: row.readString('name'),
      );
    });
  }

  Selectable<ProductsByCategoriesResult> _productsByCategories(int groupId) {
    return customSelect(
        'SELECT IFNULL(SUM(P.cost), 0) AS cost,\n       COUNT(*) AS count,\n       C.name\n  FROM products P\n INNER JOIN nomenclatures N ON N.id = P.nomenclatureId\n LEFT OUTER JOIN categories C ON C.id = N.categoryId\n WHERE P.groupId = :groupId\n GROUP BY\n       C.name\n ORDER BY 1 DESC, 2 DESC',
        variables: [Variable.withInt(groupId)],
        readsFrom: {products, categories, nomenclatures}).map((QueryRow row) {
      return ProductsByCategoriesResult(
        cost: row.readDouble('cost'),
        count: row.readInt('count'),
        name: row.readString('name'),
      );
    });
  }

  Selectable<ActiveGroupStreamResult> _activeGroupStream() {
    return customSelect(
        'SELECT G.id,\n       G.name,\n       CAST((SELECT SUM(cost) FROM products WHERE groupId = G.id) AS REAL) AS cost\n  FROM settings S\n INNER JOIN "groups" G ON G.id = S.intValue\n WHERE S.name = \'activeGroupStream\'',
        variables: [],
        readsFrom: {groups, products, settings}).map((QueryRow row) {
      return ActiveGroupStreamResult(
        id: row.readInt('id'),
        name: row.readString('name'),
        cost: row.readDouble('cost'),
      );
    });
  }

  Future<int> _setActiveGroup(int id) {
    return customUpdate(
      'UPDATE settings SET intValue = :id WHERE name = \'activeGroupStream\'',
      variables: [Variable.withInt(id)],
      updates: {settings},
      updateKind: UpdateKind.update,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        categoriesIndex,
        nomenclatures,
        nomenclaturesIndex,
        groups,
        groupsIndex,
        products,
        productsIndex,
        settings,
        settingsIndex
      ];
}

class CategoriesViewResult {
  final int count;
  final String name;
  final int id;
  CategoriesViewResult({
    this.count,
    this.name,
    this.id,
  });
}

class NomenclaturesViewResult {
  final int count;
  final String name;
  final int id;
  final int categoryId;
  final String categoryName;
  NomenclaturesViewResult({
    this.count,
    this.name,
    this.id,
    this.categoryId,
    this.categoryName,
  });
}

class FindNomenclatureResult {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;
  FindNomenclatureResult({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
  });
}

class GroupsViewResult {
  final double cost;
  final int count;
  final String name;
  final int id;
  GroupsViewResult({
    this.cost,
    this.count,
    this.name,
    this.id,
  });
}

class ProductsInGroupResult {
  final int id;
  final int groupId;
  final int nomenclatureId;
  final String nomenclatureName;
  final int categoryId;
  final String categoryName;
  final double cost;
  final DateTime date;
  ProductsInGroupResult({
    this.id,
    this.groupId,
    this.nomenclatureId,
    this.nomenclatureName,
    this.categoryId,
    this.categoryName,
    this.cost,
    this.date,
  });
}

class ProductsByNomenclaturesResult {
  final double cost;
  final int count;
  final String name;
  ProductsByNomenclaturesResult({
    this.cost,
    this.count,
    this.name,
  });
}

class ProductsByWordsResult {
  final double cost;
  final int count;
  final String name;
  ProductsByWordsResult({
    this.cost,
    this.count,
    this.name,
  });
}

class ProductsByCategoriesResult {
  final double cost;
  final int count;
  final String name;
  ProductsByCategoriesResult({
    this.cost,
    this.count,
    this.name,
  });
}

class ActiveGroupStreamResult {
  final int id;
  final String name;
  final double cost;
  ActiveGroupStreamResult({
    this.id,
    this.name,
    this.cost,
  });
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CategoriesDaoMixin on DatabaseAccessor<Db> {}
mixin _$NomenclaturesDaoMixin on DatabaseAccessor<Db> {}
mixin _$GroupsDaoMixin on DatabaseAccessor<Db> {}
mixin _$ProductsDaoMixin on DatabaseAccessor<Db> {}
mixin _$SettingsDaoMixin on DatabaseAccessor<Db> {}
