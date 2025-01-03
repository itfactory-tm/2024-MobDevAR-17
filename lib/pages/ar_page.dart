import 'package:beer_explorer/apis/beer_api.dart';
import 'package:beer_explorer/apis/user_api.dart';
import 'package:beer_explorer/globals.dart';
import 'package:beer_explorer/models/beer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  UnityWidgetController? _unityWidgetController;
  bool _isCameraPermissionGranted = false;
  Beer? beer;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    } else {
      _isCameraPermissionGranted = false;
    }
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return const Center(
          child: Text('Camera permission is required to proceed.'));
    }

    return UnityWidget(
      onUnityCreated: _onUnityCreated,
      onUnityMessage: onUnityMessage,
      onUnitySceneLoaded: onUnitySceneLoaded,
      useAndroidViewSurface: true,
      borderRadius: const BorderRadius.all(Radius.circular(70)),
    );
  }

  void _sendBeer() {
    if (beer != null) {
      _unityWidgetController?.postMessage(
          "TargetBeer", "SetTargetBeer", jsonEncode(beer!.toJson()));
      debugPrint("Beer sent to Unity: ${beer!.name}");
    } else {
      debugPrint("No beer to send to Unity.");
    }
  }

  void onUnityMessage(message) {
    debugPrint('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-');

    try {
      Map<String, dynamic> decodedMessage = json.decode(message);
      String key = decodedMessage['key'];
      String name = decodedMessage['name'];

      if (key == "TrackedObject" && name.isNotEmpty) {
        BeerApi.fetchBeerByName(name).then((beer) {
          setState(() {
            this.beer = beer;
          });
          if (beer != null) {
            _sendBeer();
            UserApi.addBeerToUser(currentUser!.id, this.beer!.id);
          } else {
            debugPrint("Beer not found: $name");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Bier $name niet gevonden!"),
                  content: const Text("Probeer een ander bier..."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error parsing message from Unity: $e');
    }
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      debugPrint('Received scene loaded from unity: ${scene.name}');
      debugPrint(
          'Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      debugPrint('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }
}
