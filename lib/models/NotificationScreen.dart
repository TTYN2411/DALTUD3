// import 'dart:core';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:untitled/models/ForecastWeather.dart';
// import 'package:untitled/models/main.dart';
import 'package:untitled/Connect/weather_service.dart';
import 'package:get/get.dart';


import 'ListWeather.dart';


class NotificationScreen extends StatelessWidget {

  final String city;
  NotificationScreen({
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Screen',
      theme: ThemeData(
      ),
    home: Notification(city: city),
    );
  }
}

// class CityController extends GetxController {
//   RxString selectedCity = ''.obs;
//
//   void setSelectedCity(String city) {
//     selectedCity.value = city;
//   }
//
//   bool isCityInList(List<String> cities) {
//     return cities.contains(selectedCity.value);
//   }
// }


class Notification extends StatefulWidget {
  final String city;
  Notification({required this.city});
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<Notification> {
  String _city = '';
  String temp = '',
      description = '',
      maxTemp = '', minTemp = '',
      Uv = '', humidity = '', feelsLike = '',
      tamnhin_km = '', wind_kph = '',
      tocdowind_kph = '', apsuat_mb = '',
      precip_mm = '', totalprecip_mm = '',
      tamnhintb_km = '', textUv ='', sunrise = '', sunset ='', moonrise='', moon_illumination ='';

  // final CityController cityController = Get.put(CityController());
  List<Map<String, dynamic>> forecastListWT = [];
  List<Map<String, dynamic>> listWeather = [];


  @override
  void initState() {
    super.initState();
    _city = widget.city;
    _fetchWeather();
  }

  void _fetchWeather() async{
    setState(() {
      listWeather.clear();
      forecastListWT.clear();
    });

    if (_city.isEmpty) {
      return;
    }

    List<Map<String, dynamic>> weatherData = await fetchWeather(_city);


    setState(() {
      listWeather = weatherData;
      //Lấy nhiệt độ của thành phố đầu tiên (nếu có dữ liệu)
      if (listWeather.isNotEmpty) {
        final _temp = listWeather[0]['temp_c'].toString();
        final _description = listWeather[0]['text'].toString();
        final _maxTemp =  listWeather[0]['forecastMaxtemp'].toString();
        final _minTemp =  listWeather[0]['forecastMintemp'].toString();
        final _uv = listWeather[0]['forecastUv'].toString();
        final _textUv = listWeather[0]['textUv'].toString();
        final _feelsLike = listWeather[0]['forecastFeelsL'].toString();
        final _humidity =  listWeather[0]['forecastHumidity'].toString();
        final _forecastListWT = listWeather[0]['forecastList'];


        final _tamnhin_km = listWeather[0]['forecastList'][0]['tamnhin_km'];
        final _wind_kph = listWeather[0]['forecastList'][0]['wind_kph'];
        final _tocdowind_kph = listWeather[0]['forecastList'][0]['tocdowind_kph'];
        final _apsuat_mb = listWeather[0]['forecastList'][0]['apsuat_mb'];
        final _precip_mm = listWeather[0]['forecastList'][0]['precip_mm'];
        final _totalprecip_mm = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['totalprecip_mm'];
        final _tamnhintb_km = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['tamnhintb_km'];
        final _sunrise = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['sunrise'];
        final _sunset = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['sunset'];
        final _moonrise = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['moonrise'];
        final _moon_illumination = listWeather[0]['forecastDayList'][0]['forecastDayList_day'][0]['moon_illumination'];




        sunrise = _sunrise;
        sunset = _sunset;
        moonrise = _moonrise;
        moon_illumination = _moon_illumination;
        textUv = _textUv;
        forecastListWT = _forecastListWT;
        temp = _temp;
        description = _description;
        maxTemp = _maxTemp;
        minTemp = _minTemp;
        Uv = _uv;
        humidity = _humidity;
        feelsLike = _feelsLike;
        tamnhin_km = _tamnhin_km;
        wind_kph = _wind_kph;
        tocdowind_kph = _tocdowind_kph;
        apsuat_mb = _apsuat_mb;
        precip_mm = _precip_mm;
        totalprecip_mm = _totalprecip_mm;
        tamnhintb_km = _tamnhintb_km;

      }
    });



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFA5B9F0), // Màu nền cho nút 'Thêm'
                // primary: Colors.white, // Màu chữ cho nút 'Thêm'
                minimumSize: Size(100, 50), // Kích thước hình vuông
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bo tròn góc
                ),
              ),
              onPressed: () {
                Get.offAll(() => ListWeather(city: widget.city), transition: Transition.rightToLeft);
              },
              child: Text(
                'Thêm',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '$_city',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 0.0, right: 00.0, bottom: 0.0),
                child: Text(
                  '$temp°',
                  style: TextStyle(fontSize: 90, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 200, // Đặt chiều rộng tối đa mong muốn
                child: Center(
                  child: Text(
                    '$description',
                    textAlign: TextAlign.center, // Căn giữa văn bản
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Text(
                'C:$maxTemp°  T:$minTemp°',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rain Probability
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100, // Đặt chiều rộng cố định
                        child: Text(
                          'Độ ẩm',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 66,
                        height: 66,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/humidity.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.0),
                      Text('$humidity %'),
                    ],
                  ),
                  // Humidity
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100, // Đặt chiều rộng cố định
                        child: Text(
                          'UV',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 66,
                        height: 66,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/uv.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text('$Uv'),
                    ],
                  ),

                  // Feels Like
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SizedBox(
                        width: 100, // Đặt chiều rộng cố định
                        child: Text(
                          'Cảm nhận',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 66,
                        height: 66,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/feelsLike.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.0),
                      Text('$feelsLike°'),
                    ],
                  ),


                ],
              ),

              SizedBox(height: 20),

              //Horizontal ListView
              Container(
                height: 150, // Chiều cao của ListView ngang
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastListWT.length,
                  itemBuilder: (context, index) {

                    final forecast = forecastListWT[index];

                    // Kiểm tra null trước khi sử dụng toán tử dấu chấm than
                    final time = forecast['forecastHour_'];
                    final iconUrl = forecast['forecastIcon_'];
                    final temperature = forecast['forecastTemp_'];

                    // In ra giá trị của time, iconUrl và temperature
                    // print('Time: $time, Icon URL: $iconUrl, Temperature: $temperature');

                    if (time != null && iconUrl != null && temperature != null) {
                      return _buildWeatherItem(
                        time,
                        iconUrl,
                        temperature,
                      );

                    } else { print('Không tải được dữ liệu trang thông báo'); // Hoặc xử lý lỗi theo cách khác nếu cần thiết
                    }
                  },
                )
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFA5B9F0), // Màu nền
                    // primary: Colors.white, // Màu chữ cho nút 'Thêm'
                    minimumSize: Size(350, 50), // Kích thước hình vuông
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => ForecastWeather(city: _city), transition: Transition.rightToLeft);
                  },
                   child: Text(
                    'Dự báo 7 ngày',
                    style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  )
              ),
              // SizedBox(height: 10),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2, // Số cột trong grid
                mainAxisSpacing: 10, // Khoảng cách giữa các dòng
                crossAxisSpacing: 10, // Khoảng cách giữa các cột
                padding: EdgeInsets.all(16), // Padding cho GridView
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.visibility, color: Colors.black54,), // Icon con mắt
                            SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
                            Text('TẦM NHÌN', style: TextStyle(fontSize: 14)),


                          ],
                        ),
                        SizedBox(height: 15,),
                        Container(
                          child: Center(
                            child: Text('$tamnhin_km km', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 0,),
                        Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Trung bình', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                Text('$tamnhintb_km km', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              ],),
                          ),
                        ),

                      ],

                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.air, color: Colors.black54,),
                            SizedBox(width: 8),
                            Text('GIÓ', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 30),
                          // color: Colors.brown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(wind_kph, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('km/h', style: TextStyle(fontSize: 15)),
                                    Text('Gió', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          // Đường thẳng ngang
                          color: Colors.grey,
                          height: 3,
                          thickness: 1,
                        ),
                        Container(
                          // color: Colors.white,
                          padding: EdgeInsets.only(left: 25, right: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tocdowind_kph, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('km/h', style: TextStyle(fontSize: 15)),
                                  Text('Gió giật', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                ],
                              ),

                            ],
                          ),

                        ),

                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.water_drop, color: Colors.black54,),
                            SizedBox(width: 8),
                            Text('LƯỢNG MƯA', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Container(
                          child:
                          Text('$precip_mm mm', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 0,),
                        Divider(
                          // Đường thẳng ngang
                          color: Colors.grey,
                          height: 3,
                          thickness: 1,
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text('Trung bình', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Text('$totalprecip_mm mm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ],
                          ),

                        ),


                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.speed, color: Colors.black54,),
                            SizedBox(width: 8),
                            Text('ÁP SUẤT', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 15,),

                        Container(
                          // color: Colors.red,
                          height: 80,
                          child: Column(
                            children: [
                              Text('$apsuat_mb', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5,),
                              Text('hPa', style: TextStyle(fontSize: 16)),

                            ],
                          ),


                        ),

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sunny, color: Colors.black54,),
                            SizedBox(width: 8),
                            Text('CHỈ SỐ UV', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 15,),

                        Container(
                          // color: Colors.red,
                          height: 80,
                          child: Column(
                            children: [
                              Text('$Uv', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10,),
                              Text('$textUv', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0x70A5B9F0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sunny_snowing, color: Colors.black54,),
                            SizedBox(width: 8),
                            Text('MẶT TRỜI MỌC', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 5,),

                        Container(
                          height: 80,
                          child: Column(
                            children: [
                              Container(
                                child: Text('$sunrise', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                              ),
                              Divider(
                                // Đường thẳng ngang
                                color: Colors.grey,
                                height: 3,
                                thickness: 1,
                              ),
                              Container(
                                width: 100,
                                child: Column(
                                  children: [
                                    Text('Mặt trời lặn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    Text('$sunset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
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
                          child: Text('Trăng mọc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 40),
                          child: Text(moonrise, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                          child: Text('Chiếu sáng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 40),
                          child: Text('$moon_illumination %', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildWeatherItem(String time, String iconUrl, String temperature) {
  return Container(
    width: 80,
    // Chiều rộng của mỗi mục
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Color(0x80A5B9F0),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Image.network(
          iconUrl,
          width: 50,
          height: 50,
        ),
        SizedBox(height: 8),
        Text('$temperature°', style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}



