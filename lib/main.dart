import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gallery/photo_gallery.dart';
import 'package:flutter_gallery/zip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_archive/flutter_archive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Medium> mediumList = [];
  List<Album> imageAlbums = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    imageAlbums = await Gallery().getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          imageAlbums.length != 0
              ? Container(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: imageAlbums.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: imageAlbums[index].name.runtimeType != Null
                                ? Text(imageAlbums[index].name!)
                                : Container(),
                            onTap: () async {
                              mediumList = await Gallery()
                                  .getListOfMedium(index, imageAlbums);
                              print(mediumList.length);
                              Zip().changeFromMediumToFile(mediumList);
                              setState(() {});
                            },
                          ),
                        );
                      }),
                )
              : Container(),
          mediumList.length != 0
              ? Container(
                  height: 500,
                  width: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: mediumList.length,
                      itemBuilder: (context, index) {
                        return FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: ThumbnailProvider(
                            mediumId: mediumList[index].id,
                            mediumType: MediumType.image,
                            highQuality: true,
                          ),
                        );
                      }),
                )
              : Container(),
        ],
      ),
    );
  }
}
