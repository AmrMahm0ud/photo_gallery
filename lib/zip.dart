import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/photo_gallery.dart';

class Zip {
  List<File> filesList = [];
  List<Medium> _mediumList = [];

  Future<List<File>> changeFromMediumToFile(List<Medium> mediumList) async {
    File file;
    _mediumList = mediumList;
    for (int i = 0; i < _mediumList.length; i++) {
      file = await getFile(_mediumList[i]);
      filesList.add(file);
    }
    await createFolderInAppDocDir("image_folder");
    return filesList;
  }

  Future<File> getFile(Medium medium) async {
    return await PhotoGallery.getFile(mediumId: medium.id);
  }

  Future<Directory> createFolderInAppDocDir(String folderName) async {
    final Directory? _appDocDir = await getExternalStorageDirectory();
    Directory directory = await Directory(_appDocDir!.path + '/' + folderName)
        .create(recursive: false);
    await createCopyOfFilesToRootDir(directory);
    return directory;
  }

  Future createCopyOfFilesToRootDir(Directory directory) async {
    final Directory? appDataDir = await getExternalStorageDirectory();
    for (int i = 0; i < filesList.length; i++) {
      File file = await filesList[i]
          .copy("${appDataDir!.path}/image_folder/${_mediumList[i].filename}");
      file.createSync(recursive: false);
    }
    int counter = 0;
    for (var element in filesList) {
      counter += element.lengthSync();
    }
    print("size before zipping ${counter / (1024 * 1024)}");
    await createZipFileFromDir(directory);
  }

  Future createZipFileFromDir(Directory directory) async {
    final Directory? dir = await getExternalStorageDirectory();
    File zipFile = File("${dir!.path}/zip_file.zip");
    print("directory Lenght ${directory.listSync()}");
    try {
      await ZipFile.createFromDirectory(
        sourceDir: directory,
        zipFile: zipFile,
        includeBaseDirectory: true,
        // onZipping: (fileName, isDirectory, progress) {
        //   print('Zip #1:');
        //   print('progress: ${progress.toStringAsFixed(1)}%');
        //   print('name: $fileName');
        //   print('isDirectory: $isDirectory');
        //   return ZipFileOperation.includeItem;
        // });
      );
      print(" File Size after zip ${zipFile.lengthSync() / (1024 * 1024)}");
    } catch (e) {
      print(e);
    }
    await zipFile.delete();
    filesList = [];
    _mediumList = [];
    Directory ddir = Directory(directory.path);
    await ddir.delete(recursive: true);
  }
}
