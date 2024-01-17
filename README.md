<p float="left">
  <img src="https://freelogopng.com/images/all_img/1684952459youtube-shorts-logo-png.png" width="170"/>
  <img style="margin: 0 0 -10px 0;" src="https://images.vexels.com/media/users/3/158039/isolated/preview/05331045aee2a8e5142775d30365b88e-handshake-silhouette-icon.png" width="80"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Dart_programming_language_logo.svg/1200px-Dart_programming_language_logo.svg.png" width="180" />
</p>

### ▶️ youtube_shorts: A package for displaying youtube shorts.
A vertical youtube shorts player. You can choose what shorts will be displayed by passing a list of shorts url's or by passing a channel name. Under the hood the package is using [youtube_explode_dart](https://pub.dev/packages/youtube_explode_dart) to get youtube video info and [media_kit](https://pub.dev/packages/media_kit) as the player for videos. 

### 🗂️ *Summary* 
- [⦿ Configurations and native permissions](#configurations-and-native-permissions) 
- [⦿ Basic how to use](#basic-how-to-use)
  - [By list of youtube url's](#by-list-of-youtube-urls-example)
  - [By channel name (example)](#by-channel-name-example) 
  - [Shorts page use (minimal example)](#shorts-page-use-minimal-example) 
- [⦿ Video manipulation](#video-manipulation)
  - [Controll the current/focussed player](#controll-the-currentfocussed-player)
  - [Set autoplay](#set-autoplay)
  - [Set if videos will be played in loop](#set-if-videos-will-be-played-in-loop)
- [⦿ Player manipulation](#)
  - [Disable/enable default controllers](#disableenable-default-controllers)
  - [Create a overlay above the player](#create-a-overlay-above-the-player)
  - [Set loading widget](#set-loading-widget)
  - [Set error widget](#set-error-widget)
  - [Video builder](#video-builder )
  
<br> 

# Configurations and native permissions
Since the package uses [media_kit](https://pub.dev/packages/media_kit) as it's video player engine, the native configurations of this package are the same configurations of media_kit package. Click here to access the [media_kit package native configuration](https://pub.dev/packages/media_kit#permissions). Please do the configurations for the platforms you pretend to use.

That configurations also includes calling `MediaKit.ensureInitialized();` in the main function. Please check [documentation](https://pub.dev/packages/media_kit#tldr).

After macking the configuration, use [`package:permission_handler`](https://pub.dev/packages/permission_handler) to request access at runtime:

```dart
if (/* Android 13 or higher. */) {
  // Video permissions.
  if (await Permission.videos.isDenied || await Permission.videos.isPermanentlyDenied) {
    final state = await Permission.videos.request();
    if (!state.isGranted) {
      await SystemNavigator.pop();
    }
  }
  // Audio permissions.
  if (await Permission.audio.isDenied || await Permission.audio.isPermanentlyDenied) {
    final state = await Permission.audio.request();
    if (!state.isGranted) {
      await SystemNavigator.pop();
    }
  }
} else {
  if (await Permission.storage.isDenied || await Permission.storage.isPermanentlyDenied) {
    final state = await Permission.storage.request();
    if (!state.isGranted) {
      await SystemNavigator.pop();
    }
  }
}
```

# Basic how to use
First, you will need to create a `VideosSourceController` that will controll all the video source. There are two constructor of the source controller. From a list of url or from the channel name. Examples are bellow:

### - By list of youtube url's (example): 
You can check a complete implementation of this constructor by [clicking here](https://github.com/igormidev/youtube_shorts/blob/master/example/lib/pages/shorts_by_video_url.dart). But bellow is a more short right to the point example:
```dart
late final ShortsController controller;

@override
void initState() {
  super.initState();
  controller = ShortsController(
    youtubeVideoInfoService: VideosSourceController.fromUrlList(
      videoIds: [
        'https://www.youtube.com/shorts/PiWJWfzVwjU',
        'https://www.youtube.com/shorts/AeZ3dmC676c',
        'https://www.youtube.com/shorts/L1lg_lxUxfw',
        'https://www.youtube.com/shorts/OWPsdhLHK7c',
        ...
      ],
    ),
  );
}
```

### - By channel name (example): 
You can check a complete implementation of this constructor by [clicking here](https://github.com/igormidev/youtube_shorts/blob/master/example/lib/pages/shorts_by_channel_name.dart). But bellow is a more short right to the point example:
```dart
late final ShortsController controller;

@override
void initState() {
  super.initState();
  controller = ShortsController(
    youtubeVideoInfoService: VideosSourceController.fromYoutubeChannel(
      channelName: 'fcbarcelona',
    ),
  );
}
```

### Shorts page use (minimal example): 
Now, we need too add the widget that shows the shorts and will use the controller we just created.

```dart
@override
Widget build(BuildContext context) {
  return YoutubeShortsPage(
    controller: controller,
  );
}
```

Don't forget to dispose the controller after closing the page.
```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

Don't forget to check out the examples of ["by url list"](https://github.com/igormidev/youtube_shorts/blob/master/example/lib/pages/shorts_by_video_url.dart) and ["by channel name"](https://github.com/igormidev/youtube_shorts/blob/master/example/lib/pages/shorts_by_channel_name.dart) implementations.


## Video manipulation

### Controll the current/focussed player
You can manipulate the player of the current video that is *focused* (in screen).
Bellow are the methods of manipulation
```dart
final ShortsController controller = ShortsController(...);

controller.playCurrentVideo(); // Will play if paused
controller.pauseCurrentVideo();  // Will pause if playing
controller.muteCurrentVideo(); // Will mute (set volume to 0)
controller.setVolume(50); // 50% of the volume (0 - 100)
```

### Set autoplay
```dart
final ShortsController controller = ShortsController(
  startWithAutoplay: false, // Default is true
  ...
);
```

### Set if videos will be played in loop
```dart
final ShortsController controller = ShortsController(
  videosWillBeInLoop: false, // Default is true
  ...
);
```

# Player manipulation

### Disable/enable default controllers
Some default controllers are in the player (time control, pause/play etc). Those are the [media_kit](https://pub.dev/packages/media_kit) default player controllers. If you wan't to desable/enable them you can controll that by boolean the variable `willHaveDefaultShortsControllers`. This is usefull if you wan't to implement your own controllers.
```dart
@override
Widget build(BuildContext context) {
  willHaveDefaultShortsControllers: false, // No more default controllers on video.
  return YoutubeShortsPage(
    controller: controller,
  );
}
```

### Create a overlay above the player
This is usefull if you want to display something like controllers or more.

```dart
@override
Widget build(BuildContext context) {
  return YoutubeShortsPage(
    controller: controller,
    overlayWidgetBuilder: (
      int index,
      PageController pageController,
      VideoController videoController,
      Video videoData,
      MuxedStreamInfo info,
    ) {
      // Example of something you may want to return (this widget bellow does not exist)
      return MyCustomDoubleTapToPauseOverlayWidget(
        ...
      ); 
    }
  );
}
```

### Set loading widget
You can display a widget that will be shown while the video is loading.
```dart
@override
Widget build(BuildContext context) {
  return YoutubeShortsPage(
    controller: controller,
    loadingWidget: Center(
      child: MyCustomCoolLoadingIndicator(),
    )
  );
}
```

### Set error widget
You can display a widget that will be shown when a error occours while fetching a video.
You will have a error and probably a stacktrace also (can be null).
```dart
@override
Widget build(BuildContext context) {
  return YoutubeShortsPage(
    controller: controller, 
    errorWidget: (error, stackTrace) {
      return Center(
        child: MyCustomCoolError(error, stackTrace),
      );
    },
  );
}
```

### Video builder 
`videoBuilder` parameter is for macking a wrapper in the player. Of if you can't to have a specific controll of the videoController of each player and wan't to make a controll of it here. `child` parameter is the default video widget that is displayed when you don't pass a `videoBuilder`. You can use it or not; for example, if you wan't to build your player from scratch, you won't use the child parameter. But if you just want to make a "wrapper" above the player, use this.
```dart
@override
Widget build(BuildContext context) {
  return YoutubeShortsPage(
    controller: controller, 
    videoBuilder: (
      int index,
      PageController pageController,
      VideoController videoController,
      Video videoData,
      MuxedStreamInfo hostedVideoInfo,
      Widget child,
    ) {
      return Container(
        padding: EdgeInsets.all(30),
        child: child,
      );
    },
  );
}
```


---
Made with ❤ by [Igor Miranda](https://github.com/igormidev) <br>
If you like the package, give a 👍