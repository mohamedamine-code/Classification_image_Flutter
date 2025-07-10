import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(AnimalClassifierApp());
}

class AnimalClassifierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat/Dog Classifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClassificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ClassificationScreen extends StatefulWidget {
  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  
  File? _image;
  String _prediction = '';
  double _confidence = 0.0;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = '';
      });
      // TODO: Add your classification logic here
      // _classifyImage(_image!);
    }
  }

  // Placeholder for classification function
  void _classifyImage(File image) {
    // Replace with actual TFLite classification
    setState(() {
      _prediction = _image!.path.contains('dog') ? 'Dog' : 'Cat'; // Mock logic
      _confidence = 0.92; // Mock confidence
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐱 vs 🐶 Classifier'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Preview Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: _image == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 60, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'No image selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),

            SizedBox(height: 30),

            // Prediction Result
            if (_prediction.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _prediction == 'Dog'
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _prediction == 'Dog'
                          ? Icons.pets
                          : Icons.catching_pokemon,
                      color: _prediction == 'Dog' ? Colors.blue : Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$_prediction (${(_confidence * 100).toStringAsFixed(1)}% confident)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _prediction == 'Dog'
                            ? Colors.blue
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 40),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Icon(Icons.camera_alt),
                  backgroundColor: Colors.blue,
                ),
                FloatingActionButton(
                  heroTag: 'gallery',
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Icon(Icons.photo_library),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),

      // Classify Button (only shows when image is selected)
      floatingActionButton: _image != null
          ? FloatingActionButton.extended(
              onPressed: () => _classifyImage(_image!),
              icon: Icon(Icons.search),
              label: Text('Classify'),
              backgroundColor: Colors.purple,
            )
          : null,
    );
  }
}
