import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';

class MicWidget extends StatefulWidget {
  MicWidget({super.key, required this.onStop});

    final void Function(String path) onStop; // when recording is stopped the path of recorded audio is recieved

  @override
  State<MicWidget> createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget> {
late Map<Permission, PermissionStatus> statuses;

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

void per()async{
if(Platform.isAndroid)  {
  AndroidDeviceInfo androidInfo  = await deviceInfo.androidInfo;
  if(androidInfo.version.sdkInt >= 31) {
    statuses = await [ Permission.microphone].request();
  } else {
    statuses = await [ Permission.microphone].request();
  }
} else {
  debugPrint("could not get permission");
}
}

  bool _isRecording = false;
  int _recordDuration = 0;  // shows duration while recording 
  Timer? _timer;  
  Timer? _ampTimer;
  final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();  // sound recorder
  Amplitude? _amplitude;   

  @override
  void initState() {
    per();  // to ask permissions
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _buildRecordStopControl();
  }


   Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording ) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final ThemeData theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }
    return IconButton(onPressed: (){
    _isRecording ? _stop() : _start();
    }, icon: icon);

  }

   Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final String? path = await _audioRecorder.stop();

    widget.onStop(path!);
    setState(() => _isRecording = false);
  }

    void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}