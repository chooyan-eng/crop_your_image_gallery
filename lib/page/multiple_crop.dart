import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleCrop extends StatefulWidget {
  const MultipleCrop();

  @override
  _MultipleCropState createState() => _MultipleCropState();
}

class _MultipleCropState extends State<MultipleCrop> {
  final _controllers = [
    CropController(),
    CropController(),
    CropController(),
  ];

  final _croppedDataList = <int, Uint8List?>{
    0: null,
    1: null,
    2: null,
  };

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

  void _cropAll() {
    _isProcessing = true;
    for (final controller in _controllers) {
      controller.crop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageData = context.watch<ImageDataNotifier>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Multiple Crop',
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
                child: ListView(
                  children: [
                    ...imageData.loadData.map((image) {
                      final index = imageData.loadData.indexOf(image);
                      return [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 320,
                          child: Visibility(
                            visible: _croppedDataList[index] == null,
                            child: Crop(
                              controller: _controllers[index],
                              image: image,
                              onCropped: (data) {
                                setState(() {
                                  _croppedDataList[index] = data;
                                  _isProcessing = false;
                                });
                              },
                            ),
                            replacement: _croppedDataList[index] == null
                                ? const SizedBox.shrink()
                                : Image.memory(_croppedDataList[index]!),
                          ),
                        ),
                        Container(height: 4),
                      ];
                    }).expand((child) => child),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: _cropAll,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text('CROP!'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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
