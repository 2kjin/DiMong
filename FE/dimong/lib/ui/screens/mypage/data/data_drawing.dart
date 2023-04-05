import 'package:dimong/core/domain/dino.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dimong/core/api/api.dart';
import 'package:dimong/core/utils/api_routes.dart';
import 'package:dimong/core/local_storage/secure_storage.dart';

class MyDrawingApiClient {
  final dio = DataServerDio.instance();
  SecureStorage _secureStorage = SecureStorage();
  Future<DrawingDetailResponse> sendDrawing(int? drawingId) async {
    try {
      //String dinosaurEra = period!;
      //print("period: $period");
      //final userId = await _secureStorage.getUserId();
      final userId =1;
      final response = await dio.get(Paths.myDrawingDetail + '$drawingId',
          data:{
            "userId": userId,
            "drawingId": drawingId,
          });
      print("data.dart: response = $response");
      print(response.runtimeType);
      print("data.dart: response.data = ${response.data}");
      final dinosaursJson =  response.data;
      print(dinosaursJson);
      final drawingDetailResponse = DrawingDetailResponse.fromJson(dinosaursJson);
      print(drawingDetailResponse.runtimeType);
      return drawingDetailResponse;
    } catch (e) {
      // Handle the error as needed
      throw e;
    }
  }

}