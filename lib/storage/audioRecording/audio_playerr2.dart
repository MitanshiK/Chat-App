import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    required this.source,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  /// Path from where to play recorded audio
  final ap.AudioSource source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  @override
  AudioPlayerState createState() => AudioPlayerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ap.AudioSource>('source', source));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onDelete', onDelete));
  }
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  @override
  void initState() {
    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen((ap.PlayerState state) async {
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.positionStream.listen((Duration position) => setState(() {}));
    _durationChangedSubscription = _audioPlayer.durationStream.listen((Duration? duration) => setState(() {}));
    _init();

    super.initState();
  }

  Future<void> _init() async {
    await _audioPlayer.setAudioSource(widget.source);
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

// The LayoutBuilder widget in Flutter is a widget that builds a widget tree that can depend on the parent widget's size
//  It is similar to the Builder widget except that the framework calls the builder function at layout time and provides the parent widget's constraints
// This is useful when the parent constrains the child's size and doesn't depend on the child's intrinsic size
//  The LayoutBuilder's final size will match its child's size

    return LayoutBuilder(           
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildControl(),
            _buildSlider(constraints.maxWidth),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Color(0xFF73748D),
                size: _deleteBtnSize,
              ),
              onPressed: () {
                // ignore: always_specify_types
                _audioPlayer.stop().then((value) => widget.onDelete());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.playerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } 
    else {
      final ThemeData theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return IconButton(onPressed: (){
       if (_audioPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
    }, icon: icon);
    // ClipOval(
    //   child: Material(
    //     color: color,
    //     child: InkWell(
    //       child: SizedBox(width: _controlSize, height: _controlSize, child: icon),
    //       onTap: () {
    //         if (_audioPlayer.playerState.playing) {
    //           pause();
    //         } else {
    //           play();
    //         }
    //       },
    //     ),
    //   ),
    // );
  }

  Widget _buildSlider(double widgetWidth) {
    final Duration position = _audioPlayer.position;
    final Duration? duration = _audioPlayer.duration;
    bool canSetValue = false;
    if (duration != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds; //canSetValue and position.inMilliseconds are smaller than duration.inMilliseconds
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (double v) { 
          if (duration != null) {
            final double position = v * duration.inMilliseconds; // getting the position of audio when changed by users 
            _audioPlayer.seek(Duration(milliseconds: position.round()));  // setting audio to the changed duration
          }
        },
        value: canSetValue && duration != null ? position.inMilliseconds / duration.inMilliseconds : 0.0,
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(Duration.zero);
  }
}