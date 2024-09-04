import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/Connect/weather_service.dart';

class ForecastWeather extends StatelessWidget {
  final String city;
  ForecastWeather({
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forecast Weather',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Forecast(city: city),
    );
  }
}

class Forecast extends StatefulWidget {
  final String city;
  Forecast({required this.city});
  @override
  _ForecastScreen createState() => _ForecastScreen();
}

class _ForecastScreen extends State<Forecast>{
  String _city = '';
  String forecastday = '';
  String nhietdotb = '';
  String text_day = '';
  String maxtemp_today = '';
  String mintemp_today = '';
  String uv_day = '';
  String humiditytb = '';
  String maxwind_kph ='';
  String tamnhintb_km = '';
  String totalprecip_mm ='';
  List<Map<String, dynamic>> forecastDayListWT = [];
  Map<String, dynamic> forecastDayListWT_1 = {};
  List<Map<String, dynamic>> listWeather = [];

  void _updateForecastDay(
      String forecastday,
      String nhietdotb,
      String text_day,
      String maxtemp_today,
      String mintemp_today,
      String uv_day,
      String humiditytb,
      String maxwind_kph,
      String tamnhintb_km,
      String totalprecip_mm) {
    setState(() {
      this.forecastday = forecastday;
      this.nhietdotb = nhietdotb;
      this.text_day = text_day;
      this.maxtemp_today = maxtemp_today;
      this.mintemp_today = mintemp_today;
      this.uv_day = uv_day;
      this.humiditytb = humiditytb;
      this.maxwind_kph = maxwind_kph;
      this.tamnhintb_km = tamnhintb_km;
      this.totalprecip_mm = totalprecip_mm;
    });
  }

  @override
  void initState() {
    super.initState();
    _city = widget.city;
    _fetchWeather();
  }

  void _fetchWeather() async{
    setState(() {
      listWeather.clear();
    });

    if (_city.isEmpty) {
      return;
    }

    List<Map<String, dynamic>> weatherData = await fetchWeather(_city);

    setState(() {
      listWeather = weatherData;
      if (listWeather.isNotEmpty) {
        final _forecasDaytListWT = listWeather[0]['forecastDayList'];
        final _forecasDaytListWT_1 = listWeather[0]['forecastDayList'][0];

        forecastDayListWT = _forecasDaytListWT;
        forecastDayListWT_1 = _forecasDaytListWT_1;

        final forecastday_ = forecastDayListWT_1['forecasttoday'];
        final nhietdotb_ = forecastDayListWT_1['forecastDayList_day'][0]['nhietdotb'];
        final text_day_ = forecastDayListWT_1['forecastDayList_day'][0]['text_day'];
        final maxtemp_today_ = forecastDayListWT_1['forecastDayList_day'][0]['maxtemp_today'];
        final mintemp_today_ = forecastDayListWT_1['forecastDayList_day'][0]['mintemp_today'];
        final uv_day_ = forecastDayListWT_1['forecastDayList_day'][0]['uv_day'];
        final humiditytb_ = forecastDayListWT_1['forecastDayList_day'][0]['humiditytb'];
        final maxwind_kph_ = forecastDayListWT_1['forecastDayList_day'][0]['maxwind_kph'];
        final tamnhintb_km_ = forecastDayListWT_1['forecastDayList_day'][0]['tamnhintb_km'];
        final totalprecip_mm_ = forecastDayListWT_1['forecastDayList_day'][0]['totalprecip_mm'];

        forecastday = forecastday_;
        nhietdotb = nhietdotb_;
        text_day = text_day_;
        maxtemp_today= maxtemp_today_;
        mintemp_today = mintemp_today_;
        uv_day = uv_day_;
        humiditytb = humiditytb_;
        maxwind_kph = maxwind_kph_;
        tamnhintb_km = tamnhintb_km_;
        totalprecip_mm = totalprecip_mm_;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            _city,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastDayListWT.length,
                  itemBuilder:  (context, index) {
                    final item = forecastDayListWT[index];

                    final day = item['forecasttoday'];
                    final _maxtemp_today = item['forecastDayList_day'][0]['maxtemp_today'];
                    final _mintemp_today = item['forecastDayList_day'][0]['mintemp_today'];
                    final icon_today = item['forecastDayList_day'][0]['icon_today'];

                      return
                        GestureDetector(
                            onTap: () {
                              for (int i = 0; i <
                                  forecastDayListWT.length; i++) {
                                final item_i = forecastDayListWT[i];
                                final forecasttoday_ = item_i['forecasttoday'];

                                if(forecasttoday_ == day){
                                  final ngay = item_i['forecasttoday'].toString();
                                  final nhietdotb_ = item_i['forecastDayList_day'][0]['nhietdotb'];
                                  final text_day_ = item_i['forecastDayList_day'][0]['text_day'];
                                  final maxtemp_today_ = item_i['forecastDayList_day'][0]['maxtemp_today'];
                                  final mintemp_today_ = item_i['forecastDayList_day'][0]['mintemp_today'];
                                  final uv_day_ = item_i['forecastDayList_day'][0]['uv_day'];
                                  final humiditytb_ = item_i['forecastDayList_day'][0]['humiditytb'];
                                  final maxwind_kph_ = item_i['forecastDayList_day'][0]['maxwind_kph'];
                                  final tamnhintb_km_ = item_i['forecastDayList_day'][0]['tamnhintb_km'];
                                  final totalprecip_mm_ = item_i['forecastDayList_day'][0]['totalprecip_mm'];
                                  _updateForecastDay(ngay, nhietdotb_, text_day_, maxtemp_today_, mintemp_today_, uv_day_, humiditytb_, maxwind_kph_, tamnhintb_km_, totalprecip_mm_);
                                  break;
                                }
                              };
                            },
                          child:_DayWeatherItem(day, _maxtemp_today, _mintemp_today, icon_today),
                      );
                  }
              ),
            ),
            SizedBox(height: 20),
            _GetForecastDay(forecastday, nhietdotb, text_day, maxtemp_today, mintemp_today, uv_day, humiditytb, maxwind_kph, tamnhintb_km, totalprecip_mm)
          ],
        ),
        ),

      ),
    );
  }

}

