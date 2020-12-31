import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';

/// Добавление группы
Future addGroup(BuildContext context) async {
  await push(context, GroupEdit(null));
}

/// Исправление группы
Future editGroup(BuildContext context, GroupView groupView) async =>
  await push(context, GroupEdit(groupView));

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  final DataActionType actionType;
  const GroupEdit(this.groupView, {Key key})
      : this.actionType = groupView == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _GroupEditState createState() => _GroupEditState();
}

/// Состояние формы редактирования группы
class _GroupEditState extends State<GroupEdit> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name;
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
      title: Text(_l10n.group),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
      ],
    ),
    body: Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            divider(height: padding3),
            // Наименование группы
            TextFormField(
              controller: _nameEdit,
              autofocus: widget.actionType == DataActionType.Insert ? true : false,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                icon: const Icon(Icons.fastfood),
                labelText: _l10n.name,
              ),
              validator: _validateName,
            ),
          ],
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
            final group = await _db.groupsDainsert2(
              name: trim(_nameEdit.text),
            );
            Navigator.of(context).pop(group);
            break;
          case DataActionType.Update:
            await _db.groupsDao.update2(Group(
              id: widget.groupView.id,
              name: trim(_nameEdit.text),
            ));
            Navigator.of(context).pop();
            break;
          case DataActionType.Delete: break;
        }
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