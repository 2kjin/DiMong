import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import './logic/usecase_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../mypage/widgets/mypage_slider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:dimong/core/domain/dino.dart';
import './delete_modal.dart';

class MyImagePage extends StatefulWidget{
  final int drawingId;
  const MyImagePage({Key? key, required this.drawingId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage> {
  final GlobalKey _screenshotKey = GlobalKey();
  final ImageUseCase _useCase = ImageUseCase();
  final _controller = ScreenshotController();

  @override
  void initState(){
    super.initState();
    _useCase.loadData(widget.drawingId);
  }
  void _showModal(int id) async {
    await showCupertinoModalPopup(
        context: context, builder: (context) => DeleteModal(id: id),);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DrawingDetailResponse>(
        stream: _useCase.dataStream,
        builder: (context, snapshot){
          if(snapshot.hasData && _useCase.isLoading == false){
            final data = snapshot.data;
            return Screenshot(
                controller: _controller,
                key: _screenshotKey,
                child: SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      // 뒤로가기 버튼
                      leading: const BackButton(
                        color: Color(0xFFACC864),
                        // style: ButtonStyle(iconSize: ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: [
                        TextButton(
                            child: Text('공유하기',
                              style: TextStyle(
                                color: Color(0xffACC864),
                                fontSize: 25, fontWeight: FontWeight.bold)),
                            onPressed: () async{
                              print('111');
                              await shareScreenshot();
                            }),
                      ],
                    ),
                    body: Column(children: [
                      SizedBox(height: 10,),
                      Text("이 공룡들과 비슷해요!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),),
                      MypageCard(dinos: data!.similarList!),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 300,
                        child: Stack(
                          children:[
                            Container(height: 300, child: CachedNetworkImage(
                            imageUrl: data.drawingImageUrl!,
                            fit: BoxFit.cover,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                          ),
                            Positioned(
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete_forever_rounded,
                                        color: Color(0x99000000)
                                    ),iconSize: 40,
                                    onPressed: () async {
                                      _showModal(data.drawingId!);
                                      print("지우기 1단계");

                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*SizedBox(
                          height:20
                      ),
                      Container(child: Text('${data.userNickname}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),))*/
                    ]),

                  ),
                )
            );
          }
          else
          {
            return Container();
          }
        }
    );
  }
  Future<void> shareScreenshot() async {
    final directory = await getExternalStorageDirectory();
    final imagePath = '${directory!.path}/image.png';
    final file = File(imagePath);

    try {
      // Capture the screenshot
      final Uint8List? capturedImage = await _controller.capture(delay: Duration(milliseconds: 500));
      print(capturedImage);
      // Write the captured image data to a file
      await file.writeAsBytes(capturedImage!);

      // Share the screenshot
      await FlutterShare.shareFile(
        title: 'Share Screenshot',
        filePath: file.path,
        fileType: 'image/png',
      );
    } catch (e) {
      print('Error sharing screenshot: $e');
    }
  }
}