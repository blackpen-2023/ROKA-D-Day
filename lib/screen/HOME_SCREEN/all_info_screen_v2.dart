import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class AllInfoScreenV2 extends StatefulWidget {
  const AllInfoScreenV2({
    super.key,
    required this.inDate,
    required this.outDate,
    required this.monthToAdd,
  });

  final DateTime inDate;
  final DateTime outDate;
  final int monthToAdd; // 공군이 기본값임

  @override
  State<AllInfoScreenV2> createState() => _AllInfoScreenV2State();
}

class _AllInfoScreenV2State extends State<AllInfoScreenV2> {
  late DateTime _realTime;
  late Timer _timer;
  int get weekends => countWeekendsFast(widget.inDate, widget.outDate);

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

  int countWeekendsFast(DateTime start, DateTime end) {
    // 날짜 순서 보정
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    // 총 일수
    final totalDays = end.difference(start).inDays;
    if (totalDays <= 0) return 0;

    // 전체 주(7일) 단위로 몇 주인지 계산
    final fullWeeks = totalDays ~/ 7;
    int weekendCount = fullWeeks * 2; // 주당 주말은 2일

    // 남은 일수 계산
    final remainingDays = totalDays % 7;
    final startWeekday = start.weekday; // 1=월 ~ 7=일

    // 남은 날짜 중 주말 포함 여부 계산
    for (int i = 0; i < remainingDays; i++) {
      int weekday = (startWeekday + i - 1) % 7 + 1;
      if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
        weekendCount++;
      }
    }

    return weekendCount;
  }

  @override
  Widget build(BuildContext context) {
    Duration diff = widget.outDate.difference(_realTime);

    int days = diff.inDays;
    int hours = diff.inHours;
    int minutes = diff.inMinutes;
    int seconds = diff.inSeconds;
    int milliseconds = diff.inMilliseconds;

    DateTime startDate = widget.inDate;
    Duration totalDuration = widget.outDate.difference(startDate);
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
  ),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1),
            SizedBox(height: 40),

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Row(children: [Text('내 입대일은')]),
                      Row(
                        children: [
                          Text(
                            '${widget.inDate.year}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 년 '),
                          Text(
                            '${widget.inDate.month}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 월 '),
                          Text(
                            '${widget.inDate.day}',
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
                            '${widget.outDate.year}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 년 '),
                          Text(
                            '${widget.outDate.month}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(' 월 '),
                          Text(
                            '${widget.outDate.day}',
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
                  //height: 200,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                    ),
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
                                color: const Color.fromARGB(
                                  255,
                                  80,
                                  80,
                                  80,
                                ),
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
              ],
            ),
            Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: 350,
                  //height: 200,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('남은 주말', style: TextStyle(fontSize: 14)),
                          Text(
                            '${weekends} 일',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('남은 주중일', style: TextStyle(fontSize: 14)),
                          Text(
                            '${days - weekends} 일',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('남은 일과시간', style: TextStyle(fontSize: 14)),
                          Text(
                            '${(days - weekends) * 8} 시간',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '남은 개인신변정리시간',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${(days - weekends) * 3} 시간',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('남은 취침시간', style: TextStyle(fontSize: 14)),
                          Text(
                            '${(((days - weekends) * 8.5) + ((weekends) * 9))} 시간',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('남은 식사', style: TextStyle(fontSize: 14)),
                          Text(
                            '${(((days - weekends) * 3) + ((weekends) * 2))} 끼',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.2),
                      ),
            
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '이등병 ${widget.inDate.year}년 ${widget.inDate.month}월 ${widget.inDate.day}일',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${widget.inDate.difference(_realTime).inDays} 일 남음',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '일등병 ${DateTime(widget.inDate.year, widget.inDate.month + 2, widget.inDate.day).year}년 ${DateTime(widget.inDate.year, widget.inDate.month + 2, widget.inDate.day).month}월 ${DateTime(widget.inDate.year, widget.inDate.month + 2, widget.inDate.day).day}일',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${DateTime(widget.inDate.year, widget.inDate.month + 2, widget.inDate.day).difference(_realTime).inDays} 일 남음',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '상등병 ${DateTime(widget.inDate.year, widget.inDate.month + 8, widget.inDate.day).year}년 ${DateTime(widget.inDate.year, widget.inDate.month + 8, widget.inDate.day).month}월 ${DateTime(widget.inDate.year, widget.inDate.month + 8, widget.inDate.day).day}일',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${DateTime(widget.inDate.year, widget.inDate.month + 8, widget.inDate.day).difference(_realTime).inDays} 일 남음',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '병장 ${DateTime(widget.inDate.year, widget.inDate.month + 14, widget.inDate.day).year}년 ${DateTime(widget.inDate.year, widget.inDate.month + 14, widget.inDate.day).month}월 ${DateTime(widget.inDate.year, widget.inDate.month + 14, widget.inDate.day).day}일',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${DateTime(widget.inDate.year, widget.inDate.month + 14, widget.inDate.day).difference(_realTime).inDays} 일 남음',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),SizedBox(height: 10),
                Text("© 2025 BAE GYUMIN.",style: TextStyle(fontSize: 10,color: Colors.grey.shade600),),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}