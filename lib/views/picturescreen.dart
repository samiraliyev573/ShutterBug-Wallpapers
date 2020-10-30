import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_it/share_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wallpaperApp/widgets/loader.dart';
import 'package:path/path.dart' show join;

class FullScreenImagePage extends StatefulWidget {
  final String imgPath;
  final String hdimgPath;
  final String artistName;

  FullScreenImagePage(this.imgPath, this.artistName, this.hdimgPath);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [Color(0x10000000), Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  static const platform =
      const MethodChannel("pinhole.wallpaper.wallpaperApp/wallpaper");
  bool _active = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ModalProgressHUD(
        inAsyncCall: _active,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Flex(direction: Axis.vertical, children: <Widget>[
                Expanded(
                  child: Container(
                    child: Hero(
                      tag: widget.imgPath,
                      child: Image.network(
                        widget.imgPath,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : Center(child: Loader());
                        },
                      ),
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120.0,
                  decoration: new BoxDecoration(
                    color: Color(0xAAff971d),
                    boxShadow: [
                      new BoxShadow(color: Colors.transparent, blurRadius: 10.0)
                    ],
                    borderRadius: new BorderRadius.vertical(
                        top: new Radius.elliptical(
                            MediaQuery.of(context).size.width, 100.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            }),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Made by ${widget.artistName}',
                              style: TextStyle(color: Colors.white),
                            ),
                            FlatButton(
                              color: Color(0xFFff971d),
                              onPressed: () {
                                if (Platform.isIOS) {
                                  Fluttertoast.showToast(
                                      msg: "Image saved to gallery",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                  _save();
                                } else if (Platform.isAndroid) {
                                  setWallpaperDialog();
                                } else {
                                  print('Different os');
                                }
                              },
                              child: Text('Set as Wallpaper',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                        InkWell(
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(FontAwesomeIcons.share),
                              onPressed: () async {
                                await _shareImage();
                                setState(() {
                                  _active = false;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                        color: Colors.black,
                        iconSize: 40,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _shareImage() async {
    try {
      print('Before setstate');
      setState(() {
        _active = true;
      });
      print('After _active on');
      await _askPermission();
      //  var response = await Dio().get(widget.imgPath,
      //      options: Options(responseType: ResponseType.bytes));
      //  print(response);
      //  print(response.data);
      //var file1 = await DefaultCacheManager().downloadFile(widget.hdimgPath);
      //var file = await DefaultCacheManager().getSingleFile(widget.hdimgPath);
      // final result =
      //     await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      // final ByteData bytes = await rootBundle.load(result);
      ShareIt.file(path: await _imageBundlePath, type: ShareItFileType.image);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<String> get _imageBundlePath async {
    var file = await DefaultCacheManager().getSingleFile(widget.hdimgPath);
    return _fileFromBundle(name: file.path);
  }

  Future<String> _fileFromBundle({@required String name}) async {
    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    final filePath = join(directory.path, name);
    final bundleData = await rootBundle.load('$name');
    List<int> bytes = bundleData.buffer
        .asUint8List(bundleData.offsetInBytes, bundleData.lengthInBytes);
    final file = await File(filePath).writeAsBytes(bytes);
    return file.path;
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(widget.hdimgPath,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */ await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }

  void setWallpaperDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Set a wallpaper',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onTap: () async {
                  await _setWallpaper(1);
                  setState(() {
                    _active = false;
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Lock Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                onTap: () {
                  _setWallpaper(2);
                },
              ),
              ListTile(
                title: Text(
                  'Both',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.phone_android,
                  color: Colors.black,
                ),
                onTap: () {
                  _setWallpaper(3);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setWallpaper(int wallpaperType) async {
    var file = await DefaultCacheManager().getSingleFile(widget.hdimgPath);
    setState(() {
      _active = true;
    });
    try {
      final int result = await platform
          .invokeMethod('setWallpaper', [file.path, wallpaperType]);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }

    Fluttertoast.showToast(
        msg: "Wallpaper set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}
