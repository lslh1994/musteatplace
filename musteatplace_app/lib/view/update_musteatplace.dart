import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musteatplace_app/model/musteatplace.dart';
import 'package:musteatplace_app/vm/database_handler.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late DatabaseHandler handler;
  late String name;
  late String phone;
  late double lat;
  late double lng;
  late String estimate;
  late Uint8List image;
  late bool checkpushbutton;
  late int seq;

  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;

  XFile? imageFile; //갤러리 사진 가져오는 것
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    latController = TextEditingController();
    lngController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();

    var value = Get.arguments ?? '__';
    nameController.text = value[0];
    phoneController.text = value[1];
    latController.text = value[2].toString();
    lngController.text = value[3].toString();
    image = value[4];
    estimateController.text = value[5];

    name = '';
    phone = '';
    lat = 0;
    lng = 0;
    estimate = '';

    seq = value[7];
    checkpushbutton = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('맛집 수정'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    checkpushbutton = true;
                    getImageFromGallery(ImageSource.gallery);
                  },
                  child: const Text('Gallery')),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.grey,
                child: Center(
                  child: imageFile == null
                      //갤러리 누름면 아까처럼 변환해서 쓰면되고 아니면 메모리에 있는 사진을 가져다 쓰면 되서 입력 버튼에 삼항연산자 필요!
                      ? Image.memory(image)
                      : Image.file(File(imageFile!.path) //null들어갈수도 있어서 ! 붙임
                          ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: latController,
                      decoration: const InputDecoration(labelText: '위도 입력 하세요'),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: lngController,
                      decoration: const InputDecoration(labelText: '경도 입력 하세요'),
                      keyboardType: TextInputType.number,
                      readOnly: true,
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
                onPressed: () async {
                  updateAction();
                },
                child: const Text('수정'),
              ),
            ],
          ),
        ));
  }

  // --- Functions ---
  updateAction() async {
    lat = double.parse(latController.text);
    lng = double.parse(lngController.text);
    phone = phoneController.text;
    name = nameController.text;
    estimate = estimateController.text;

    if (imageFile != null) {
      File newImageFile = File(imageFile!.path);
      image = await newImageFile.readAsBytes();
    }
    var musteatplace = Musteatplace(
        name: name,
        phone: phone,
        lat: lat,
        lng: lng,
        image: image,
        estimate: estimate,
        initdate: DateTime.now().toString(),
        );
    _showDialog(musteatplace);
  }

  

  _showDialog(musteatPlace) {
    Get.defaultDialog(
      title: '수정 결과',
      middleText: '수정이 완료 되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: musteatPlace);
            Get.back(result: musteatPlace);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      setState(() {
      imageFile = pickedFile;
      image = File(imageFile!.path).readAsBytesSync();
    });
    }
  }
} // End