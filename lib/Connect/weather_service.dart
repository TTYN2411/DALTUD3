
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'citymaps.dart';
import 'package:diacritic/diacritic.dart';


Future<List<Map<String, dynamic>>> fetchWeather(String city) async {
  List<Map<String, dynamic>> listWeather = [];
  List<Map<String, dynamic>> forecastList = [];


  if (city.isEmpty) {
    return listWeather;
  }

  final normalizedCity = citiesMap[city] ?? removeDiacritics(city);
  final apiKey = '93b3851e684249199c3214513241607';
  final urlCurrent = 'https://api.weatherapi.com/v1/current.json?key=$apiKey&lang=vi&q=$normalizedCity';
  final urlForecast = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&lang=vi&q=$normalizedCity&days=7';

  try {
    final response = await http.get(Uri.parse(urlCurrent));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final description_ = data['current']['condition']['text'];
      final name = city;
      final tempC = data['current']['temp_c'].round();
      final icon = data['current']['condition']['icon'];
      //lấy url cua icon
      final url_icon = 'https:$icon';
      // Viết hoa chữ cái đầu tiên của mô tả thời tiết
      final description = capitalize(description_);




      // Tính toán giờ
      final DateTime_Current = DateTime.now();
      // Set thời gian hiển thị

      final hour_ = DateTime_Current.hour;
      final minute_ = DateTime_Current.minute;
      String hour = hour_.toString().padLeft(2, '0');
      String minute = minute_.toString().padLeft(2, '0');


      //lấy ngày hiện tại
      final now = DateTime.now();
      final day = now.day;
      final month = now.month;
      final year = now.year;
      final formattedDate = 'Ngày $day tháng $month năm $year';

      //Khai báo lấy dữ liệu từ url dự báo
      final forecastResponse = await http.get(Uri.parse(urlForecast));
      final forecastData = jsonDecode(utf8.decode(forecastResponse.bodyBytes));
      DateTime? closestForecastTime;
      Map<String, dynamic>? closestForecast;

      String forecastMaxtemp = '';
      String forecastHour = 'Bây giờ';
      String forecastHumidity = '';
      String forecastUv = '';
      String forecastFeelsL = '';
      String forecastMintemp = '';
      String textUv = '';

      //Lấy dữ liệu dự báo của ngày hiện tại trong hour
      for (int i = 0; i < forecastData['forecast']['forecastday'][0]['hour'].length; i++) {
        final forecast = forecastData['forecast']['forecastday'][0]['hour'][i];
        final forecastTime = DateTime.parse(forecast['time']);

        if (closestForecastTime == null || (forecastTime.hour - hour_).abs() < (closestForecastTime.hour - hour_).abs()) {
          closestForecastTime = forecastTime;
          closestForecast = forecast;
        }
      }
      //Nếu tìm thấy dự báo có giờ gần nhất, thêm vào forecastList
      if (closestForecast != null) {
        final forecastTemp_ = closestForecast['temp_c'].round().toString();
        final forecastHumidity_ = closestForecast['humidity'].toString();
        final forecastUv_ = closestForecast['uv'].round().toString();
        final _forecastUv_ = closestForecast['uv'].round();
        final forecastFeelsL_ = closestForecast['feelslike_c'].round().toString();
        final forecastIcon_ = closestForecast['condition']['icon'];

        final tamnhin_km = closestForecast['vis_km'].round().toString();
        final wind_kph = closestForecast['wind_kph'].toStringAsFixed(0);
        final tocdowind_kph = closestForecast['gust_kph'].toStringAsFixed(0);
        final apsuat_mb = closestForecast['pressure_mb'].round().toString();
        final precip_mm = closestForecast['precip_mm'].round().toString();

        if(_forecastUv_ <= 2){
          textUv = 'Thấp';
        } else if ( 3 >= _forecastUv_ && _forecastUv_ <= 5){
          textUv = 'Trung bình';
        } else if (6 >= _forecastUv_ && _forecastUv_ <= 7){
          textUv = 'Cao';
        } else{
          textUv = 'Rất cao';
        }



        forecastUv = forecastUv_;
        forecastFeelsL = forecastFeelsL_;
        forecastHumidity = forecastHumidity_;

        forecastList.add({
          'forecastHour_': forecastHour,
          'forecastTemp_': forecastTemp_,
          'forecastIcon_': 'https:$forecastIcon_',
          'tamnhin_km': tamnhin_km,
          'wind_kph': wind_kph,
          'tocdowind_kph': tocdowind_kph,
          'apsuat_mb': apsuat_mb,
          'precip_mm': precip_mm,
        });
      }
      //Thêm các dự báo còn lại vào forecastList
      for (int i = 0; i < forecastData['forecast']['forecastday'][0]['hour'].length; i++) {
        final forecast = forecastData['forecast']['forecastday'][0]['hour'][i];
        final forecastTime = DateTime.parse(forecast['time']);
        if (forecastTime.hour > hour_) {
          final forecastHour_ = forecastTime.hour.toString().padLeft(2, '0');
          final forecastTemp_ = forecast['temp_c'].round().toString();
          final forecastIcon_ = forecast['condition']['icon'];

          forecastList.add({
            'forecastHour_': forecastHour_,
            'forecastTemp_': forecastTemp_,
            'forecastIcon_': 'https:$forecastIcon_',
          });
        }
      }
      //Lấy dữ liệu dự báo của ngày tiếp theo thêm vào forecastList
      for (int i = 0; i < forecastData['forecast']['forecastday'][1]['hour'].length; i++) {
        final forecast = forecastData['forecast']['forecastday'][1]['hour'][i];
        final forecastTime = DateTime.parse(forecast['time']);
        if (forecastTime.hour < hour_) {
          final forecastHour_ = forecastTime.hour.toString().padLeft(2, '0');
          final forecastTemp_ = forecast['temp_c'].round().toString();
          final forecastIcon_ = forecast['condition']['icon'];

          forecastList.add({
            'forecastHour_': forecastHour_,
            'forecastTemp_': forecastTemp_,
            'forecastIcon_': 'https:$forecastIcon_',
          });
        }
      }

      String today = 'Hôm nay';
      String _formattedDate = formattedDate;
      List<Map<String, dynamic>> forecastDayList = [];
      List<Map<String, dynamic>> forecastDayList_day = [];



      // Lấy dữ liệu của ngày hiện tại
        for (int i = 0; i <
            forecastData['forecast']['forecastday'].length; i++) {
          final forecasttoday_ = forecastData['forecast']['forecastday'][0]['date'];
          if(forecasttoday_ != null){
            final maxtemp_today = forecastData['forecast']['forecastday'][0]['day']['maxtemp_c'].round().toString();
            final mintemp_today = forecastData['forecast']['forecastday'][0]['day']['mintemp_c'].round().toString();
            final icon_today = forecastData['forecast']['forecastday'][0]['day']['condition']['icon'];
            final text_day = forecastData['forecast']['forecastday'][0]['day']['condition']['text'].toString();
            final uv_day = forecastData['forecast']['forecastday'][0]['day']['uv'].round().toString();
            final maxwind_kph = forecastData['forecast']['forecastday'][0]['day']['maxwind_kph'].round().toString();
            final humiditytb = forecastData['forecast']['forecastday'][0]['day']['avghumidity'].toString();
            final nhietdotb = forecastData['forecast']['forecastday'][0]['day']['avgtemp_c'].round().toString();

            final totalprecip_mm = forecastData['forecast']['forecastday'][0]['day']['totalprecip_mm'].round().toString();
            final tamnhintb_km = forecastData['forecast']['forecastday'][0]['day']['avgvis_km'].round().toString();
            final sunrise = forecastData['forecast']['forecastday'][0]['astro']['sunrise'].toString();
            final sunset = forecastData['forecast']['forecastday'][0]['astro']['sunset'].toString();
            final moonrise = forecastData['forecast']['forecastday'][0]['astro']['moonrise'].toString();
            final moon_illumination = forecastData['forecast']['forecastday'][0]['astro']['moon_illumination'].toString();

            // Hàm chuyển đổi thời gian từ 12 giờ sang 24 giờ
            String convert12hTo24h(String time12h) {
              List<String> timeParts = time12h.split(":");
              int hour = int.parse(timeParts[0]);
              int minute = int.parse(timeParts[1].split(" ")[0]); // Lấy phút, loại bỏ AM/PM

              if (time12h.contains("PM") && hour != 12) {
                hour += 12; // Nếu là PM và không phải là 12 giờ, cộng thêm 12 giờ
              } else if (time12h.contains("AM") && hour == 12) {
                hour = 0; // Nếu là AM và là 12 giờ, chuyển thành 0 giờ (đầu ngày)
              }

              return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
            }

            // Chuyển đổi thời gian sang định dạng 24 giờ
            String sunrise24Hour = convert12hTo24h(sunrise);
            String sunset24Hour = convert12hTo24h(sunset);
            String moonrise24Hour = convert12hTo24h(moonrise);


            forecastDayList_day.add({
              'maxtemp_today': maxtemp_today,
              'mintemp_today': mintemp_today,
              'icon_today': 'https:$icon_today',
              'text_day': text_day,
              'totalprecip_mm': totalprecip_mm,
              'tamnhintb_km': tamnhintb_km,
              'sunrise': sunrise24Hour,
              'sunset': sunset24Hour,
              'moonrise': moonrise24Hour,
              'moon_illumination': moon_illumination,
              'uv_day': uv_day,
              'maxwind_kph': maxwind_kph,
              'humiditytb': humiditytb,
              'nhietdotb': nhietdotb,


            });
            forecastDayList.add({
              'forecasttoday': today,
              'forecastDayList_day': forecastDayList_day,
            });
            break;

          }
        }
      // Lấy dữ liệu của các ngày tiếp theo
      for (int i = 1; i <
          forecastData['forecast']['forecastday'].length; i++) {
        final forecastday = forecastData['forecast']['forecastday'][i]['date'];
        final date = DateTime.parse(forecastday);
        final formattedday_ = DateFormat('dd/MM').format(date);


        if(forecastday != null){
          List<Map<String, dynamic>> forecastDayList_day_ = [];

          final maxtemp_today = forecastData['forecast']['forecastday'][i]['day']['maxtemp_c'].round().toString();
          final mintemp_today = forecastData['forecast']['forecastday'][i]['day']['mintemp_c'].round().toString();
          final icon_today = forecastData['forecast']['forecastday'][i]['day']['condition']['icon'];
          final text_day = forecastData['forecast']['forecastday'][i]['day']['condition']['text'].toString();
          final uv_day = forecastData['forecast']['forecastday'][i]['day']['uv'].round().toString();
          final maxwind_kph = forecastData['forecast']['forecastday'][i]['day']['maxwind_kph'].round().toString();
          final humiditytb = forecastData['forecast']['forecastday'][i]['day']['avghumidity'].toString();
          final nhietdotb = forecastData['forecast']['forecastday'][i]['day']['avgtemp_c'].round().toString();
          final totalprecip_mm = forecastData['forecast']['forecastday'][i]['day']['totalprecip_mm'].round().toString();
          final tamnhintb_km = forecastData['forecast']['forecastday'][i]['day']['avgvis_km'].round().toString();


          forecastDayList_day_.add({
            'maxtemp_today': maxtemp_today,
            'mintemp_today': mintemp_today,
            'icon_today': 'https:$icon_today',
            'text_day': text_day,
            'totalprecip_mm': totalprecip_mm,
            'tamnhintb_km': tamnhintb_km,
            'uv_day': uv_day,
            'maxwind_kph': maxwind_kph,
            'humiditytb': humiditytb,
            'nhietdotb': nhietdotb,
          });
          forecastDayList.add({
            'forecasttoday': formattedday_,
            'forecastDayList_day': forecastDayList_day_,
          });
        }
        //break;


      }

      //Lấy dữ liệu dự báo của ngày hiện tại trong day
      final forecast_day = forecastData['forecast']['forecastday'][0]['day'];

      if (forecast_day != null) {
        final forecastMaxtemp_ = forecast_day['maxtemp_c'].round().toString();
        final forecastMintemp_ = forecast_day['mintemp_c'].round().toString();

        forecastMaxtemp = forecastMaxtemp_;
        forecastMintemp = forecastMintemp_;
      }
      //Khai báo List để chuyển qua listweather
      if (description != null && tempC != null && name != null && tempC != null &&
          url_icon != null && forecastMintemp != null && forecastMaxtemp != null) {
        listWeather.add({
          'city': city,
          'text': description.toString(),
          'name': name.toString(),
          'temp_c': tempC.toString(),
          'hour': hour.toString(),
          'minute': minute.toString(),
          'icon': url_icon,
          'forecastMaxtemp': forecastMaxtemp,
          'forecastMintemp': forecastMintemp,
          'forecastUv' : forecastUv,
          'textUv': textUv,
          'forecastFeelsL' :forecastFeelsL,
          'forecastHumidity' : forecastHumidity,
          'forecastList': forecastList,
          'forecastDayList': forecastDayList,
          '_formattedDate': _formattedDate,
        });
      } else {
        throw Exception('Lỗi không có dữ liệu!');
      }
    } else {
      throw Exception('Lỗi không tải đc dữ liệu!');
    }
  } catch (e) {
    listWeather.add({
      'text': 'Không thể truy cập',
      'name': 'Không tìm thấy',
      'temp_c': 'N/A',
      'hour': 'N/A',
      'minute': 'N/A',
      'icon': 'N/A',
      'forecastHumidity': 'N/A',
      'forecastUv': 'N/A',
      'forecastFeelsL': 'N/A',
      'forecastList': 'N/A',
      'forecastMaxtemp': 'N/A',
      'forecastMintemp': 'N/A',
    });
    print('Error occurred: $e');
  }

  return listWeather;

}





// Hàm để viết hoa chữ cái đầu tiên của mô tả thời tiết
String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}




