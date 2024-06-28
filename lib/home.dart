import 'dart:io';
import 'dart:developer' as devtools;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:plantjake/detailscreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filePath;
  Image? image;
  String label = 'Belum terdeteksi';
  double confidence = 0.0;
  final logger = Logger();
  List<String> plantLabels = [];
  Map<String, String> plantDescriptions = {};
  bool isLoading = false; // State for loading indicator

  @override
  void initState() {
    super.initState();
    tfLiteInit();
    loadPlantLabelsAndDescriptions();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> tfLiteInit() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/15model_unquant.tflite",
        labels: "assets/15labels.txt",
      );

      if (res != null) {
        logger.i("Model loaded successfully: $res");
        await loadPlantLabelsAndDescriptions();
      }
    } catch (e) {
      logger.e("Error loading model: $e");
    }
  }

  Future<void> loadPlantLabelsAndDescriptions() async {
    try {
      final labelsData = await rootBundle.loadString('assets/15labels.txt');
      final descriptionsData =
          await rootBundle.loadString('assets/descriptions.txt');

      setState(() {
        plantLabels =
            labelsData.split('\n').map((label) => label.trim()).toList();
        logger.i("Loaded labels: $plantLabels");

        final descriptionsLines = descriptionsData.split('\n');
        for (var line in descriptionsLines) {
          final parts = line.split(':');
          if (parts.length == 2) {
            plantDescriptions[parts[0].trim()] = parts[1].trim();
          }
        }
        logger.i("Loaded descriptions: $plantDescriptions");
      });
    } catch (e) {
      logger.e("Error loading labels or descriptions: $e");
    }
  }

  Future<void> pickImageOnCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo == null) return;

    setState(() {
      filePath = File(photo.path);
      image = Image.file(filePath!);
    });
    await runModelOnImage(photo.path);
  }

  Future<void> pickImageOnGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      filePath = File(pickedFile.path);
      image = Image.file(filePath!);
    });

    if (filePath != null) {
      await runModelOnImage(filePath!.path);
    }
  }

  Future<void> runModelOnImage(String path) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    final BuildContext dialogContext = context; // Save context here

    try {
      var recognitions = await Tflite.runModelOnImage(
        path: path,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 36,
        threshold: 0.5,
        asynch: true,
      );

      if (recognitions == null || recognitions.isEmpty) {
        devtools.log("No recognitions found");
        setState(() {
          confidence = 0.0;
          label = 'No match found';
          isLoading = false; // Set loading state to false
        });
        // Tampilkan dialog setelah operasi asinkron selesai
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDetectionResult(
            dialogContext,
            label,
            "Description based on label: $label",
            confidence,
            pickImageOnCamera,
            (context, label, description) => viewDetail(
              context,
              label,
              description,
              filePath?.path, // Menggunakan filePath?.path sebagai imagePath
            ),
          );
        });
        return;
      }

      devtools.log(recognitions.toString());
      logger.i("Recognitions: $recognitions");

      setState(() {
        var highestConfidence = recognitions[0];
        for (var recognition in recognitions) {
          if (recognition['confidence'] > highestConfidence['confidence']) {
            highestConfidence = recognition;
          }
        }

        logger.i("Highest Confidence Recognition: $highestConfidence");
        String predictedLabel = highestConfidence['label'].toString().trim();
        if (highestConfidence['confidence'] * 100 < 89 ||
            !plantLabels.contains(predictedLabel)) {
          confidence = 0.0;
          label = 'No match found';
        } else {
          confidence = highestConfidence['confidence'] * 100;
          label = predictedLabel;
        }
        isLoading = false; // Set loading state to false
      });

      // Tampilkan dialog setelah operasi asinkron selesai
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDetectionResult(
          dialogContext,
          label,
          plantDescriptions[label] ?? 'Deskripsi tidak tersedia',
          confidence,
          pickImageOnCamera,
          (context, label, description) => viewDetail(
            context,
            label,
            description,
            filePath?.path ?? '', // Ensure filePath?.path is non-null
          ),
        );
      });
    } catch (e) {
      logger.e("Error running model: $e");
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
      // Handle error
    }
  }

  void showDetectionResult(
    BuildContext context,
    String label,
    String description,
    double confidence,
    Function pickImageOnCamera,
    Function(BuildContext, String, String) viewDetail,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Hasil Deteksi",
                style: TextStyle(
                  fontFamily: "Baloo2",
                  fontSize: 30,
                  color: Color(0xFF1A4D2E),
                  height: 2,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${confidence.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    pickImageOnCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: const Color(0xFF4F6F52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Unggah Lagi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (label !=
                    'No match found') // Conditionally show "Lihat Detail" button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      viewDetail(
                        context,
                        label,
                        description,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: const Color(0xFF1A4D2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void viewDetail(BuildContext context, String label, String description,
      String? imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          label: label,
          description: description,
          confidence: confidence,
          imagePath:
              imagePath ?? '', // Use a default value if imagePath is null
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selamat datang di',
              style: TextStyle(
                fontFamily: "Baloo2",
                fontWeight: FontWeight.bold,
                fontSize: 30, // Sesuaikan ukuran font agar responsif
                color: Color(0xFF1A4D2E),
                height: 2,
              ),
            ),
            Text(
              'Plantjake',
              style: TextStyle(
                fontFamily: "Baloo2",
                fontSize: 35, // Sesuaikan ukuran font agar responsif
                color: Color(0xFF1A4D2E),
                height: 1.5,
              ),
            ),
          ],
        ),
        toolbarHeight: 100, // Tinggi AppBar
        centerTitle: true, // Memposisikan judul ke tengah
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          double imageSize =
              screenWidth * 0.7; // Sesuaikan ukuran gambar agar responsif

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: filePath == null
                              ? const DecorationImage(
                                  image: AssetImage('assets/ilustrasi.png'),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(filePath!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Petunjuk Penggunaan:",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A4D2E),
                          fontFamily: "Baloo2",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "1. Klik tombol kamera untuk mengambil gambar.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "2. Klik tombol galeri untuk memilih gambar dari galeri.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "3. Aplikasi akan mendeteksi jenis tanaman dan menampilkan hasilnya.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickImageOnCamera,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F6F52),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05, // Responsif
                                vertical: screenHeight * 0.02, // Responsif
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icon_camera.png',
                                  width: screenWidth * 0.06, // Responsif
                                  height: screenWidth * 0.06, // Responsif
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Buka Kamera',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickImageOnGallery,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A4D2E),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05, // Responsif
                                vertical: screenHeight * 0.02, // Responsif
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icon_upload.png',
                                  width: screenWidth * 0.06, // Responsif
                                  height: screenWidth * 0.06, // Responsif
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Unggah Gambar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
