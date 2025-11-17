import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/screen/HOME_SCREEN/all_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
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
            ),
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
      ),
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

    int days = diff.inDays;
    int hours = diff.inHours;
    int minutes = diff.inMinutes;
    int seconds = diff.inSeconds;
    int milliseconds = diff.inMilliseconds;

    DateTime startDate = _inDate;
    Duration totalDuration = _outDate.difference(startDate);
    Duration elapsed = _realTime.difference(startDate);

    double progress = elapsed.inMilliseconds / totalDuration.inMilliseconds;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;
    return Scaffold(
      appBar: AppBar(title: Text('전역일 계산기'), centerTitle: true,backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: Colors.black.withOpacity(0.4)),
            SizedBox(height: 25),
            Column(
              children: [
                Container(
                  width: 330,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${_realTime.year}'),
                          Text(' 년 '),
                          Text('${_realTime.month}'),
                          Text(' 월 '),
                          Text('${_realTime.day}'),
                          Text(' 일'),

                          Spacer(),
                          Text(
                            '${_realTime.hour}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(' 시 '),
                          Text(
                            '${_realTime.minute}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(' 분 '),
                          Text(
                            '${_realTime.second}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(' 초'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  //height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(5),
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
                      SizedBox(height: 20),
                      Row(children: [Text('내 전역일은')]),
                      Row(
                        children: [
                          Text(
                            '${_outDate.year}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 년 '),
                          Text(
                            '${_outDate.month}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 월 '),
                          Text(
                            '${_outDate.day}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 일'),
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
                ),
                SizedBox(height: 10),

                Container(
                  width: 350,
                  //height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('남은 복무일은'),
                              Spacer(),
                              Text(
                                '${days}',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('남은 시간은'),
                              Spacer(),
                              Text(
                                '${hours} h',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                '${minutes} m',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                '${seconds} s',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                '${milliseconds} ms',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Stack(
                            children: [
                              LinearProgressIndicator(
                                minHeight: 20,
                                backgroundColor: Colors.grey.shade500,
                                color: const Color.fromARGB(255, 80, 80, 80),
                                value: progress,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              Center(
                                child: Text(
                                  '${(progress * 100).toStringAsFixed(7)} %',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                          '입대일 설정하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _showDatePicker();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AllInfoScreen(
                            inDate: _inDate,
                            outDate: _outDate,
                            monthToAdd: monthToAdd,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    '남은 복무일 자세히보기',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}