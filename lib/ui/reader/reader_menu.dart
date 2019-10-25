import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ice_book/main.dart';
import 'package:ice_book/ui/reader/reader_bloc.dart';

class ReaderMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReaderMenuState();
  }
}

class _ReaderMenuState extends State<ReaderMenu>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ReaderBloc _readerBloc;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    _readerBloc = BlocProvider.of<ReaderBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: -1, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _readerBloc,
      child: BlocProvider.value(
        value: _themeBloc,
        child: BlocBuilder<ThemeBloc, ThemeData>(
          bloc: _themeBloc,
          builder: (context, theme) {
            return BlocBuilder<ReaderBloc, ReaderState>(
                bloc: _readerBloc,
                builder: (context, state) {
                  return Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          controller.reverse();
                          Timer(Duration(milliseconds: 200), () {
                            _readerBloc.dispatch(MenuEvent());
                          });
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: animation.value * 80,
                        child: _addTopMenu(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: animation.value * 140,
                        child: _addBottomMenu(),
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  Widget _addTopMenu() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
          color: Theme.of(context).dialogBackgroundColor,
//          borderRadius: BorderRadius.only(
//              bottomLeft: Radius.circular(10),
//              bottomRight: Radius.circular(10))
      ),
      height: 80,
      child: Material(
        child: SafeArea(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _addBottomMenu() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
          color: Theme.of(context).dialogBackgroundColor,
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(10), topRight: Radius.circular(10))
      ),
      height: 140,
      child: Material(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(_readerBloc.currentState.currentArticle.title)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.reorder),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.font_download),
                    onPressed: () {
                      _readerBloc.dispatch(FontEvent(_readerBloc.currentState.fontSize + 1));
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Theme.of(context).brightness == Brightness.dark
                        ? Icons.brightness_5
                        : Icons.brightness_3),
                    onPressed: () {
                      _themeBloc.dispatch(ThemeEvent.toggle);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
