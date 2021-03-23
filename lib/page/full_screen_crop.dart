import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullScreenCrop extends StatefulWidget {
  const FullScreenCrop();

  @override
  _FullScreenCropState createState() => _FullScreenCropState();
}

class _FullScreenCropState extends State<FullScreenCrop> {
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
          'Full Screen Crop',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          if (_croppedData == null)
            IconButton(
              icon: Icon(Icons.cut),
              onPressed: () {
                isProcessing = true;
                _controller.crop();
              },
            ),
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
