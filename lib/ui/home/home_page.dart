import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ice_book/main.dart';
import 'package:ice_book/ui/bookrack/bookrack_page.dart';
import 'package:ice_book/ui/find/find_page.dart';
import 'package:ice_book/ui/search/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  TabController _tabController;
  final List<Tab> _tabs = <Tab>[
    Tab(text: "书架"),
    Tab(text: "发现"),
  ];
  int tabIndex = 0;
  var _pageList = [new BookRackPage(), new FindPage()];
  ThemeBloc _themeBloc;

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      builder: (context) => _themeBloc,
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _globalKey.currentState.openDrawer();
            },
          ),
          title: _addTabBar(),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        drawer: _addDraw(),
        body: TabBarView(
          children: _pageList,
          controller: _tabController,
        ),
      ),
    );
  }

  Widget _addDraw() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("李博雅"),
            accountEmail: Text("245558516@qq.com"),
            currentAccountPicture: ClipOval(
              child: Image.asset("assets/images/ic_logo.png"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text("Item 1"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.thumb_up),
            title: Text("Item 2"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.brightness_5
                : Icons.brightness_3),
            title: Text(Theme.of(context).brightness == Brightness.dark
                ? "日间模式"
                : "夜间模式"),
            onTap: () {
              _themeBloc.dispatch(ThemeEvent.toggle);
//              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _addTabBar() {
    return Container(
      width: 150,
      child: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: _tabs,
            labelStyle:Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
          labelColor: Theme.of(context).selectedRowColor,
          unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
          indicatorColor: Theme.of(context).selectedRowColor,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
