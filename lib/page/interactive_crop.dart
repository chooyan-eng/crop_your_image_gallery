import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InteractiveCrop extends StatefulWidget {
  const InteractiveCrop();

  @override
  _InteractiveCropState createState() => _InteractiveCropState();
}

class _InteractiveCropState extends State<InteractiveCrop> {
  final _controller = CropController();

  var _isProcessing = false;
  set isProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Uint8List? _croppedData;
  set croppedData(Uint8List? value) {
    setState(() {
      _croppedData = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageData = context.watch<ImageDataNotifier>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Interactive Crop',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Visibility(
        visible: imageData.loadData.length > 1 && !_isProcessing,
        child: imageData.loadData.length > 1
            ? Visibility(
                visible: _croppedData == null,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        child: Visibility(
                          visible: _croppedData == null,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Crop(
                                  controller: _controller,
                                  image: imageData.loadData.last,
                                  onCropped: (data) {
                                    setState(() {
                                      _croppedData = data;
                                      _isProcessing = false;
                                    });
                                  },
                                  initialAreaBuilder: (rect) => Rect.fromLTRB(
                                    rect.left + 32,
                                    rect.top + 32,
                                    rect.right - 32,
                                    rect.bottom - 32,
                                  ),
                                  interactive: true,
                                  fixArea: true,
                                  radius: 20,
                                  cornerDotBuilder: (_, __) =>
                                      const SizedBox.shrink(),
                                  maskColor: Colors.black54,
                                ),
                              ),
                              IgnorePointer(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 4,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          replacement: _croppedData == null
                              ? const SizedBox.shrink()
                              : Image.memory(
                                  _croppedData!,
                                  width: MediaQuery.of(context).size.width,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          isProcessing = true;
                          _controller.crop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text('CROP!'),
                        ),
                      ),
                    ),
                  ],
                ),
                replacement: _croppedData != null
                    ? SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.memory(
                          _croppedData!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
