import 'package:flutter/foundation.dart';

/// Video playback information.
class PlaybackInfo {
  /// The current playback status.
  final PlaybackStatus status;

  /// The current playback position, in seconds.
  final int position;

  /// The current playback position as a value between 0 and 1.
  final double positionFraction;

  /// The current playback volume.
  final double volume;

  /// The current playback speed.
  final double speed;

  /// An error message, if playback failed.
  final String? error;


  @protected
  PlaybackInfo({
    required this.status,
    required this.position,
    required this.positionFraction,
    required this.volume,
    required this.speed,
    this.error,
  });
}

enum PlaybackStatus {
  playing,
  paused,
  stopped,
}
