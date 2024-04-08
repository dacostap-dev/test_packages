import 'dart:async';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

import 'dart:io' as io;

import 'package:test_package_call/chat_buble.dart';
import 'package:test_package_call/dialog.dart';

class PhoneStatePage extends StatefulWidget {
  static const String route = 'phone-state';

  const PhoneStatePage({super.key});

  @override
  State<PhoneStatePage> createState() => _PhoneStatePageState();
}

class _PhoneStatePageState extends State<PhoneStatePage> {
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  PhoneState status = PhoneState.nothing();
  bool granted = false;
  bool showDialogFlag = false;

  Future<bool> requestPermission() async {
    final permissionStatus = await Permission.phone.request();

    return switch (permissionStatus) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();

    _init();
    setStream();
  }

  void setStream() async {
    bool isGranted = await requestPermission();
    print(isGranted);

    if (!isGranted) return;

    PhoneState.stream.listen((event) async {
      print('event ${event.status}');

      setState(() {
        status = event;
      });

      if (event.status == PhoneStateStatus.CALL_ENDED) {
        await _stop();

        if (!showDialogFlag && mounted) {
          //Aparece doble vez

          print('tesss ${_current!.path!}');

          showDialog(
            context: context,
            builder: (context) => MyDialog(
              audioPath: _current!.path!,
            ),
          );

          showDialogFlag = true;
        }
      }
    });
  }

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        late io.Directory appDocDirectory;

        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        final current = await _recorder?.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine

        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone State'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //if (Platform.isAndroid)
            ElevatedButton(
              onPressed: !granted
                  ? () async {
                      bool isGranted = await requestPermission();

                      setState(() {
                        granted = isGranted;

                        if (granted) {
                          setStream();
                        }
                      });
                    }
                  : null,
              child: const Text('Request permission of Phone'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                const number = '932883810'; //set the number here
                final res = await FlutterPhoneDirectCaller.callNumber(number);
                print(res);

                _start();
              },
              icon: Icon(Icons.call),
              label: Text('Llamar al solicitante'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => MyDialog(
                          audioPath: _current!.path!,
                        ));
              },
              icon: Icon(Icons.call),
              label: Text('test dialog'),
            ),

            const Text(
              'Status of call',
              style: TextStyle(fontSize: 24),
            ),
            if (status.status == PhoneStateStatus.CALL_INCOMING ||
                status.status == PhoneStateStatus.CALL_STARTED)
              Text(
                'Number: ${status.number}',
                style: const TextStyle(fontSize: 24),
              ),
            Icon(
              getIcons(),
              color: getColor(),
              size: 80,
            )
          ],
        ),
      ),
    );
  }

  IconData getIcons() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING => Icons.clear,
      PhoneStateStatus.CALL_INCOMING => Icons.add_call,
      PhoneStateStatus.CALL_STARTED => Icons.call,
      PhoneStateStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
      PhoneStateStatus.CALL_INCOMING => Colors.green,
      PhoneStateStatus.CALL_STARTED => Colors.orange,
    };
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final result = await _recorder?.stop();
    print("Stop recording: ${result?.path}");
    print("Stop recording: ${result?.duration}");

    final file = io.File(result!.path!);
    print("File length: ${await file.length()}");

    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }
}
