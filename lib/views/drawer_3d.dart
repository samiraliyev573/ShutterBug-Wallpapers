import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperApp/views/home.dart';
import 'package:wallpaperApp/widgets/brand_widget.dart';

class Drawer3D extends StatefulWidget {
  @override
  _Drawer3DState createState() => _Drawer3DState();
}

class _Drawer3DState extends State<Drawer3D>
    with SingleTickerProviderStateMixin {
  var _maxSlide;
  var _extraHeight;
  double _startingPos;
  var _drawerVisible;
  AnimationController _animationController;
  Size _screen;
  CurvedAnimation _animator;

  @override
  void initState() {
    super.initState();
    _maxSlide = 0.75;
    _extraHeight = 0.1;
    _drawerVisible = false;
    _screen = Size(0, 0);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animator = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
      reverseCurve: Curves.easeInQuad,
    );
  }

  @override
  void didChangeDependencies() {
    _screen = MediaQuery.of(context).size;
    _maxSlide *= _screen.width;
    _extraHeight *= _screen.height;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _drawerVisible = false;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111f4d),
      body: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            //Space color - it also makes the empty space touchable
            //Container(color: Color(0xFFFFFFF)),
            _buildHomePage(),
            _buildDrawer(),
            //_buildHeader(),
          ],
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    _startingPos = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final globalDelta = details.globalPosition.dx - _startingPos;
    if (globalDelta > 0) {
      final pos = globalDelta / _screen.width;
      if (_drawerVisible && pos <= 1.0) return;
      _animationController.value = pos;
    } else {
      final pos = 1 - (globalDelta.abs() / _screen.width);
      if (!_drawerVisible && pos >= 0.0) return;
      _animationController.value = pos;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx.abs() > 500) {
      if (details.velocity.pixelsPerSecond.dx > 0) {
        _animationController.forward(from: _animationController.value);
        _drawerVisible = true;
      } else {
        _animationController.reverse(from: _animationController.value);
        _drawerVisible = false;
      }
      return;
    }
    if (_animationController.value > 0.5) {
      {
        _animationController.forward(from: _animationController.value);
        _drawerVisible = true;
      }
    } else {
      {
        _animationController.reverse(from: _animationController.value);
        _drawerVisible = false;
      }
    }
  }

  void _toggleDrawer() {
    if (_animationController.value < 0.5)
      _animationController.forward();
    else
      _animationController.reverse();
  }

  Widget _buildMenuItem(String s, String route, Icon icon) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 8.0), child: icon),
          Text(
            s,
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFFf2f4f7),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Positioned.fill(
      top: -_extraHeight,
      bottom: -_extraHeight,
      left: 0,
      right: _screen.width - _maxSlide,
      child: AnimatedBuilder(
        animation: _animator,
        builder: (context, widget) {
          return Transform.translate(
            offset: Offset(_maxSlide * (_animator.value - 1), 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * (1 - _animator.value) / 2),
              alignment: Alignment.centerRight,
              child: widget,
            ),
          );
        },
        child: Container(
          color: Color(0xCCe43a19),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: _toggleDrawer,
                    color: Colors.black,
                    iconSize: 30,
                  ),
                ),
                Image.asset(
                  'assets/camerahighres.png',
                  width: 200,
                  height: 200,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildMenuItem(
                      "Home",
                      '/',
                      Icon(
                        FontAwesomeIcons.home,
                        color: Colors.white,
                      ),
                    ),
                    _buildMenuItem(
                        "Categories",
                        '/categories',
                        Icon(
                          Icons.category,
                          color: Colors.white,
                        )),
                    _buildMenuItem(
                      "Explore Artists",
                      '/explore',
                      Icon(
                        FontAwesomeIcons.userFriends,
                        color: Colors.white,
                      ),
                    ),
                    _buildMenuItem(
                      "FeedBack",
                      '/feedback',
                      Icon(
                        Icons.feedback,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return AnimatedBuilder(
      animation: _animator,
      builder: (context, widget) {
        return Transform.translate(
          offset: Offset(_maxSlide * _animator.value, 0),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(-pi * _animator.value / 2),
            alignment: Alignment.centerLeft,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: brandName(),
                centerTitle: true,
                elevation: 0.0,
                leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () => _animationController.forward()),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.question,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/homepage');
                      })
                ],
              ),
              body: Home(),
            ),
          ),
        );
      },
    );
  }
}
