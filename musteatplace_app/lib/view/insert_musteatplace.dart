import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musteatplace_app/model/musteatplace.dart';
import 'package:geolocator/geolocator.dart';


import '../vm/database_handler.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  late DatabaseHandler handler;
  late double latData; 
  late double longData;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    latData = 0;
    longData = 0;
    handler = DatabaseHandler();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    checkLocationPermission();
  }

    checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
  
  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if(permission == LocationPermission.deniedForever) {
    return;
  }

  if(permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
    getCurrentLocation();
	}
}

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true
    ).then((position) {
      latData = position.latitude;
      longData = position.longitude;

      setState(() {});
    }).catchError((e) {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 추가'),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => getImageFromGallery(ImageSource.gallery),
                    child: const Text('Gallery'),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/6,
                    color: Colors.grey,
                    child: Center(
                      child: imageFile == null
                          ? const Text('Image is not selected!')
                          : Image.file(File(imageFile!.path)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: latController,
                          decoration: const InputDecoration(labelText: '위도'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: lngController,
                          decoration: const InputDecoration(labelText: '경도'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: '이름'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: '전화'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: estimateController,
                      decoration: const InputDecoration(labelText: '평가'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      insertAction();
                      _showDialog();
                    },
                    //()async {
                    //   code = codeController.text;
                    //   name = nameController.text;
                    //   dept = deptController.text;
                    //   phone = phoneController.text;
                        
                    //   Students students = Students(
                    //     code: code,
                    //     name: name,
                    //     dept: dept,
                    //     phone: phone,
                    //   );
                    //   await handler.insertSudents(students);
                    //   // int returnValue = await handler.insertSudents(students);
                    //   // 찍어보자.
                    //   // print(returnValue);
                        
                    //   // if (returnValue != 1) {
                    //   //   // Snack Bar
                    //   // } else {
                    //   //   _showDialog();
                    //   // }
                        
                    // },
                    child: const Text('입력'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Functions ---

  insertAction() async {
    lat = double.parse(latController.text.toString());
    lng = double.parse(lngController.text.toString());
    phone = phoneController.text.toString();
    name = nameController.text.toString();
    phone = phoneController.text.toString();
    estimate = estimateController.text.toString();

    // File Type을 Byte Type으로 변환하기
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var musteatPlace = Musteatplace(
        name: name,
        phone: phone,
        lat: lat,
        lng: lng,
        image: getImage,
        estimate: estimate,
        initdate: DateTime.timestamp().toString());
    await handler.insertMusteatplace(musteatPlace);
  }

  _showDialog() {
    Get.defaultDialog(
      title: '입력 결과',
      middleText: '입력이 완료 되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'))
      ],
    );
  }

  getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile == null;
    } else {
      imageFile = XFile(pickedFile.path);
    }
    setState(() {});
  }
} // End
