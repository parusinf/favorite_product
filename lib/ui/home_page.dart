import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:favorite_product/core/load_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_product/core.dart';
import 'package:favorite_product/ui/home_drawer.dart';
import 'package:favorite_product/ui/group_edit.dart';
import 'package:favorite_product/ui/products_dictionary.dart';
import 'package:favorite_product/ui/product_edit.dart';
import 'package:favorite_product/ui/help_page.dart';

/// Домашная страница
class HomePage extends StatefulWidget {
  const HomePage({Key key}): super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

/// Состояние домашней страницы
class _HomePageState extends State<HomePage> {
  get _db => Provider.of<Db>(context, listen: false);
  get _l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _grouping = 0;
  StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();

    // Для обмена или открытия URL-адресов/текста, поступающих извне приложения, пока приложение находится в памяти
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          _loadProductsFromContent(content: value);
        }, onError: (err) {
          print("getLinkStream error: $err");
        });

    // Для обмена или открытия URL-адресов/текста, поступающих извне приложения, когда приложение закрыто
    // Отложенная загрузка переданного контента
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        ReceiveSharingIntent.getInitialText().then((String value) {
          _loadProductsFromContent(content: value);
        });
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  /// Загрузка продуктов из переданного контента
  Future _loadProductsFromContent({String content}) async {
    try {
      if (content != null) {
        if (content.contains('content://')) {
          final uri = Uri.parse(content);
          await loadProducts(context, uriToString(uri));
        } else {
          parseProducts(context, content);
        }
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: _db.activeGroupStream,
        builder: (context, snapshot) => snapshot.hasData
          ? InkWell(
              onTap: () async {
                await push(context, ProductsDictionary());
              },
              child: text(snapshot.data.name),
            )
          : InkWell(
              onTap: () => push(context, HelpPage()),
              child: text(_l10n.favoriteProduct),
            ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () => addProduct(context),
        ),
      ],
    ),
    drawer: HomeDrawer(),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding3),
        child: StreamBuilder<List<ProductView>>(
          stream: _grouping == 0
              ? _db.productsByNomenclaturesStream
              : _grouping == 1
              ? _db.productsByWordsStream
              : _db.productsByCategoriesStream,
          builder: (context, snapshot) {
            // Добавить группу
            if (_db.activeGroupStream.value == null) {
              return centerButton(_l10n.addGroup, onPressed: () => addGroup(context));
            } else {
              // Продукты группы загрузились
              if (snapshot.hasData) {
                final list = snapshot.data;
                if (list.length > 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      divider(height: padding3),
                      // Группировка
                      formElement(
                        context,
                        Icons.account_tree,
                        Wrap(
                          children: [
                            ChoiceChip(
                              label: Text(groupingName(context, 0)),
                              selected: _grouping == 0,
                              onSelected: (value) {
                                setState(() {
                                  _grouping = value ? 0 : -1;
                                });
                              },
                            ),
                            const SizedBox(width: padding3),
                            ChoiceChip(
                              label: Text(groupingName(context, 1)),
                              selected: _grouping == 1,
                              onSelected: (value) {
                                setState(() {
                                  _grouping = value ? 1 : -1;
                                });
                              },
                            ),
                            const SizedBox(width: padding3),
                            ChoiceChip(
                              label: Text(groupingName(context, 2)),
                              selected: _grouping == 2,
                              onSelected: (value) {
                                setState(() {
                                  _grouping = value ? 2 : -1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      divider(height: padding3),
                      // Рейтинг
                      Flexible(
                        child: ListView.builder(
                          itemBuilder: (context, index) => _Card(list[index], index),
                          itemCount: list.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return centerButton(_l10n.addProduct, onPressed: () => addProduct(context));
                }
              } else {
                return centerMessage(context, _l10n.dataLoading);
              }
            }
          }
        ),
      ),
    ),
  );
}

/// Карточка
class _Card extends StatelessWidget {
  final ProductView _product;
  final int _index;

  _Card(this._product, this._index);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding3),
    child: Material(
      color: Colors.lightGreen.withOpacity(passiveColorOpacity),
      borderRadius: BorderRadius.circular(borderRadius),
      child: ListTile(
        title: Text('${(_index + 1).toString()}. '
            '${_product.nomenclature.name ?? L10n.of(context).withoutCategory}'),
        subtitle: Text('x${_product.count.toString()}'),
        trailing: Text('${doubleToString(_product.cost)} $RUBLE_SIGN'),
      ),
    ),
  );
}