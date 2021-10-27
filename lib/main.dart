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
//
// final appDataDir = Directory.systemTemp;
// final dataFilesBaseDirectoryName = "store";

// List<File> fileList = [];
// Directory DirName = await createFolderInAppDocDir("imageTestDir");
// for (int i = 0; i < allMedia.length; i++) {
// File file = await getFile(allMedia[i]);
// fileList.add(file);
// }
//
// for (int i = 0; i < fileList.length; i++) {
// File file =
// await fileList[i].copy("${DirName.path}/${allMedia[i].filename}");
// print(file.absolute);
// //   file.createSync(recursive: false);
// }
//
// final sourceDir = Directory(DirName.path);
// int counter = 0;
// fileList.forEach((element) {
// print(element.lengthSync());
// counter += element.lengthSync();
// });
// print("lenght before zip  ${counter / (1024 * 1024)}");
// // File file = File("$sourceDir/test_zip_dir.zip");
// final Directory? dir = await getExternalStorageDirectory();
// File file = File("${dir!.path}/zip_file.zip");
// print(sourceDir);
// try {
// await ZipFile.createFromDirectory(
// sourceDir: sourceDir,
// zipFile: file,
// includeBaseDirectory: true,
// onZipping: (fileName, isDirectory, progress) {
// print('Zip #1:');
// print('progress: ${progress.toStringAsFixed(1)}%');
// print('name: $fileName');
// print('isDirectory: $isDirectory');
// return ZipFileOperation.includeItem;
// });
// print(" File Size after zip ${file.lengthSync() / (1024 * 1024)}");
// } catch (e) {
// print(e);
// }
//
// Future<Directory> createFolderInAppDocDir(String folderName) async {
//   final Directory? _appDocDir = await getExternalStorageDirectory();
//   print(_appDocDir);
//   // final Directory _appDocDirFolder = Directory('/$_appDocDir/$folderName');
//   // _appDocDirFolder.list()
//
//   // if (await _appDocDirFolder.exists()) {
//   //   //if folder already exists return path
//   //   return _appDocDirFolder;
//   // } else {
//   //if folder not exists create folder and then return its path+
//
//   Directory directory = await Directory(_appDocDir!.path + '/' + folderName)
//       .create(recursive: true);
//   // The created directory is returned as a Future.
//   print('Path of New Dir: ' + directory.path);
//   // }
//   return directory;
// }
//
// getFile(Medium medium) async {
//   return await PhotoGallery.getFile(mediumId: medium.id);
// }
}
