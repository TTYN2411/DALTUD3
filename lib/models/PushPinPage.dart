import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Connect/weather_service.dart';
import 'DetailWeather.dart';
import 'ForecastWeather.dart';
import 'ListWeather.dart';
import 'NotificationScreen.dart';
import '../main.dart';
import 'package:get/get.dart';


class PushPinPage extends StatelessWidget {
  PushPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PushPin Page',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/', // Đường dẫn ban đầu
      getPages: [
        GetPage(name: '/', page: () => PushPinPage()), // Màn hình chính
        GetPage(name: '/NotificationScreen', page: () => NotificationScreen(city: '')),
        GetPage(name: '/ForecastWeather', page: () => ForecastWeather(city: '')),
        GetPage(name: '/ListWeather', page: () => ListWeather(city: '')),
        GetPage(name: '/DetailWeather', page: () => DetailWeather(city: '')),
        GetPage(name: '/MyApp', page: () => MyApp()),
      ],
      home: PushPinScreen(),
    );

  }
}

class PushPinScreen extends StatefulWidget {
  @override
  _PushPinScreenState createState() => _PushPinScreenState();
}

class _PushPinScreenState extends State<PushPinScreen> {
  String city = '';
  List<String> cities = [];
  String temp = '',
      description = '',
      maxTemp = '', minTemp = '',
      Uv = '', humidity = '', feelsLike = '',
      tamnhin_km = '', wind_kph = '',
      tocdowind_kph = '', apsuat_mb = '',
      precip_mm = '', totalprecip_mm = '',
      tamnhintb_km = '', textUv ='', sunrise = '', sunset ='', moonrise='', moon_illumination ='';
  List<Map<String, dynamic>> forecastListWT = [];
  List<Map<String, dynamic>> listWeather = [];

  bool isFirstCityAdded = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await loadCityFromPrefs();
  }

  Future<void> loadCityFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedCities = prefs.getStringList('cities');
      if (savedCities != null) {
        setState(() {
          cities = savedCities;
          city = cities.first;
        });
        isFirstCityAdded = true;
        weather();
      } else {
        print('Không tìm thấy thành phố trong SharedPreferences');
      }
    } catch (e) {
      Get.offNamed('/MyApp');
      // print('Lỗi khi tải dữ liệu từ SharedPreferences: $e');
    }
  }

  void weather() async{
    setState(() {
      listWeather.clear();
      forecastListWT.clear();
    });

    if (city.isEmpty) {
      return;
    }

    List<Map<String, dynamic>> weatherData = await fetchWeather(city);

    setState(() {
      listWeather = weatherData;
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
    if (isFirstCityAdded) {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 20), // Đặt margin cho icon tìm kiếm
            child: IconButton(
              icon: Icon(Icons.search, size: 30),
              onPressed: () {
                Get.off(() => MyApp(), transition: Transition.zoom);
              },
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              // Đặt margin cho icon danh sách
              child: IconButton(
                icon: Icon(Icons.list, size: 40),
                onPressed: () {
                  Get.off(() => ListWeather(city: ''),
                      transition: Transition.zoom);
                },
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
                  '$city',
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
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
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

                        if (time != null && iconUrl != null &&
                            temperature != null) {
                          return _buildWeatherItem(
                            time,
                            iconUrl,
                            temperature,
                          );
                        } else {
                          print(
                              'Không tải được dữ liệu trang thông báo'); // Hoặc xử lý lỗi theo cách khác nếu cần thiết
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
                          borderRadius: BorderRadius.circular(
                              10), // Bo tròn góc
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => ForecastWeather(city: city),
                            transition: Transition.rightToLeft);
                      },
                      child: Text(
                        'Dự báo 7 ngày',
                        style: TextStyle(color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                ),
                // SizedBox(height: 10),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  // Số cột trong grid
                  mainAxisSpacing: 10,
                  // Khoảng cách giữa các dòng
                  crossAxisSpacing: 10,
                  // Khoảng cách giữa các cột
                  padding: EdgeInsets.all(16),
                  // Padding cho GridView
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
                              Icon(Icons.visibility,),
                              // Icon con mắt
                              SizedBox(width: 8),
                              // Khoảng cách giữa icon và văn bản
                              Text('TẦM NHÌN', style: TextStyle(fontSize: 14)),

                            ],
                          ),
                          SizedBox(height: 15,),
                          Container(
                            child: Center(
                              child: Text('$tamnhin_km km', style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 0,),
                          Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Trung bình', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                                  Text('$tamnhintb_km km', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
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
                              Icon(Icons.air,),
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
                                Text(wind_kph, style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text('km/h',
                                          style: TextStyle(fontSize: 15)),
                                      Text('Gió', style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.w600)),
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
                                Text(tocdowind_kph, style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'km/h', style: TextStyle(fontSize: 15)),
                                    Text('Gió giật', style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
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
                              Icon(Icons.water_drop,),
                              SizedBox(width: 8),
                              Text('LƯỢNG MƯA', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Container(
                            child:
                            Text('$precip_mm mm', style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
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
                                Text('Trung bình', style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                                Text('$totalprecip_mm mm', style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
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
                              Icon(Icons.speed,),
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
                                Text('$apsuat_mb', style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
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
                              Icon(Icons.sunny,),
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
                                Text('$Uv', style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
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
                              Icon(Icons.sunny_snowing, ),
                              SizedBox(width: 8),
                              Text('MẶT TRỜI MỌC',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 5,),

                          Container(
                            height: 80,
                            child: Column(
                              children: [
                                Container(
                                  child: Text('$sunrise', style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold)),
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
                                      Text('Mặt trời lặn', style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                      Text('$sunset', style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
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
                            child: Text('Trăng mọc', style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text(moonrise, style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
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
                            child: Text('Chiếu sáng', style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text('$moon_illumination %',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Hiển thị tiêu đề của ứng dụng khi chờ
        ),
      );
    }
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

