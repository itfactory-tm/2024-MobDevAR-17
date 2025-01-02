import 'package:beer_explorer/Response.dart';
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

  void onUnityMessage(message) {
    debugPrint('Received message from Unity: ${message.data}');

    // Decode the JSON message
    Map<String, dynamic> responseJson = jsonDecode(message.data);

    // Map the JSON to the Response class
    Response response = Response.fromJson(responseJson);

    // Verwerken van BeerResponses
    for (BeerResponse beer in response.data) {
      debugPrint(
          'Name: ${beer.name}, Brewery: ${beer.brewery}, Country: ${beer.country}');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beers from Unity'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: response.data.map((beer) {
              return Text(
                'Name: ${beer.name}\nBrewery: ${beer.brewery}\nCountry: ${beer.country}\n\n',
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }
}
