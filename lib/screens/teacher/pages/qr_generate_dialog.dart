import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/l10n.dart';

class QRGenerateDialog extends StatefulWidget {
  const QRGenerateDialog({Key key, this.courseId, this.lectureId})
      : super(key: key);

  final String courseId;
  final String lectureId;

  @override
  State<StatefulWidget> createState() => QRGenerateDialogState();
}

class QRGenerateDialogState extends State<QRGenerateDialog> {
  GlobalKey globalKey = new GlobalKey();
  String _dataString = '';

  bool isLoadingForShare = false;

  @override
  void initState() {
    super.initState();
    _dataString = '${widget.courseId}/${widget.lectureId}';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contentWidget(),
            ButtonBar(
              children: [
                TextButton.icon(
                  label: Text(S.of(context).back),
                  icon: BackButtonIcon(),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                isLoadingForShare
                    ? CircularProgressIndicator()
                    : TextButton.icon(
                        label: Text(S.of(context).shareFile),
                        icon: Icon(Icons.share),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () => _captureAndSharePng(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      setState(() {
        isLoadingForShare = true;
      });
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      setState(() {
        Share.shareFiles([file.path]);
        isLoadingForShare = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: RepaintBoundary(
        key: globalKey,
        child: QrImage(
          data: _dataString,
          size: 0.5 * bodyHeight,
        ),
      ),
    );
  }
}
