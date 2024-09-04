// ignore_for_file: library_private_types_in_public_api

import 'dart:isolate';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:native_player_plugin/services/video/native_video_player_controller.dart';
import 'package:native_player_plugin/services/video/video_source.dart';
import 'package:visibility_detector/visibility_detector.dart';

class IosNativeVideoPlayerView extends StatefulWidget {
  //final void Function(NativeVideoPlayerController)? onViewReady;
  final String url;
  bool isThumbnail;

  IosNativeVideoPlayerView(
      {super.key, required this.url, this.isThumbnail = false});

  @override
  _IosNativeVideoPlayerViewState createState() =>
      _IosNativeVideoPlayerViewState();
}

class _IosNativeVideoPlayerViewState extends State<IosNativeVideoPlayerView> {
  NativeVideoPlayerController? controller;
  late int _id;
  @override
  Widget build(BuildContext context) {
    /// RepaintBoundary is a widget that isolates repaints
    return RepaintBoundary(
      child: _buildNativeView(),
    );
  }

  Widget _buildNativeView() {
    final viewType = 'native_video_player_view';
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: _handleVisibilityDetector,
      child: UiKitView(
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        // creationParams: creationParams,
        // creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  /// when the native view is created.
  onPlatformViewCreated(int id) async {
    _id = id;
    controller = NativeVideoPlayerController(_id);
    widget.isThumbnail == true ? await controller?.setThumbnailTrue() : null;
    
    await controller?.loadVideoSource(
        VideoSource(path: widget.url, type: VideoSourceType.network));
    controller?.setVolume(1.0);
    controller?.onPlaybackEnded.addListener(() async {
      controller?.stop();
      await controller?.play();
    });

    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 400);
    WidgetsFlutterBinding.ensureInitialized();

    /*    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    Isolate.spawn(
        _isolateMain, [rootIsolateToken, controller, _id, widget.url]); */
  }

  void _handleVisibilityDetector(VisibilityInfo info) async {
    if (controller != null) {
      if (info.visibleFraction <= 0.5) {
        await controller?.stop();
      } else {
        await controller?.play();
        // print('playing video ${widget.url} visibility :${info.visibleFraction}');
      }
    }
  }
  /*  void _handleVisibilityDetector(VisibilityInfo info) async {
    if (info.visibleFraction <= 0.7) {
      if (widget.pageIndex == widget.currentPageIndex && !widget.isPaused) {
        if (controller != null) {
          await controller?.pause();

          print(
              'pausing video ${widget.url} visibility :${info.visibleFraction}');
        }
      }
    } else {
      await controller?.play();
      print('playing video ${widget.url} visibility :${info.visibleFraction}');
    }
  } */
}
