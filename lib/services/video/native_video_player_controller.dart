import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:native_player_plugin/services/video/platform_interface/native_video_player_api.dart';
import 'package:native_player_plugin/services/video/playback_info.dart';
import 'package:native_player_plugin/services/video/video_info.dart';
import 'package:native_player_plugin/services/video/video_source.dart';

class NativeVideoPlayerController with ChangeNotifier {
  late final NativeVideoPlayerApi _api;
  VideoSource? _videoSource;
  VideoInfo? _videoInfo;

  PlaybackStatus get _playbackStatus => onPlaybackStatusChanged.value;

  int get _playbackPosition => onPlaybackPositionChanged.value;

  double get _playbackPositionFraction => videoInfo != null //
      ? _playbackPosition / videoInfo!.duration
      : 0;

  double _volume = 0;

  String? get _error => onError.value;

  /// Emitted when the video loaded successfully and it's ready to play.
  /// At this point, [videoInfo] and [playbackInfo] are available.
  final onPlaybackReady = ChangeNotifier();

  /// You can get the playback status also with [playbackInfo]
  final onPlaybackStatusChanged = ValueNotifier<PlaybackStatus>(
    PlaybackStatus.stopped,
  );

  /// You can get the playback position also with [playbackInfo]
  final onPlaybackPositionChanged = ValueNotifier<int>(0);

  /// You can get the playback speed also with [playbackInfo]
  final onPlaybackSpeedChanged = ValueNotifier<double>(1);

  /// You can get the playback volume also with [playbackInfo]
  final onVolumeChanged = ValueNotifier<double>(0);

  /// Emitted when the video has finished playing.
  final onPlaybackEnded = ChangeNotifier();

  /// Emitted when a playback error occurs
  /// or when it's not possible to load the video source
  final onError = ValueNotifier<String?>(
    null,
  );

  /// The video source that is currently loaded.
  VideoSource? get videoSource => _videoSource;

  /// The video info about the current video source.
  VideoInfo? get videoInfo => _videoInfo;

  /// The playback info about the video being played.
  PlaybackInfo? get playbackInfo => PlaybackInfo(
        status: _playbackStatus,
        position: _playbackPosition,
        positionFraction: _playbackPositionFraction,
        speed: 1.0,
        volume: _volume,
        error: _error,
      );

  /// NOTE: For internal use only.
  /// See [NativeVideoPlayerView.onViewReady] instead.
  @protected
  NativeVideoPlayerController(int viewId) {
    _api = NativeVideoPlayerApi(
      viewId: viewId,
      onPlaybackReady: _onPlaybackReady,
      onPlaybackEnded: _onPlaybackEnded,
      onError: _onError,
    );
  }

  Future<void> _onPlaybackReady() async {
    // Make sure the volume is reset to the correct value
    await setVolume(_volume);
    onPlaybackReady.notifyListeners();
  }

  Future<void> _onPlaybackEnded() async {
    await stop();
    onPlaybackEnded.notifyListeners();
  }

  void _onError(String? message) {
    onError.value = message;
  }

  // NOTE: For internal use only.
  @override
  @protected
  void dispose() {
    _api.dispose();

    super.dispose();
  }

  /// Loads a new video source.
  ///
  /// NOTE: This method might throw an exception if the video source is invalid.
  Future<void> loadVideoSource(VideoSource videoSource) async {
    await stop();
    await _api.loadVideoSource(videoSource);
    _videoSource = videoSource;
  }

  /// Starts/resumes the playback of the video.
  ///
  /// NOTE: This method might throw an exception if the video cannot be played.
  Future<void> play() async {
    await _api.play();
  }

  /// Pauses the playback of the video.
  /// Use [play] to resume the playback from the paused position.
  ///
  /// NOTE: This method might throw an exception if the video cannot be paused.

  /// Stops the playback of the video.
  /// The playback position is not reset to 0.
  /// Use [stop] then [play] to start the playback from the beginning.

  /// NOTE: This method might throw an exception if the video cannot be stopped.
  Future<void> stop() async {
    await _api.stop();
    onPlaybackStatusChanged.value = PlaybackStatus.stopped;
  }

  /// NOTE: This method might throw an exception if the volume cannot be set.
  Future<void> setVolume(double volume) async {
    await _api.setVolume(volume);
    _volume = volume;
    onVolumeChanged.value = volume;
  }
}
