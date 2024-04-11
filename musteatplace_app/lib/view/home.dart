import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:musteatplace_app/view/detail_musteatplace.dart';
import 'package:musteatplace_app/view/insert_musteatplace.dart';
import 'package:musteatplace_app/view/update_musteatplace.dart';
import '../vm/database_handler.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // --- Property ---
  late DatabaseHandler handler;

  // --- 초기화 ---
  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 경험한 맛집 리스트'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const InsertPage())!.then((value) => reloadData());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
        future: handler.queryMusteatplace(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => const DetailPage(), arguments: [
                      snapshot.data![index].lat,
                      snapshot.data![index].lng,
                    ]);
                  },
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.green,
                          icon: Icons.edit,
                          label: '수정',
                          onPressed: (context) {
                            Get.to(() => const UpdatePage(), arguments: [
                              snapshot.data![index].name,
                              snapshot.data![index].phone,
                              snapshot.data![index].lat,
                              snapshot.data![index].lng,
                              snapshot.data![index].image,
                              snapshot.data![index].estimate,
                              snapshot.data![index].initdate,
                              snapshot.data![index].seq,
                            ])!
                                .then((value) => reloadData());
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: '삭제',
                          onPressed: (context) async {
                            // selectDelete(snapshot.data![index]);
                            await handler
                                .deleteMusteatplace(snapshot.data![index].seq!);
                            _delshowDialog();
                            reloadData();
                          },
                        ),
                      ],
                    ),
                    child: Card(
                      child: Row(
                        children: [
                          Image.memory(
                            snapshot.data![index].image,
                            width: 100,
                          ),
                          Column(
                            children: [
                              // Text(
                              //     '이것은 위도야 : ${snapshot.data![index].lnt.toString()}'),
                              // Text(
                              //     '이것은 경도야 : ${snapshot.data![index].lng.toString()}'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('명칭 : ${snapshot.data![index].name}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('전화번호 : ${snapshot.data![index].phone}'),
                                ],
                              ),
                              // Text(
                              //     '이것은 평가이야 : ${snapshot.data![index].eatimate}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // --- Functions ---
  reloadData() {
    // FutuerBuilder가 있기 떄문에 이것만 써줘도 OK
    handler.queryMusteatplace();
    setState(() {});
  }

  _delshowDialog() {
    Get.defaultDialog(
      title: '삭제 결과',
      middleText: '삭제가 완료 되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}// End