Widget _GetForecastDay(String forecastday,String nhietdotb, String text_day, String maxtemp_today, String mintemp_today,
    String uv_day,String humiditytb, String maxwind_kph, String tamnhintb_km, String totalprecip_mm){
  String displayDay;
  if(forecastday == 'Hôm nay'){
    displayDay = forecastday;
  } else {
    final parts = forecastday.split('/');
    if (parts.length == 2) {
      final day = parts[0];
      final month = parts[1];
      displayDay = '$day tháng $month';
    } else {
      displayDay = '';
    }
  }
  if (forecastday.isEmpty) {
    return Center(
      child: Text(''),
    );
  }
  return Container(
    // color: Colors.red,
    padding: EdgeInsets.only(bottom: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Ngày $displayDay',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
          Text(
            'Nhiệt độ trung bình $nhietdotb °',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        // ),
        SizedBox(height: 5),
        Container(
          width: 200, // Đặt chiều rộng tối đa mong muốn
          child: Center(
            child: Text(
              text_day,
              textAlign: TextAlign.center, // Căn giữa văn bản
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Nhiệt độ cao nhất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$maxtemp_today °', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Divider(
                // Đường thẳng ngang
                color: Colors.grey,
                height: 3,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Nhiệt độ thấp nhất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$mintemp_today °', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

            ],
          ),
        ),

        SizedBox(height: 5),

        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('UV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text(uv_day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5),

        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Độ ẩm trung bình', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$humiditytb %', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5),

        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Tốc độ gió', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$maxwind_kph km/h', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5),

        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Tầm nhìn trung bình', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$tamnhintb_km km', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5),

        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Color(0x70A5B9F0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Lượng mưa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Text('$totalprecip_mm mm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    ),
  );

}


Widget _DayWeatherItem(String day, String maxtemp_today, String mintemp_today, String icon_today){
  return Container(
    width: 110,
    // height: 150,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Color(0x90D9D9D9),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 15, color: Colors.black)),
        SizedBox(height: 5),
        Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFA5B9F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text('$maxtemp_today°', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),
                  SizedBox(height: 8),
                  Image.network(
                    icon_today,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 8),
                  Text('$mintemp_today°', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)),

                ],
              ),
            ),

        ),
      ],
    ),
  );

}