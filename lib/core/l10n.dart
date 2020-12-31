import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class L10n {
  final Locale locale;

  L10n(this.locale);

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const Map<String, Map<String, String>> _l10n = {
    'ru': {
      'addCategory': 'Добавьте категорию',
      'addGroup': 'Добавьте группу',
      'addNomenclature': 'Добавьте номенклатуру',
      'addProduct': 'Добавьте продукт',
      'categories': 'Категории',
      'category': 'Категория',
      'cost': 'Стоимость',
      'countryPhoneCode': '+7 ',
      'dataLoading': 'Загрузка данных',
      'date': 'Дата',
      'favoriteProduct': 'Любимый продукт',
      'fileFormatError': 'Ошибка в формате файла',
      'fileNotSelected': 'Файл не выбран',
      'from': 'с',
      'group': 'Группа',
      'grouping0': 'Номенклатуры',
      'grouping1': 'Слова',
      'grouping2': 'Категории',
      'groups': 'Группы',
      'help': 'Справка',
      'invalidDate': 'Формат даты ДД.ММ.ГГГГ',
      'linkNotStart': 'Ссылка не запускается',
      'name': 'Наименование',
      'noCost': 'Нет стоимости',
      'noName': 'Нет наименования',
      'nomenclature': 'Номенклатура',
      'nomenclatures': 'Номенклатуры',
      'permissionDenied': 'Разрешение не получено',
      'product': 'Продукт',
      'products': 'Продукты',
      'to': 'по',
      'uniqueCategory': 'Уже есть такая категория',
      'uniqueGroup': 'Уже есть такая группа',
      'uniqueNomenclature': 'Уже есть такая номенклатура',
      'uniqueProduct': 'Уже есть такой продукт',
      'withoutCategory': 'Без категории',
      'withoutTime': 'без срока',
    }
  };

  get addCategory => _l10n[locale.languageCode]['addCategory'];
  get addGroup => _l10n[locale.languageCode]['addGroup'];
  get addNomenclature => _l10n[locale.languageCode]['addNomenclature'];
  get addProduct => _l10n[locale.languageCode]['addProduct'];
  get categories => _l10n[locale.languageCode]['categories'];
  get category => _l10n[locale.languageCode]['category'];
  get cost => _l10n[locale.languageCode]['cost'];
  get countryPhoneCode => _l10n[locale.languageCode]['countryPhoneCode'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get date => _l10n[locale.languageCode]['date'];
  get favoriteProduct => _l10n[locale.languageCode]['favoriteProduct'];
  get fileFormatError => _l10n[locale.languageCode]['fileFormatError'];
  get fileNotSelected => _l10n[locale.languageCode]['fileNotSelected'];
  get from => _l10n[locale.languageCode]['from'];
  get group => _l10n[locale.languageCode]['group'];
  get grouping0 => _l10n[locale.languageCode]['grouping0'];
  get grouping1 => _l10n[locale.languageCode]['grouping1'];
  get grouping2 => _l10n[locale.languageCode]['grouping2'];
  get groups => _l10n[locale.languageCode]['groups'];
  get help => _l10n[locale.languageCode]['help'];
  get invalidDate => _l10n[locale.languageCode]['invalidDate'];
  get linkNotStart => _l10n[locale.languageCode]['linkNotStart'];
  get name => _l10n[locale.languageCode]['name'];
  get noCost => _l10n[locale.languageCode]['noCost'];
  get noName => _l10n[locale.languageCode]['noName'];
  get nomenclature => _l10n[locale.languageCode]['nomenclature'];
  get nomenclatures => _l10n[locale.languageCode]['nomenclatures'];
  get permissionDenied => _l10n[locale.languageCode]['permissionDenied'];
  get product => _l10n[locale.languageCode]['product'];
  get products => _l10n[locale.languageCode]['products'];
  get to => _l10n[locale.languageCode]['to'];
  get uniqueCategory => _l10n[locale.languageCode]['uniqueCategory'];
  get uniqueGroup => _l10n[locale.languageCode]['uniqueGroup'];
  get uniqueNomenclature => _l10n[locale.languageCode]['uniqueNomenclature'];
  get uniqueProduct => _l10n[locale.languageCode]['uniqueProduct'];
  get withoutCategory => _l10n[locale.languageCode]['withoutCategory'];
  get withoutTime => _l10n[locale.languageCode]['withoutTime'];
}

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => ['ru'].contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(L10n(locale));
  }

  @override
  bool shouldReload(L10nDelegate old) => false;
}
