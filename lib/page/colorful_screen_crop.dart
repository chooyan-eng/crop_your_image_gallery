import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorefulScreenCrop extends StatefulWidget {
  const ColorefulScreenCrop();

  @override
  _ColorefulScreenCropState createState() => _ColorefulScreenCropState();
}

class _ColorefulScreenCropState extends State<ColorefulScreenCrop> {
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
        backgroundColor: Colors.lightBlue.shade50,
        title: Text(
          'Coloreful Screen Crop',
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          if (_croppedData == null)
            IconButton(
              icon: Icon(Icons.cut),
              onPressed: () {
                isProcessing = true;
                _controller.cropCircle();
              },
            ),
          if (_croppedData != null)
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: () => croppedData = null,
            ),
        ],
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: Visibility(
        visible: imageData.hasData && !_isProcessing,
        child: imageData.hasData
            ? Visibility(
                visible: _croppedData == null,
                child: Crop(
                  controller: _controller,
                  image: imageData.loadData[0],
                  onCropped: (cropped) {
                    croppedData = cropped;
                    isProcessing = false;
                  },
                  initialSize: 0.5,
                  cornerDotBuilder: (size, edge) => DotControl(
                    color: {
                      EdgeAlignment.topLeft: Colors.amberAccent,
                      EdgeAlignment.topRight: Colors.tealAccent,
                      EdgeAlignment.bottomRight: Colors.pinkAccent,
                      EdgeAlignment.bottomLeft: Colors.white,
                    }[edge]!,
                  ),
                  maskColor: Colors.green.shade300.withAlpha(200),
                  baseColor: Colors.green,
                  withCircleUi: true,
                ),
                replacement: _croppedData != null
                    ? Container(
                        padding: const EdgeInsets.all(16),
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
