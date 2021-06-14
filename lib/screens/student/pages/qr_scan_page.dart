import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../generated/l10n.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key key, @required this.onCodeScanned}) : super(key: key);

  final Function(String) onCodeScanned;

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).scan_lecture_code),
        backgroundColor: Colors.transparent,
        actions: [
          _buildFlashToggleButton(),
          _buildFlipCameraButton(),
        ],
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: _buildQrView(context),
      ),
    );
  }

  IconButton _buildFlipCameraButton() {
    return IconButton(
      icon: Icon(Icons.flip_camera_android_rounded),
      onPressed: () async {
        await controller?.flipCamera();
      },
    );
  }

  IconButton _buildFlashToggleButton() {
    return IconButton(
      icon: FutureBuilder(
        future: controller?.getFlashStatus(),
        builder: (context, snapshot) {
          bool isFlashOn = snapshot.data != null ? snapshot.data : false;
          return isFlashOn
              ? Icon(Icons.flash_off_rounded)
              : Icon(Icons.flash_on_rounded);
        },
      ),
      onPressed: () async {
        await controller?.toggleFlash();
        setState(() {});
      },
    );
  }

  Widget _buildQrView(BuildContext context) {
    // We check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      // You can choose between CameraFacing.front or CameraFacing.back. Defaults to CameraFacing.back
      // cameraFacing: CameraFacing.front,
      onQRViewCreated: _onQRViewCreated,
      // Choose formats you want to scan. Defaults to all formats.
      // formatsAllowed: [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 2,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        widget.onCodeScanned(scanData.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
