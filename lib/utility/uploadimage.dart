import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pravinhonda/utility/size_config.dart';
import 'package:pravinhonda/utility/styles.dart';

class Uploadimage extends StatefulWidget {
  final String title;
  final void Function(List<File>)? onImagesSelected;
  const Uploadimage({
    super.key,
    required this.title,
    this.onImagesSelected
  });

  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage> {
  List<File> selectedImages = [];

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final File? image = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraOverlayScreen(),
      ),
    );

    if (image != null) {
      _validateAndAddImage(image);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    _validateAndAddImage(File(pickedFile.path));
  }

  void _validateAndAddImage(File file) {
    const int maxSizeInBytes = 5 * 1024 * 1024;

    if (file.lengthSync() > maxSizeInBytes) {
      Fluttertoast.showToast(msg: 'Selected image exceeds 5 MB');
      return;
    }

    if (selectedImages.isNotEmpty) {
      Fluttertoast.showToast(msg: 'You can only upload 1 image');
      return;
    }

    setState(() {
      selectedImages.add(file);
    });

    widget.onImagesSelected?.call(selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff919EAB),
                ),
              ),
              Text(
                  '*',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: kred
                  ),
                ),
            ],
          ),
          SizedBox(height: SizeConfig.h(5)),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(offset: Offset(0, 2), color: Colors.grey, blurRadius: 2),
              ],
              border: Border.all(color: kgrey),
            ),
            child: RawMaterialButton(
              onPressed: _showImageSourcePicker,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedImages.isNotEmpty)
                    SizedBox(
                      height: 80,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(selectedImages.length, (index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Image.file(
                                    selectedImages[index],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    )
                  else
                    const Icon(Icons.cloud_upload_outlined, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    selectedImages.isNotEmpty ? 'Image Uploaded' : 'Upload Image',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Add Image (${selectedImages.length}/1)',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xff939292),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraOverlayScreen extends StatefulWidget {
  const CameraOverlayScreen({super.key});

  @override
  State<CameraOverlayScreen> createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends State<CameraOverlayScreen> {
  CameraController? _controller;
  late List<CameraDescription> cameras;
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    setState(() => isReady = true);
  }

  Future<void> _captureImage() async {
    final XFile rawImage = await _controller!.takePicture();

    final Uint8List cameraBytes = await File(rawImage.path).readAsBytes();
    img.Image cameraImage = img.decodeImage(cameraBytes)!;

    final ByteData overlayData =
        await rootBundle.load('images/honda_frame.png');
    final Uint8List overlayBytes = overlayData.buffer.asUint8List();
    img.Image overlayImage = img.decodeImage(overlayBytes)!;

    overlayImage = img.copyResize(
      overlayImage,
      width: cameraImage.width,
      height: cameraImage.height,
    );
    
    img.Image finalImage = img.compositeImage(
      cameraImage,
      overlayImage,
    );

    final directory = await getTemporaryDirectory();
    final String finalPath =
        '${directory.path}/camera_with_overlay_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final File finalFile =
        File(finalPath)..writeAsBytesSync(img.encodeJpg(finalImage, quality: 95));

    Navigator.pop(context, finalFile);
  }

  @override
  void dispose() {
    _controller?.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: kred)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: CameraPreview(_controller!),
            ),
          ),

          Center(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: IgnorePointer(
                child: Image.asset(
                  'images/honda_frame.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureImage,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.red, width: 4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
