import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/nomenclatures_dictionary.dart';

/// Добавление
Future addProduct(BuildContext context) async =>
    push(context, ProductEdit(null));

/// Исправление
Future editProduct(BuildContext context, ProductView product) async =>
    push(context, ProductEdit(product));

/// Форма редактирования
class ProductEdit extends StatefulWidget {
  final ProductView product;
  final DataActionType actionType;
  const ProductEdit(this.product, {Key key})
      : this.actionType = product == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _ProductEditState createState() => _ProductEditState();
}

/// Состояние формы редактирования
class _ProductEditState extends State<ProductEdit> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nomenclatureEdit = TextEditingController();
  final _costEdit = TextEditingController();
  final _dateEdit = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;
  Nomenclature _nomenclature;

  @override
  void initState() {
    super.initState();
    _nomenclature = widget.product?.nomenclature;
    _nomenclatureEdit.text = widget.product?.nomenclature?.name;
    _costEdit.text = doubleToString(widget.product?.cost, thousandSeparator: false);
    _dateEdit.text = dateToString(widget.product?.date ?? today());
  }

  @override
  void dispose() {
    _nomenclatureEdit.dispose();
    _costEdit.dispose();
    _dateEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(_l10n.product),
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
              // Номенклатура
              TextFormField(
                controller: _nomenclatureEdit,
                readOnly: true,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.adjust),
                  labelText: _l10n.nomenclature,
                ),
                validator: _validateName,
                onTap: () => _selectNomenclature(context),
              ),
              divider(),
              // Сумма
              TextFormField(
                controller: _costEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.account_balance_wallet),
                  labelText: _l10n.cost,
                ),
                validator: _validateCost,
              ),
              divider(),
              // Дата
              TextFormField(
                controller: _dateEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: _l10n.date,
                ),
                validator: _validateDate,
                inputFormatters: DateFormatters.formatters,
                maxLength: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Выбор номенклатуры из словаря
  Future _selectNomenclature(BuildContext context) async {
    _nomenclature = await push(context, NomenclaturesDictionary());
    _nomenclatureEdit.text = _nomenclature?.name ?? _nomenclatureEdit.text;
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
            await _db.productsDao.insert2(
              groupId: _db.activeGroupStream.value.id,
              nomenclatureId: _nomenclature?.id,
              cost: stringToDouble(_costEdit.text),
              date: stringToDate(_dateEdit.text),
            );
            break;
          case DataActionType.Update:
            await _db.productsDao.update2(Product(
              id: widget.product.id,
              groupId: widget.product.groupId,
              nomenclatureId: _nomenclature?.id,
              cost: stringToDouble(_costEdit.text),
              date: stringToDate(_dateEdit.text),
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

  /// Проверка суммы
  String _validateCost(String value) {
    final cost = stringToDouble(value);
    if (cost == null || cost <= 0.0) {
      return _l10n.noCost;
    }
    return null;
  }

  /// Проверка даты
  String _validateDate(String value) {
    if (value.isEmpty || stringToDate(value) == null) {
      return _l10n.invalidDate;
    }
    return null;
  }
}