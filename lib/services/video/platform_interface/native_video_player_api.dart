import 'package:flutter/services.dart';

import 'package:native_player_plugin/services/video/video_source.dart';


class NativeVideoPlayerApi {
  final int viewId;
  final void Function() onPlaybackReady;
  final void Function() onPlaybackEnded;
  final void Function(String?) onError;
  late final MethodChannel _channel;  RootIsolateToken? rootIsolateToken;

  NativeVideoPlayerApi({
    required this.viewId,
    required this.onPlaybackReady,
    required this.onPlaybackEnded,
    required this.onError,
  }) {
    final name = 'tezda.video.$viewId';
    _channel = MethodChannel(name);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
  }

  Future _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onPlaybackReady":
        onPlaybackReady();
      case 'onPlaybackEnded':
        onPlaybackEnded();
      case 'onError':
        // final errorCode = call.arguments['errorCode'] as int;
        // final errorMessage = call.arguments['errorMessage'] as String;
        final message = call.arguments as String;
        onError(message);
      default:
        onError('Un implemented : ${call.method}');
    }
  }

  Future<void> loadVideoSource(VideoSource videoSource) async {
    await _channel.invokeMethod<void>(
      'loadVideoSource',
      videoSource.toJson(),
    );
  }

  Future<void> play() async {
    await _channel.invokeMethod<void>(
      'play',
    );
  }
  Future<void> setThumbnail() async {
    await _channel.invokeMethod<void>(
      'setThumbnail',
    );
  }

  Future<void> pause() async {
    await _channel.invokeMethod<void>(
      'pause',
    );
  }

  Future<void> stop() async {
    await _channel.invokeMethod<void>(
      'stop',
    );
  }

  Future<void> setVolume(double volume) async {
    await _channel.invokeMethod<bool>(
      'setVolume',
      volume,
    );
  }
}
