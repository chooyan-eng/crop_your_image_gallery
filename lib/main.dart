import 'package:cropyourimage_gallery/page/multiple_crop.dart';
import 'package:cropyourimage_gallery/page/colorful_screen_crop.dart';
import 'package:cropyourimage_gallery/page/configurable_crop.dart';
import 'package:cropyourimage_gallery/page/full_screen_crop.dart';
import 'package:cropyourimage_gallery/provider/image_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ImageDataNotifier()..loadAllImages(),
        ),
      ],
      child: MaterialApp(
        title: 'crop_your_image gallery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const pages = const [
    FullScreenCrop(),
    ColorefulScreenCrop(),
    ConfigurableCrop(),
    MultipleCrop(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery | crop_your_image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pages
            .map(
              (page) => [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => page,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        page.runtimeType.toString(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: 40,
                  color: Colors.black87,
                ),
              ],
            )
            .expand((element) => element)
            .toList()
          ..removeLast(),
      ),
    );
  }
}
