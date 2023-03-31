import 'package:flutter/material.dart';
import 'package:dimong/core/domain/dino.dart';
import 'package:provider/provider.dart';
import './logic/usecase.dart';
import './gauge.dart';

class DinoDetail extends StatefulWidget {
  final int id;
  const DinoDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DinoDetailState();
}

class _DinoDetailState extends State<DinoDetail> {
  final DinoDetailUseCase _useCase = DinoDetailUseCase();

  @override
  void initState(){
    super.initState();
    _useCase.loadInfo(widget.id);
  }

  BoxDecoration _getGradientColor(String taste) {
    if (taste == '초식') {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFACC864), Color(0xFFD1EAD7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFCD8476), Color(0x33FFC9BE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
  }

  BoxDecoration _circleGradientColor(String taste) {
    if (taste == '초식') {
      return const BoxDecoration(
        shape: BoxShape.circle,

        gradient: LinearGradient(
          colors: [Color(0x1AFFFFFF), Color(0x99D2DCC4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      return const BoxDecoration(
        shape: BoxShape.circle,

        gradient: LinearGradient(
          colors: [Color(0x1AFFFFFF), Color(0x99E6C0B9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
  }

  BoxDecoration _tasteColor(String taste) {
    if (taste == '초식') {
      return const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF86B049),
      );
    } else {
      return const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFCD8476),
      );
    }
  }

  Widget _detailFeature(String title, String value, String taste) {
    Color color = taste == '초식' ? Color(0xFF476930) : Color(0xFF843627);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13.0,
            color: Color(0xFF7C7C7C),
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _detailPoint(String value, String taste) {
    Color color = taste == '초식' ? Color(0xFF476930) : Color(0xFF843627);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: color,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _dinoName(String value, String taste) {
    Color color = taste == '초식' ? Color(0xFF476930) : Color(0xFF843627);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SendInfoResponse>(
      stream: _useCase.dataStream,
      builder: (context, snapshot) {

        if(snapshot.hasData && _useCase.isLoading == false){
          final data =snapshot.data;
          final showAbility =[
            AbilityData('공격력', data!.dinosaurAggression!.toDouble(), Colors.red),
            AbilityData('지능', data.dinosaurIntellect.toDouble(), Colors.green),
          ];
          print("rendering: $data");
          print(data.runtimeType);
          String? name;
          return Scaffold(
              appBar: AppBar(
                // 뒤로가기 버튼
                // leading: const BackButton(
                //   color: Color(0xFFFFFFFF),
                // ),
                // 뒤로가기 버튼
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: const Color(0xFFFFFFFF),
                  iconSize: 30.0, // 아이콘 크기를 지정함
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              extendBodyBehindAppBar: true,
              body: Center(
                // child:
                // Text(id.toString()),
                // ),
                child: Stack(
                  children: [
                    Container(
                      decoration: _getGradientColor(data!.dinosaurTaste),
                    ),

                    // 하얀색 정보 상자 부분
                    Positioned(
                      top: 235.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              // 공룡 이름
                              Container(
                                padding: EdgeInsets.only(top:80.0,bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _dinoName('${data!.dinosaurName}', data!.dinosaurTaste),
                                    Container(
                                        padding: EdgeInsets.all(6.0),
                                        margin: EdgeInsets.only(left:5.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 10.0,
                                            ),
                                          ],
                                        ),
                                        child:
                                        Text(data!.dinosaurTaste == '초식' ? '🌿' : '🥩',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                          ),)
                                    ),
                                  ],
                                ),
                              ),

                              // tts 재생 아이콘
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    margin: EdgeInsets.only(right:10.0),
                                    decoration: _tasteColor(data!.dinosaurTaste),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.volume_up_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        //${data!.dinosaurAudioUrl}
                                      },
                                    ),
                                  ),
                                  Text('Dino Id : ${widget.id}'),
                                  // Text(id.toString()),
                                ],
                              ),

                              // 공룡 정보
                              Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    //_detailFeature('길이', '7.9m'),
                                    //_detailFeature('무게', '6000kg'),
                                    //_detailFeature('서식지', '북아메리카'),
                                    _detailFeature('길이', '${data!.dinosaurLength}', data!.dinosaurTaste),
                                    _detailFeature('무게', '${data!.dinosaurWeight}', data!.dinosaurTaste),
                                    _detailFeature('서식지', '${data!.dinosaurHabitat}', data!.dinosaurTaste),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _detailFeature('식성', '${data!.dinosaurTaste}', data!.dinosaurTaste),
                                    _detailFeature('별명', '${data!.dinosaurNickname}', data!.dinosaurTaste),
                                    _detailFeature('지질시대', '${data!.geologicAge}', data!.dinosaurTaste),
                                  ],
                                ),
                              ),

                              // 지능, 공격성 정보
                              Container(
                                width: double.infinity, // Set a fixed width or use Expanded
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        child: AbilityGauge(showAbility[0])
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        child: AbilityGauge(showAbility[1]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 공룡 특징
                               Padding(
                                padding:  EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 20.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: _detailPoint('${data.dinosaurCharacteristic!}', data!.dinosaurTaste)),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    // Circular
                    Positioned(
                      top: 100.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 200.0,
                        decoration: _circleGradientColor(data!.dinosaurTaste)
                      ),
                    ),
                    Positioned(
                      top: 100.0,
                      left: 100.0,
                      child: Container(
                        width: 200.0,
                        height: 200.0,
                        child: Image.asset(
                          'assets/images/dino/${data.dinosaurName}.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}

