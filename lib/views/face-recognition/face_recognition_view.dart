import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'dart:io';


import '../../ML/Recognizer.dart';
import '../../ML/Recognition.dart';
import '../../main.dart';
import '../../widgets/face_detector_painter.dart';

class FaceRecognitionView extends StatefulWidget {
  const FaceRecognitionView({super.key});

  @override
  _FaceRecognitionViewState createState() => _FaceRecognitionViewState();
}

class _FaceRecognitionViewState extends State<FaceRecognitionView> {
  CameraController? controller;
  bool isBusy = false;
  bool register = false;
  List<Recognition> recognitions = [];
  late FaceDetector faceDetector;
  late Recognizer recognizer;
  CameraLensDirection camDirec = CameraLensDirection.front;
  CameraDescription? description;
  CameraImage? frame;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeComponents();
  }

  void _initializeComponents() {
    var options = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);

    recognizer = Recognizer();

    _initializeCamera();
  }

  void _initializeCamera() {
    description = cameras[camDirec == CameraLensDirection.front ? 1 : 0];

    controller = CameraController(
      description!,
      ResolutionPreset.medium,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});

      controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
          _doFaceDetectionOnFrame();
        }
      });
    });
  }

  void _doFaceDetectionOnFrame() async {
    InputImage? inputImage = _getInputImage();
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    List<Face> faces = await faceDetector.processImage(inputImage);
    _performFaceRecognition(faces);
  }

  void _performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    img.Image? image = Platform.isIOS
        ? _convertBGRA8888ToImage(frame!)
        : _convertNV21(frame!);

    image = img.copyRotate(
        image,
        angle: camDirec == CameraLensDirection.front ? 270 : 90
    );

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;

      img.Image croppedFace = img.copyCrop(
          image,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt()
      );

      Recognition recognition = recognizer.recognize(croppedFace, faceRect);

      if (recognition.distance > 1.0) {
        recognition.name = "Unknown";
      }

      recognitions.add(recognition);

      if (register) {
        _showFaceRegistrationDialog(croppedFace, recognition);
        register = false;
      }
    }

    setState(() {
      isBusy = false;
    });
  }

  void _showFaceRegistrationDialog(img.Image croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.memory(
                Uint8List.fromList(img.encodeBmp(croppedFace)),
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter Name"
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    recognizer.registerFaceInDB(
                        textEditingController.text,
                        recognition.embeddings
                    );
                    textEditingController.clear();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Face Registered"))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)
                  ),
                  child: const Text("Register")
              )
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  void _toggleCameraDirection() {
    camDirec = camDirec == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    controller?.stopImageStream().then((_) {
      setState(() {
        controller;
      });
      _initializeCamera();
    });
  }

  InputImage? _getInputImage() {
    if (frame == null) return null;

    final camera = camDirec == CameraLensDirection.front ? cameras[1] : cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _getRotationCompensation(sensorOrientation, camera);
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (frame!.planes.length != 1) return null;
    final plane = frame!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  int _getRotationCompensation(int sensorOrientation, CameraDescription camera) {
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    var rotationCompensation = orientations[controller!.value.deviceOrientation];
    if (rotationCompensation == null) return sensorOrientation;

    if (camera.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
    }

    return rotationCompensation;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    if (controller != null) {
      // Camera preview
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller!.value.isInitialized)
                ? AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: CameraPreview(controller!),
            )
                : Container(),
          ),
        ),
      );

      // Face detection overlay
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: _buildFaceDetectionOverlay(),
        ),
      );
    }

    // Control bar
    stackChildren.add(
      Positioned(
        top: size.height - 140,
        left: 0,
        width: size.width,
        height: 80,
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20),
          color: Colors.blue,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.cached, color: Colors.white),
                  iconSize: 40,
                  onPressed: _toggleCameraDirection,
                ),
                IconButton(
                  icon: const Icon(Icons.face_retouching_natural, color: Colors.white),
                  iconSize: 40,
                  onPressed: () {
                    setState(() {
                      register = true;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: const EdgeInsets.only(top: 0),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      ),
    );
  }

  Widget _buildFaceDetectionOverlay() {
    return controller != null && controller!.value.isInitialized
        ? CustomPaint(
      painter: FaceDetectorPainter(
          Size(
              controller!.value.previewSize!.height,
              controller!.value.previewSize!.width
          ),
          recognitions,
          camDirec
      ),
    )
        : const SizedBox.shrink();
  }


  @override
  void dispose() {
    controller?.dispose();
    faceDetector.close();
    recognizer.close();
    super.dispose();
  }

  // Image conversion methods
  static img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final plane = cameraImage.planes[0];
    return img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: plane.bytes.buffer,
      rowStride: plane.bytesPerRow,
      bytesOffset: 28,
      order: img.ChannelOrder.bgra,
    );
  }

  static img.Image _convertNV21(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();

    Uint8List yuv420sp = image.planes[0].bytes;
    final outImg = img.Image(height: height, width: width);
    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        r = r.clamp(0, 262143);
        g = g.clamp(0, 262143);
        b = b.clamp(0, 262143);

        outImg.setPixelRgb(i, j,
            ((r << 6) & 0xff0000) >> 16,
            ((g >> 2) & 0xff00) >> 8,
            (b >> 10) & 0xff
        );
      }
    }
    return outImg;
  }
}