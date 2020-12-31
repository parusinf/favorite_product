import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/group_edit.dart';
import 'package:favorite_product/ui/help_page.dart';
import 'package:favorite_product/ui/products_dictionary.dart';

/// Дроувер домашнего экрана
class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key}) : super(key: key);
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

/// Состояние дроувера домашнего экрана
class _HomeDrawerState extends State<HomeDrawer> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) => Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Список групп
              listHeater(context, Icons.account_tree, _l10n.groups,
                  onAddPressed: () async {
                    await addGroup(context);
                    Navigator.pop(context);
                  }
              ),
              Flexible(
                child: StreamBuilder<List<GroupWithActiveSing>>(
                  stream: _db.groupsStream,
                  builder: (context, snapshot) =>
                      ListView.builder(
                        itemBuilder: (context, index) => _GroupCard(snapshot.data, index),
                        itemCount: snapshot.data?.length ?? 0,
                      ),
                ),
              ),
              Spacer(),
              listHeater(context, Icons.help, _l10n.help,
                  onHeaderTap: () => push(context, HelpPage())),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Карточка группы
class _GroupCard extends StatelessWidget {
  final List<GroupWithActiveSing> _groups;
  final int _index;
  final GroupWithActiveSing _group;
  
  _GroupCard(this._groups, this._index) : _group = _groups[_index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding3),
    child: Dismissible(
      confirmDismiss: (direction) async => _group.groupView.cost == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        _groups.removeAt(_index);
        Provider.of<Db>(context, listen: false).groupsDao.delete2(_group.groupView);
      },
      child: Material(
        color: _group.isActive
            ? Colors.lightGreen.withOpacity(activeColorOpacity)
            : Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () {
            Provider.of<Db>(context, listen: false).settingsDao.setActiveGroup(_group.groupView);
            Navigator.pop(context);
          },
          onDoubleTap: () async {
            await editGroup(context, _group.groupView);
            Navigator.pop(context);
          },
          child: ListTile(
            title: Text(_group.groupView.name),
            subtitle: _group.groupView.cost != 0 ? Text('${doubleToString(_group.groupView.cost)} $RUBLE_SIGN') : null,
            trailing: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () async {
                Navigator.pop(context);
                await push(context, ProductsDictionary());
              },
            ),
          ),
        ),
      ),
    ),
  );
}