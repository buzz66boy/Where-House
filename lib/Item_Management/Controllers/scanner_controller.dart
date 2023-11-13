import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class ScannerController extends StatelessWidget {
  const ScannerController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const ScanPage(title: 'WhereHouse'),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController controller = ScanController();
  var _scanResult = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Barcode Scanner',
            ),
            Text(
              _scanResult,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showBarcodeScanner,
          tooltip: 'Scan Barcode',
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: const Icon(
            Icons.scanner,
            color: Colors.white,
          )),
    );
  }

  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child:
            Container(color: const Color.fromARGB(255, 0, 0, 0), height: 4.0),
      ),
      title: const Text('Scan Your Barcode'),
      elevation: 0.0,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
            child: Icon(
          Icons.cancel,
          color: Colors.white,
        )),
      ),
      actions: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () => controller.toggleTorchMode(),
                child: const Icon(Icons.flashlight_on))),
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: controller,
        scanAreaScale: .7,
        scanLineColor: Color.fromARGB(255, 255, 0, 0),
        onCapture: (data) {
          setState(() {
            _scanResult = data.toString();
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}

//void main() => runApp(MaterialApp(home: ScannerController()));
