import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:questo_ai/api_setup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String? selectedAnswer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Questo AI - Prototype"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                pickImageFromGallery();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Pick an Image",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    fit: BoxFit.contain,
                    width: 250,
                  )
                : const Text("Please select an Image"),
            const SizedBox(
              height: 20,
            ),
            _selectedImage != null
                ? TextButton(
                    onPressed: () async {
                      if (_selectedImage != null) {
                        selectedAnswer = await askAI();
                        setState(() {});
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Get Questions",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const Text("Pick An Image First"),
            const SizedBox(
              height: 25,
            ),
            selectedAnswer != null
                ? Container(
                    color: Colors.blue,
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Expanded(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(selectedAnswer!),
                    )),
                  )
                : const Text("Click on Generate Questions"),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future askAI() async {
    final imageAsBytes = await _selectedImage!.readAsBytes();
    final prompt = TextPart(
        "Consider this image as a snapshot from a textbook or notebook that a teacher has given. Based on the content generate 5 questions which is very important in the content");
    final imagePart = [DataPart('image/jpeg', imageAsBytes)];
    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);
    return response.text;
  }
}
