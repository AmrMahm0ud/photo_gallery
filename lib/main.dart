import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
  List<Medium> allMedia = [];
  List<Album> imageAlbums = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await getAlbums();
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
                            onTap: () {
                              onPressButton(index);
                            },
                          ),
                        );
                      }),
                )
              : Container(),
          allMedia.length != 0
              ? Container(
                  height: 500,
                  width: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allMedia.length,
                      itemBuilder: (context, index) {
                        return FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: ThumbnailProvider(
                            mediumId: allMedia[index].id,
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

  getAlbums() async {
    imageAlbums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
    imageAlbums.forEach((element) {
      print(element.name.runtimeType);
    });
  }

  Future<List<Medium>> onPressButton(int index) async {
    allMedia = [];
    final MediaPage imagePage = await imageAlbums[index].listMedia(
      newest: true,
    );
    allMedia = [
      ...imagePage.items,
    ];
    setState(() {
      allMedia;
    });
    return allMedia;
  }
}
