import 'package:image_picker/image_picker.dart';

Future pickImageFromGallery() async {
  final selectedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return selectedImage;
}
