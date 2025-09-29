import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FittableCameraPreview extends StatefulWidget {
  const FittableCameraPreview({
    super.key,
    this.cameraController,
    this.fit = BoxFit.cover,
    this.error,
  });

  final CameraController? cameraController;
  final String? error;
  final BoxFit fit;

  @override
  State<FittableCameraPreview> createState() => _FittableCameraPreviewState();
}

class _FittableCameraPreviewState extends State<FittableCameraPreview> {
  @override
  Widget build(BuildContext context) {
    if (widget.cameraController != null &&
        widget.cameraController!.value.isInitialized) {
      return LayoutBuilder(
        builder: (BuildContext _, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: widget.cameraController?.value.previewSize!.height,
                height: widget.cameraController?.value.previewSize!.width,
                child: widget.cameraController!.buildPreview(),
              ),
            ),
          );
        },
      );
    }
    if (widget.error != null && widget.error!.isNotEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              Column(
                children: [
                  Text(
                    widget.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
