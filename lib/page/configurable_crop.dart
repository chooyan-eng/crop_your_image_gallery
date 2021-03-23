import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigurableCrop extends StatefulWidget {
  const ConfigurableCrop();

  @override
  _ConfigurableCropState createState() => _ConfigurableCropState();
}

class _ConfigurableCropState extends State<ConfigurableCrop> {
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

  var _isPreviewing = false;
  set isPreviewing(bool value) {
    setState(() {
      _isPreviewing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageData = context.watch<ImageDataNotifier>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Full Screen Crop',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          if (_croppedData != null)
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: () => croppedData = null,
            ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Visibility(
        visible: imageData.loadData.length > 2 && !_isProcessing,
        child: imageData.loadData.length > 2
            ? Visibility(
                visible: _croppedData == null,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Crop(
                            controller: _controller,
                            image: imageData.loadData[2],
                            onCropped: (cropped) {
                              croppedData = cropped;
                              isProcessing = false;
                            },
                            initialSize: 0.5,
                            cornerDotBuilder: (size, cornerIndex) {
                              return _isPreviewing
                                  ? const SizedBox.shrink()
                                  : const DotControl();
                            },
                            maskColor: _isPreviewing ? Colors.white : null,
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ChoiceChip(
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: const Text(
                                  'PREVIEW',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              selected: _isPreviewing,
                              onSelected: (value) => isPreviewing = value,
                              backgroundColor: Colors.black26,
                              selectedColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        children: const [
                          _ShapeSelection('16 : 9', 16 / 9, Icons.crop_7_5),
                          _ShapeSelection('8 : 5', 8 / 5, Icons.crop_16_9),
                          _ShapeSelection('7 : 5', 7 / 5, Icons.crop_5_4),
                          _ShapeSelection('4 : 3', 4 / 3, Icons.crop_3_2),
                        ].map((shapeData) {
                          return InkWell(
                            onTap: () {
                              _controller.aspectRatio = shapeData.aspectRatio;
                              _controller.withCircleUi = false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Icon(shapeData.icon),
                                  const SizedBox(height: 4),
                                  Text(shapeData.label)
                                ],
                              ),
                            ),
                          );
                        }).toList()
                          ..add(
                            InkWell(
                              onTap: () => _controller.withCircleUi = true,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Icon(Icons.fiber_manual_record_outlined),
                                    const SizedBox(height: 4),
                                    Text('Circle'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cut),
                        const SizedBox(width: 8),
                        const Text(
                          'Crop as',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              isProcessing = true;
                              _controller.cropCircle();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('CIRCLE'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              isProcessing = true;
                              _controller.crop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('RECT'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 60),
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

class _ShapeSelection {
  const _ShapeSelection(this.label, this.aspectRatio, this.icon);

  final String label;
  final double aspectRatio;
  final IconData icon;
}
