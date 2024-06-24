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
          ),
        );
      });
    } catch (e) {
      logger.e("Error running model: $e");
      // Handle error
    }
  }

  void showDetectionResult(
      BuildContext context,
      String label,
      String description,
      double confidence,
      Function pickImageOnCamera,
      Function(BuildContext, String, String) viewDetail) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Hasil Deteksi"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${confidence.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
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
                    'Upload Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                    backgroundColor:
                        const Color(0xFF1A4D2E), // Warna latar belakang tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.white, // Warna font
                      fontSize: 16, // Ukuran font
                      fontWeight: FontWeight.bold, // Gaya font
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

  void viewDetail(BuildContext context, String label, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          label: label,
          description: description,
          confidence: confidence,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to PlantJake',
          style: TextStyle(
              fontFamily: "Baloo2",
              fontSize: 40,
              color: Color(0xFF1A4D2E),
              height: 2.0),
        ),
        toolbarHeight: 150, // Tinggi AppBar
        centerTitle: true, // Memposisikan judul ke tengah
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 300,
                  height: 300,
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
                mainAxisAlignment: MainAxisAlignment
                    .center, // Align buttons to the center horizontally
                children: [
                  ElevatedButton(
                    onPressed: pickImageOnCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F6F52),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon_camera.png', // Replace with your image asset path
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Buka Kamera',
                          style: TextStyle(
                            color: Colors.white,
                            //fontFamily: 'Roboto', // Example of using a custom fontFamily
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20), // Add spacing between buttons
                  ElevatedButton(
                    onPressed: pickImageOnGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A4D2E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon_upload.png', // Replace with your image asset path
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Gambar',
                          style: TextStyle(
                            color: Colors.white,
                            //fontFamily:'Roboto', // Example of using a custom fontFamily
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
