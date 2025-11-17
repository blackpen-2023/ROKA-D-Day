import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/screen/HOME_SCREEN/all_info_screen.dart';
import 'package:myapp/screen/HOME_SCREEN/all_info_screen_v2.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  late DateTime _realTime;
  late Timer _timer;
  DateTime _inDate = DateTime.now();
  DateTime _outDate = DateTime.now();
  int monthToAdd = 21; // 공군이 기본값임
  int selectedIndex = 0; // 공군이 기본값임 0:공군 1:육군 2:해군

  @override
  void initState() {
    super.initState();
    _realTime = DateTime.now();
    _timer = Timer.periodic(
      const Duration(milliseconds: 16), // 16밀리초마다 갱신 -> ms변화율 보려고
      (Timer t) {
        setState(() {
          _realTime = DateTime.now();
        });
      },
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration diff = _outDate.difference(_realTime);


    DateTime startDate = _inDate;
    Duration totalDuration = _outDate.difference(startDate);
    Duration elapsed = _realTime.difference(startDate);

    double progress = elapsed.inMilliseconds / totalDuration.inMilliseconds;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;
    return Scaffold(
appBar: AppBar(title: Text('전역일 계산기'), centerTitle: true,surfaceTintColor: Colors.white,bottom: PreferredSize(
    preferredSize: Size.fromHeight(1.0),
    child: Container(
      color: Colors.grey.shade500,  // 선 색
      height: 0.5,         // 선 두께
    ),
  ),),      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1),
            SizedBox(height: 25),
            Column(
              children: [

                SizedBox(height: 10),
                Container(
                  width: 350,
                  //height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('내 입대일은'),
                          
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${_inDate.year}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 년 '),
                          Text(
                            '${_inDate.month}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 월 '),
                          Text(
                            '${_inDate.day}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 일'),
                        ],
                      ),
                      Column(
                        children: [
                          /*SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CupertinoButton(
                                  child: const Text('완료'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ), */
                          SizedBox(
                            height: 250,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: _inDate,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  _inDate = DateTime(
                                    newDate.year,
                                    newDate.month,
                                    newDate.day,
                                    23,
                                    59,
                                    59,
                                  );
                                  DateTime tempDate = DateTime(
                                    _inDate.year + ((_inDate.month + monthToAdd - 1) ~/ 12),
                                    ((_inDate.month + monthToAdd - 1) % 12) + 1,
                                    _inDate.day,
                                  );
                                  _outDate = tempDate.subtract(Duration(days: 1));
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                
                    ],
                  ),
                ),
                SizedBox(height: 10),
Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: Colors.white,
                        color: Color.fromARGB(255, 40, 40, 40),
                        fillColor: Color.fromARGB(255, 40, 40, 40),
                        splashColor: Colors.grey.shade400,
                        borderColor: Colors.grey,
                        selectedBorderColor: Color.fromARGB(255, 40, 40, 40),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 44),
                            child: Text("공군"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 44),
                            child: Text("육군"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 44),
                            child: Text("해군"),
                          ),
                        ],
                        isSelected: List.generate(
                          3,
                          (index) => index == selectedIndex,
                        ),
                        onPressed: (int index) {
                          setState(() {
                            selectedIndex = index;
                            switch (selectedIndex) {
                              case 0: // 공군일때
                                monthToAdd = 21;
                                DateTime tempDate = DateTime(
                                  _inDate.year +
                                      ((_inDate.month + monthToAdd - 1) ~/
                                          12), // 12개월(1년)을 초과한 만큼 연도를 추가함
                                  ((_inDate.month + monthToAdd - 1) % 12) +
                                      1, // 더해진 달이 12를 넘을 경우 올해의 해당 월로 변환
                                  _inDate.day,
                                );
                                _outDate = tempDate.subtract(Duration(days: 1));
                                break;
                              case 1: // 육군일때
                                monthToAdd = 18;
                                DateTime tempDate = DateTime(
                                  _inDate.year +
                                      ((_inDate.month + monthToAdd - 1) ~/ 12),
                                  ((_inDate.month + monthToAdd - 1) % 12) + 1,
                                  _inDate.day,
                                );
                                _outDate = tempDate.subtract(Duration(days: 1));
                                break;
                              case 2: // 해군일때
                                monthToAdd = 20;
                                DateTime tempDate = DateTime(
                                  _inDate.year +
                                      ((_inDate.month + monthToAdd - 1) ~/ 12),
                                  ((_inDate.month + monthToAdd - 1) % 12) + 1,
                                  _inDate.day,
                                );
                                _outDate = tempDate.subtract(Duration(days: 1));
                                break;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),                SizedBox(height: 50),

                GestureDetector(
                  child: Container(
                    width: 350,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 40, 40, 40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '전역일 계산하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                  
                    DateTime tempDate = DateTime(
                      _inDate.year + ((_inDate.month + monthToAdd - 1) ~/ 12),
                      ((_inDate.month + monthToAdd - 1) % 12) + 1,
                      _inDate.day,
                    );
                    _outDate = tempDate.subtract(Duration(days: 1));
                  });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AllInfoScreenV2(
                            inDate: _inDate,
                            outDate: _outDate,
                            monthToAdd: monthToAdd,
                          );
                        },
                      ),
                    );
                  },
                ), SizedBox(height: 10),
                Text("© 2025 BAE GYUMIN.",style: TextStyle(fontSize: 10,color: Colors.grey.shade600),),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}