import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share/share.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "QR Scanner",
            style: GoogleFonts.mulish(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 0,
              letterSpacing: -0.32,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.black);
                  }
                },
              ),
              iconSize: 25.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.black,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.flip_camera_android);
                    case CameraFacing.back:
                      return const Icon(Icons.flip_camera_android);
                  }
                },
              ),
              iconSize: 25.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          allowDuplicates: true,
          fit: BoxFit.contain,
          controller: cameraController,
          onDetect: _foundBarcode,
        ),
      ),
    );
  }

  void _foundBarcode(Barcode barcode, MobileScannerArguments? args) {
    /// open screen
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "---";
      debugPrint('Barcode found! $code');
      _screenOpened = true;
      // Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //     FoundCodeScreen(screenClosed: _screenWasClosed, value: code),));

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return FoundCodeScreen(screenClosed: _screenWasClosed, value: code);
        },
      );
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}

class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;
  const FoundCodeScreen({
    super.key,
    required this.value,
    required this.screenClosed,
  });

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.screenClosed();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Result",
            style: GoogleFonts.mulish(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 0,
              letterSpacing: -0.32,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   onPressed: () {
          //     widget.screenClosed();
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_outlined,
          //   ),
          // ),
        ),
        body: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text("Scanned Code:",  style:GoogleFonts.mulish(
              //   color: Colors.black,
              //   fontSize: 16,
              //   fontWeight: FontWeight.w800,
              //   height: 0,
              //   letterSpacing: -0.32,
              // ),),
              // SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x66AEAEC0),
                        blurRadius: 3,
                        offset: Offset(1.50, 1.50),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 3,
                        offset: Offset(-3, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          widget.value,
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.w800,
                            height: 0,
                            letterSpacing: -0.32,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Share.share(widget.value);
                              },
                              icon: Icon(
                                Icons.share,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.value));
                              },
                              icon: Icon(
                                Icons.copy,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
