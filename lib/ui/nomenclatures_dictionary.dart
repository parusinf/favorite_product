import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/nomenclature_edit.dart';

/// Словарь
class NomenclaturesDictionary extends StatefulWidget {
  const NomenclaturesDictionary({Key key}): super(key: key);
  @override
  _NomenclaturesDictionaryState createState() => _NomenclaturesDictionaryState();
}

class _NomenclaturesDictionaryState extends State<NomenclaturesDictionary> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _searchQueryEdit = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryEdit.clear();
      updateSearchQuery('');
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = Platform.isIOS
        ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          Text(_l10n.nomenclatures),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryEdit,
      autofocus: true,
      decoration: InputDecoration(
        hintText: _l10n.nomenclature,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  List<Widget> _buildActions() {
    return <Widget>[
      if (_isSearching)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryEdit == null || _searchQueryEdit.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      if (!_isSearching)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => addNomenclature(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: _isSearching ? const BackButton() : null,
      title: _isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding1),
        child: StreamBuilder<List<NomenclatureView>>(
            stream: _db.nomenclaturesDao.watch(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data.where((nomenclature) => nomenclature.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())).toList();
                if (list.length > 0) {
                  return ListView.builder(
                    itemBuilder: (context, index) => _NomenclatureCard(list, index, _isSearching),
                    itemCount: list.length,
                  );
                } else {
                  return centerButton(_l10n.addNomenclature, onPressed: () => addNomenclature(context));
                }
              } else {
                return centerMessage(context, L10n.of(context).dataLoading);
              }
            }
        ),
      ),
    ),
  );
}

/// Карточка номенклатуры
class _NomenclatureCard extends StatelessWidget {
  final List<NomenclatureView> _nomenclatures;
  final int _index;
  final NomenclatureView _nomenclature;
  final _isSearching;

  _NomenclatureCard(this._nomenclatures, this._index, this._isSearching) : _nomenclature = _nomenclatures[_index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding3),
    child: Dismissible(
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        _nomenclatures.removeAt(_index);
        Provider.of<Db>(context, listen: false).nomenclaturesDao.delete2(_nomenclature);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () {
            if (_isSearching) {
              Navigator.pop(context);
            }
            Navigator.pop(context, _nomenclature);
          },
          onDoubleTap: () => editNomenclature(context, _nomenclature),
          child: ListTile(
            title: Text(_nomenclature.name),
            subtitle: Text('${_nomenclature.category?.name ?? L10n.of(context).withoutCategory} '
                'x${_nomenclature.count}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editNomenclature(context, _nomenclature),
            ),
          ),
        ),
      ),
    ),
  );
}