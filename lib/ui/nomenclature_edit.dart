import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/categories_dictionary.dart';

/// Добавление
Future addNomenclature(BuildContext context) async =>
    push(context, NomenclatureEdit(null));

/// Исправление
Future editNomenclature(BuildContext context, NomenclatureView nomenclature) async =>
    push(context, NomenclatureEdit(nomenclature));

/// Форма редактирования
class NomenclatureEdit extends StatefulWidget {
  final NomenclatureView nomenclature;
  final DataActionType actionType;
  const NomenclatureEdit(this.nomenclature, {Key key})
      : this.actionType = nomenclature == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _NomenclatureEditState createState() => _NomenclatureEditState();
}

/// Состояние формы редактирования
class _NomenclatureEditState extends State<NomenclatureEdit> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _categoryEdit = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;
  Category _category;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.nomenclature?.name;
    _categoryEdit.text = widget.nomenclature?.category?.name;
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _categoryEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(_l10n.nomenclature),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
      ],
    ),
    body: Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              divider(height: padding3),
              // Наименование
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.cake),
                  labelText: _l10n.name,
                ),
                validator: _validateName,
              ),
              divider(),
              // Категория
              TextFormField(
                controller: _categoryEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.category),
                  labelText: _l10n.category,
                ),
                onTap: () => _selectCategory(context),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Выбор категории из словаря
  Future _selectCategory(BuildContext context) async {
    _category = await push(context, CategoriesDictionary());
    _categoryEdit.text = _category?.name ?? _categoryEdit.text;
  }

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await _db.nomenclaturesDao.insert2(
              name: _nameEdit.text,
              categoryId: _category?.id,
            );
            break;
          case DataActionType.Update:
            await _db.nomenclaturesDao.update2(Nomenclature(
              id: widget.nomenclature.id,
              name: _nameEdit.text,
              categoryId: _category?.id,
            ));
            break;
          case DataActionType.Delete: break;
        }
        Navigator.of(context).pop();
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (isEmpty(value)) {
      return _l10n.noName;
    }
    return null;
  }
}