import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScanPage extends StatefulWidget {
  final List<CameraDescription> cameras; // Pass available cameras from main

  const CameraScanPage({super.key, required this.cameras});

  @override
  State<CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use the first available camera (usually the back camera)
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras.first,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      // Here you can navigate to a result page or process the image
      // For now, just show a snackbar with the image path
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture saved to ${image.path}')),
      );
      // Optionally navigate back after a delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, image.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Leaf'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_controller != null && _controller!.value.isInitialized) {
              return Stack(
                children: [
                  // Camera preview
                  CameraPreview(_controller!),
                  // Capture button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: FloatingActionButton.large(
                        onPressed: _takePicture,
                        backgroundColor: Colors.green.shade800,
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Camera not available'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}