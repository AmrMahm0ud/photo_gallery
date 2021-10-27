import 'package:photo_gallery/photo_gallery.dart';

class Gallery {
  List<Album> albumList = [];
  List<Medium> mediumList = [];

  Future<List<Album>> getAlbums() async {
    albumList = await PhotoGallery.listAlbums(mediumType: MediumType.image);
    return albumList;
  }

  Future<List<Medium>> getListOfMedium(int index, List<Album> albumList) async {
    final MediaPage imagePage = await albumList[index].listMedia(
      newest: true,
    );
    mediumList = [
      ...imagePage.items,
    ];
    return mediumList;
  }
}
