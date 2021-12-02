import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter/cupertino.dart';

enum SetWallpaperAs { Home, Lock, Both }
const _setAs = {
  SetWallpaperAs.Home: WallpaperManager.HOME_SCREEN,
  SetWallpaperAs.Lock: WallpaperManager.LOCK_SCREEN,
  SetWallpaperAs.Both: WallpaperManager.BOTH_SCREENS,
};

Future<void> checkWallpaper({BuildContext context, String url}) async {
  SetWallpaperAs option;

  var actionSheet = CupertinoActionSheet(
      title: Text('Set Wallpaper As', style: TextStyle(fontSize: 17)),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              option = SetWallpaperAs.Home;
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Home Screen', style: TextStyle(fontSize: 15))),
        CupertinoActionSheetAction(
            onPressed: () {
              option = SetWallpaperAs.Lock;
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Lock Screen', style: TextStyle(fontSize: 15))),
        CupertinoActionSheetAction(
            onPressed: () {
              option = SetWallpaperAs.Both;
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Both', style: TextStyle(fontSize: 15))),
      ]);

  await showCupertinoModalPopup(
      context: context, builder: (context) => actionSheet);
  Navigator.pop(context);

  String result;

  print(option);
  if (option != null) {
    var fileUrl = await DefaultCacheManager().getSingleFile(url);
    print(fileUrl);
    if (fileUrl != null) {
      try {
        result = await WallpaperManager.setWallpaperFromFile(
            fileUrl.path, _setAs[option]);
      } on PlatformException {
        result = 'Failed to get wallpaper';
      }

      if (result != null) {
        debugPrint(result);
      }
    }
  }
}
