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
  bool _isScanAreaVisible = true;

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

    return Stack(
      children: [
        // Unity widget voor de wereldbol
        UnityWidget(
          onUnityCreated: _onUnityCreated,
          onUnityMessage: onUnityMessage,
          useAndroidViewSurface: true,
          borderRadius: const BorderRadius.all(Radius.circular(70)),
        ),

        if (_isScanAreaVisible)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 250, // Pas de grootte van het vak aan
                height: 250, // Pas de grootte van het vak aan
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blue, width: 3), // Groene rand
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (!_isScanAreaVisible)
          Positioned(
            bottom: 50,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                _setWorldVisibility(false);
                setState(() {
                  _isScanAreaVisible = true;
                });
              },
              child: Text('Opnieuw scannen'),
            ),
          ),
      ],
    );
  }

  void _sendBeer() {
    _unityWidgetController?.postMessage(
        "TargetBeer", "SetTargetBeer", jsonEncode(beer?.toJson()));
  }

  void _setWorldVisibility(bool visibility) {
    _unityWidgetController?.postMessage(
        "WorldVisibility", "SetWorldVisibility", jsonEncode(visibility));
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
            _isScanAreaVisible = false;
            this.beer = beer;
          });
          if (beer != null) {
            _sendBeer();
            UserApi.addBeerToUser(currentUser!.id, this.beer!.id);
            currentUser!.beers.add(this.beer!.id);
          } else {
            debugPrint("Beer not found: $name");
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
