

// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitled/models/NotificationScreen.dart';
import 'package:untitled/Connect/weather_service.dart';
import 'package:get/get.dart';
import 'DetailWeather.dart';
// import 'ForecastWeather.dart';
import '../main.dart';

class ListWeather extends StatelessWidget {
  final String city;
   ListWeather({
     required this.city,
   });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather List',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WeatherList(city: city),
    );
  }
}

class WeatherList extends StatefulWidget {
  final String city;
  WeatherList({required this.city});

  @override
  _WeatherListState createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> {
  late String _city;
  List<String> cities = [];
  List<Map<String, dynamic>> listWeather = [];


  @override
  void initState() {
    super.initState();
    _city = widget.city;
    _initData();
  }

  void _initData() async {
    await loadCityFromPrefs();
    await addCityToList(_city);
    weather();
  }

  Future<void> addCityToList(String city) async {
    if (city.isNotEmpty) {
      if (!cities.contains(city)) {
        setState(() {
          cities.add(city);
        });
        await saveCityToPrefs(); // Đợi lưu thành phố vào SharedPreferences
        // print('Đã thêm vào danh sách thành phố: $city');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thành phố $city đã tồn tại trong danh sách',
              style: TextStyle(
                color: Colors.white, // Màu chữ của SnackBar
                fontSize: 20,
              ),
            ),
            duration: Duration(seconds: 3), // Thời gian hiển thị của SnackBar
            backgroundColor: Color(0xFF5F85EC),
          ),
        );
      }
    } else {
      print('Tên thành phố không hợp lệ');
      return;
    }
  }

  Future<void> saveCityToPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool success = await prefs.setStringList('cities', cities);
      if (!success) {
        print('Lỗi khi lưu dữ liệu vào SharedPreferences');
      }
      // print('Đã lưu vào list cities: $cities');
    } catch (e) {
      print('Lỗi khi lưu dữ liệu vào SharedPreferences: $e');
    }
  }

  Future<void> loadCityFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedCities = prefs.getStringList('cities');
      if (savedCities != null) {
        setState(() {
          cities = savedCities;
        });
        // print('Danh sách thành phố: $cities');
      } else {
        print('Không tìm thấy thành phố trong SharedPreferences');
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu từ SharedPreferences: $e');
    }
  }

  Future<void> _removeCity(String remove_city) async {
    try {
      setState(() {
        cities.remove(remove_city);
      });
      await saveCityToPrefs();
      weather();
      print(cities);
      print('Đã xóa thành phố: $remove_city');
    } catch (e) {
      print('Lỗi khi xóa dữ liệu SharedPreferences: $e');
    }
  }

  void weather() async {
    List<Map<String, dynamic>> allWeatherData = [];
    for (String city in cities) {
      try {
        List<Map<String, dynamic>> weatherData = await fetchWeather(city);
        allWeatherData.addAll(weatherData);
        // print(weatherData);

      } catch (e) {
        print('Lỗi khi lấy dữ liệu thời tiết cho thành phố $city: $e');
        // Xử lý lỗi nếu cần thiết
      }
    }


    setState(() {
      listWeather = allWeatherData;
    });

    // print('listWeather: $listWeather');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'DANH SÁCH THỜI TIẾT',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listWeather.length,
              itemBuilder: (context, index) {
                final current = listWeather[index];

                final temp = current['temp_c'];
                final city = current['city'];
                final text = current['text'];
                final hour = current['hour'];
                final minute = current['minute'];
                final icon = current['icon'];
                final forecastMaxtemp = current['forecastMaxtemp'];
                final forecastMintemp = current['forecastMintemp'];

                if (text != null && temp != null && city != null &&
                    hour != null && minute != null && icon != null &&
                    forecastMintemp != null && forecastMaxtemp != null) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.blue,
                          icon: Icons.push_pin,
                          onPressed: (context) => _onDismissed(city),
                        ),
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            _removeCity(city).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã xóa thành phố $city',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // Màu chữ của SnackBar
                                      fontSize: 20,
                                    ),
                                  ),
                                  duration: Duration(seconds: 2),
                                  // Thời gian hiển thị của SnackBar
                                  backgroundColor: Color(0xFF5F85EC),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ), // Loại hiệu ứng khi mở drawer

                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => DetailWeather(city: city),
                            transition: Transition.downToUp);
                      },
                      child: _buildWeatherItem(
                        temp,
                        city,
                        text,
                        hour,
                        minute,
                        forecastMintemp,
                        forecastMaxtemp,
                      ),
                    ),
                  );
                } else {
                  print(
                      'Không tải được dữ liệu'); // Hoặc xử lý lỗi theo cách khác nếu cần thiết
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(() => MyApp(), transition: Transition.zoom);
        },
        child: Icon(Icons.search, color: Colors.white),
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
   void _onDismissed(String city) {
    // Tìm vị trí của city trong danh sách
    int index = cities.indexOf(city);
    if (index != -1) {
      // Lưu thành phần đang di chuyển lên đầu
      String cityToMove = cities.removeAt(index);
      // Thêm thành phần đang di chuyển lên đầu
      cities.insert(0, cityToMove);
      // Lưu danh sách đã cập nhật vào SharedPreferences
      // print(cities);
      saveCityToPrefs();
      weather();
    }
  }
}
Widget _buildWeatherItem(String temp, String city, String text , String hour , String minute , String forecastMaxtemp, String forecastMintemp) {
  return Container(
    margin: EdgeInsets.only(left: 30.5, top: 10, right: 30.5, bottom: 0.0),
    padding: EdgeInsets.only(left: 30.0, top: 20.0,right: 20.0, bottom: 20.0),
    decoration: BoxDecoration(
      color: Color(0x70A5B9F0),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '$city',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
        //SizedBox(height: 0.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Text(
                  '$hour:$minute',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: 150, // Đặt chiều rộng tối đa mong muốn
                  child: Text(
                      '$text',
                      //textAlign: TextAlign.center, // Căn giữa văn bản
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            //SizedBox(width: 90.0),
            Container(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 20.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$temp°',
                    style: const TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 5.0), // Optional spacing between the two Text widgets
                  Text(
                    'C:$forecastMaxtemp°  T:$forecastMintemp°', // Example of additional text below the temperature
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(height: 10.0),

                ],
              ),

            ),
          ],
        ),
      ],
    ),
  );
}







