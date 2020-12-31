import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';

/// Добавление
Future addCategory(BuildContext context) async =>
    push(context, CategoryEdit(null));

/// Исправление
Future editCategory(BuildContext context, CategoryView category) async =>
    push(context, CategoryEdit(category));

/// Форма редактирования
class CategoryEdit extends StatefulWidget {
  final CategoryView category;
  final DataActionType actionType;
  const CategoryEdit(this.category, {Key key})
      : this.actionType = category == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _CategoryEditState createState() => _CategoryEditState();
}

/// Состояние формы редактирования
class _CategoryEditState extends State<CategoryEdit> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.category?.name;
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(_l10n.category),
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
                  icon: const Icon(Icons.category),
                  labelText: _l10n.name,
                ),
                validator: _validateName,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await _db.categoriesDao.insert2(
              name: _nameEdit.text,
            );
            break;
          case DataActionType.Update:
            await _db.categoriesDao.update2(Category(
              id: widget.category.id,
              name: _nameEdit.text,
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