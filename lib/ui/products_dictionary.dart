import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/product_edit.dart';
import 'package:favorite_product/core/load_products.dart';
import 'package:favorite_product/core/unload_products.dart';

/// Словарь продуктов в группе
class ProductsDictionary extends StatefulWidget {
  const ProductsDictionary({Key key}): super(key: key);
  @override
  _ProductsDictionaryState createState() => _ProductsDictionaryState();
}

class _ProductsDictionaryState extends State<ProductsDictionary> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchQueryEdit = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
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
          Text(_l10n.products),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryEdit,
      autofocus: true,
      decoration: InputDecoration(
        hintText: _l10n.product,
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
      StreamBuilder<List<Product>>(
          stream: _db.productsStream,
          builder: (context, snapshot) {
            if (_db.activeGroupStream.value != null && snapshot.hasData) {
              return IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: _unloadProducts,
              );
            } else {
              return Text('');
            }
          }
      ),
      IconButton(
        icon: Icon(Icons.file_download),
        onPressed: _loadProductsFromFile,
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => addProduct(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      leading: _isSearching ? const BackButton() : null,
      title: _isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding1),
        child: StreamBuilder<List<ProductView>>(
          stream: _db.productsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final list = snapshot.data.where((product) => product.nomenclature.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase())).toList();
              if (list.length > 0) {
                return ListView.builder(
                  itemBuilder: (context, index) => _ProductCard(list, index),
                  itemCount: list.length,
                );
              } else {
                return centerButton(_l10n.addProduct, onPressed: () => addProduct(context));
              }
            } else {
              return centerMessage(context, L10n.of(context).dataLoading);
            }
          }
        ),
      ),
    ),
  );

  /// Выгрузка продуктов в CSV файл
  Future _unloadProducts() async {
    try {
      await unloadProducts(context);
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Загрузка продуктов из CSV файла
  Future _loadProductsFromFile({String fileName}) async {
    try {
      if (fileName == null) {
        await chooseAndLoadProducts(context);
      } else {
        await loadProducts(context, fileName);
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}

/// Карточка продукта
class _ProductCard extends StatelessWidget {
  final List<ProductView> _products;
  final int _index;
  final ProductView _product;
  
  _ProductCard(this._products, this._index) : _product = _products[_index];

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
        _products.removeAt(_index);
        Provider.of<Db>(context, listen: false).productsDao.delete2(_product);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () => editProduct(context, _product),
          onDoubleTap: () => editProduct(context, _product),
          child: ListTile(
            title: Text(_product.nomenclature.name),
            subtitle: Text('${doubleToString(_product.cost)} $RUBLE_SIGN '
                '${dateToString(_product.date)}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editProduct(context, _product),
            ),
          ),
        ),
      ),
    ),
  );
}