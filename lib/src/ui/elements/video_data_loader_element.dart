import 'package:flutter/material.dart';
import 'package:youtube_shorts/src/ui/elements/default_widgets.dart';
import 'package:youtube_shorts/youtube_shorts.dart';

class VideoDataLoaderElement extends StatefulWidget {
  /// The controller of the short's.
  final ShortsController controller;

  /// Will be displayed when an error occurs.
  ///
  /// If null, the default widget is:
  /// ```dart
  /// const Center(
  ///   child: SizedBox(
  ///     width: 50,
  ///     height: 50,
  ///     child: Icon(Icons.error),
  ///   ),
  /// );
  /// ```
  final Widget Function(Object error, StackTrace? stackTrace)? errorWidget;

  /// The widget that will be displayed while the [ShortsController]
  /// initial dependencies are loading.
  ///
  /// If null, the default widget is:
  /// ```dart
  /// const Center(
  ///   child: SizedBox(
  ///     width: 50,
  ///     height: 50,
  ///     child: CircularProgressIndicator.adaptive(),
  ///   ),
  /// );
  /// ```
  final Widget? loadingWidget;

  final Widget child;

  /// Callback provides status is loading widget  shown
  final void Function(bool loading)? onLoading;

  const VideoDataLoaderElement({
    super.key,
    required this.controller,
    required this.errorWidget,
    required this.loadingWidget,
    required this.child,
    this.onLoading,
  });

  @override
  State<VideoDataLoaderElement> createState() => _VideoDataLoaderElementState();
}

class _VideoDataLoaderElementState extends State<VideoDataLoaderElement> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, shortsState, child) {
        if (shortsState.isDataState) {
          widget.onLoading?.call(false);
          return child!;
        } else if (shortsState.isErrorState) {
          widget.onLoading?.call(false);
          shortsState as ShortsStateError;
          return widget.errorWidget?.call(
                shortsState.error,
                shortsState.stackTrace,
              ) ??
              const YoutubeShortsDefaultErrorWidget();
        } else {
          widget.onLoading?.call(true);
          return widget.loadingWidget ??
              const YoutubeShortsDefaultLoadingWidget();
        }
      },
      child: widget.child,
    );
  }
}
