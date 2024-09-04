import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Connect/weather_service.dart';
import 'models/ListWeather.dart';
import 'models/NotificationScreen.dart';
import 'models/PushPinPage.dart';
import 'Connect/city.dart';
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'Connect/citymaps.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PushPinPage());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = '';
  List<Map<String, dynamic>> _citiesWeather = [];


  @override
    void initState() {
    super.initState();
  }
    void _fetchWeather() async{
    setState(() {
      _citiesWeather.clear();
    });

    if (_city.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập vào tên thành phố.',
            style: TextStyle(
              color: Colors.white, // Màu chữ của SnackBar
              fontSize: 20,
            ),),
          duration: Duration(seconds: 2), // Thời gian hiển thị của SnackBar
          backgroundColor: Color(0xFF5F85EC),
        ),
      );
      return;
    }
    if (!citiesMap.containsKey(_city)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy thành phố này.',
            style: TextStyle(
              color: Colors.white, // Màu chữ của SnackBar
              fontSize: 20,
            ),),
          duration: Duration(seconds: 2), // Thời gian hiển thị của SnackBar
          backgroundColor: Color(0xFF5F85EC),
        ),
      );
      return;
    }
    List<Map<String, dynamic>> weatherData = await fetchWeather(_city);
    setState(() {
      _citiesWeather = weatherData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
        child: AppBar(
          title: const Text(''),
          centerTitle: true,
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Thêm khoảng đệm xung quanh văn bản
                        child: Text(
                          'THỜI TIẾT',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity, // Chiều ngang của Container theo chiều rộng của parent
                      height: 50.0, // Chiều cao của Container
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0), // Khoảng cách bottom
                          child: IconButton(
                            onPressed: ()  {
                              Get.off(() => ListWeather(city: ''), transition: Transition.zoom);
                            },
                            icon: Icon(Icons.list),
                            iconSize: 36.0, // Kích thước của biểu tượng
                          ),
                        ),
                      ),

                    ),
                  ),
                ],
              ),

              SizedBox(height: 0),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  final normalizedInput = removeDiacritics(textEditingValue.text.toLowerCase());
                  return citiesList.where((String city) {
                    final normalizedCity = removeDiacritics(city.toLowerCase());
                    return normalizedCity.contains(normalizedInput);
                  });
                },
                onSelected: (String selection) {
                    setState(() {
                      _city = selection;
                    });
                    _fetchWeather();
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                  return Container(
                    height: 35, // Đặt chiều cao của phần nhập là 40
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xFFA5B9F0), // Màu nền của phần nhập
                      borderRadius: BorderRadius.circular(10.0), // Độ bo tròn các cạnh
                    ),
                    child: TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Khoảng cách từ viền đến văn bản bên trong
                          border: InputBorder.none, // Loại bỏ đường viền của phần nhập
                          hintText: 'Tìm tên thành phố',
                          hintStyle: TextStyle(fontSize: 18.0), // Đặt kích thước chữ cho gợi ý
                          prefixIcon: Icon(Icons.search, color: Color(0xFF1C1C1E)), // Thêm biểu tượng tìm kiếm và sử dụng màu 1C1C1E
                        ),
                        style: TextStyle(fontSize: 16.0), // Đặt kích thước chữ cho nội dung đã nhập
                        onSubmitted: (String value){
                          setState(() {
                            _city = value;
                          });
                          _fetchWeather(); // Gọi hàm _fetchWeather khi người dùng nhấn nút "Done"
                        }
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _citiesWeather.isNotEmpty
                ? ListView.builder(
                  itemCount: _citiesWeather.length,
                  itemBuilder: (context, index) {
                    final cityWeather = _citiesWeather[index];

                    final city = _city;
                    final tempC = cityWeather['temp_c']?.toString() ?? 'N/A';
                    final description = cityWeather['text'] ?? 'Unknown weather';
                    final hour = cityWeather['hour']?.toString() ?? 'N/A';
                    final minute = cityWeather['minute']?.toString() ?? 'N/A';
                    final icon = cityWeather['icon']?? '...';
                    final Maxtemp = cityWeather['forecastMaxtemp']?.toString()?? 'N/A';
                    final Mintemp = cityWeather['forecastMintemp']?.toString()?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationScreen(city: city), transition: Transition.zoom);
                      },
                      child: _listWeatheritem(
                        city,
                        tempC,
                        description,
                        hour,
                        minute,
                        icon,
                        Maxtemp,
                        Mintemp,
                      ),
                    );
                  },
              ) : Center(
                  child: Text(''),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _listWeatheritem( String city, String tempC, String description, String hour, String minute, String icon, String Maxtemp, String Mintemp, ){
  return Container(
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
              fontSize: 24.0,
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
                Text(
                  '$hour:$minute',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền bạn muốn
                    borderRadius: BorderRadius.circular(10), // Bo góc (tùy chọn)
                  ),
                  child: Center(
                    child: Image.network(
                      icon,
                      // width: 8,
                      // height: 8,
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(width: 90.0),
            Container(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 30.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$tempC°',
                    style: const TextStyle(
                      fontSize: 65.0,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 5.0), // Optional spacing between the two Text widgets
                  Text(
                    'C:$Maxtemp°  T:$Mintemp°', // Example of additional text below the temperature
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
        Text(
          '$description',
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}



