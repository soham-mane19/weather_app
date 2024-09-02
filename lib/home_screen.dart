import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:whether_app/location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? locationadress;
  List forecast = [];
  WeatherFactory wf = WeatherFactory('e86c215d861782d7dae0c22d8f916fd8');
  Weather? weather;
  @override
  void initState() {
    super.initState();
    getpostion();
  }

  void getweather() async {
    if (locationadress != null) {
      weather = await wf.currentWeatherByCityName(locationadress!);
      setState(() {});
    }
  }

  Future<void> getpostion() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    getAddress(position);
  }

  Future<void> getAddress(Position? currentPosition) async {
    if (currentPosition != null) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      if (placemark.isNotEmpty) {
        Placemark place = placemark[0];
        setState(() {
          locationadress = place.locality;
        });
        getweather();
        getHourlyForecast(currentPosition);
      }
    }
  }

  void getHourlyForecast(Position currentPosition) async {
    const apiKey = 'e86c215d861782d7dae0c22d8f916fd8';
    final url =
        'http://api.openweathermap.org/data/2.5/forecast?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          forecast = data['list'];
          print("forecast aahe $forecast");
        });
      } else {
        print('Failed to fetch hourly forecast');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: builddrawer(),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Image.png'), fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ));
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Text(
                    weather?.areaName ?? "",
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                           return const  LocationScreen();
                        },));
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  if (weather != null) ...[
                    Row(
                      children: [
                        Text(
                          weather!.temperature!.celsius!.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 85, color: Colors.white),
                        ),
                        const Text(
                          "\u00B0C",
                          style: TextStyle(fontSize: 70, color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.network(
                                "https://openweathermap.org/img/wn/${weather!.weatherIcon}@2x.png" )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          weather!.weatherDescription!,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ] else ...[
                    const CircularProgressIndicator()
                  ]
                ])
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    padding:const EdgeInsets.all(10),
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black54),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hourly Forecast",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.1, color: Colors.white54)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // Filter the forecast list to only include entries for today
                            itemCount: forecast.where((entry) {
                              var datetime = DateTime.parse(entry['dt_txt']);
                              var today = DateTime.now();
                              return datetime.day == today.day &&
                                  datetime.month == today.month &&
                                  datetime.year == today.year;
                            }).length,
                            itemBuilder: (context, index) {
                              // Get the filtered list of today's forecasts
                              var todayForecast = forecast.where((entry) {
                                var datetime = DateTime.parse(entry['dt_txt']);
                                var today = DateTime.now();
                                return datetime.day == today.day &&
                                    datetime.month == today.month &&
                                    datetime.year == today.year;
                              }).toList();

                              var forecastlist = todayForecast[index];
                              var datetime =
                                  DateTime.parse(forecastlist['dt_txt']);
                              var temperature = forecastlist['main']['temp'];
                              var icon = forecastlist["weather"][0]['icon'];

                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Image.network(
                                              'https://openweathermap.org/img/wn/$icon@2x.png'),
                                        ),
                                        Text(
                                          "${temperature.toStringAsFixed(0)}\u00B0C",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${datetime.hour}:00', // Formatting to show hour and minute
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 340,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Daily Forecast",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.1, color: Colors.white54)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            // Use a Set to store unique dates
                            itemCount: forecast
                                .where((entry) {
                                  var datetime =
                                      DateTime.parse(entry['dt_txt']);
                                  var today = DateTime.now();
                                  return datetime.isAfter(today) &&
                                      datetime.isBefore(
                                          today.add(const Duration(days: 5)));
                                })
                                .map((entry) {
                                  // Extract only the date part for uniqueness
                                  return DateTime.parse(entry['dt_txt'])
                                      .toString()
                                      .split(' ')[0];
                                })
                                .toSet()
                                .length, // Get the count of unique dates
                            itemBuilder: (context, index) {
                              // Filter and get unique dates list
                              var uniqueDates = forecast
                                  .where((entry) {
                                    var datetime =
                                        DateTime.parse(entry['dt_txt']);
                                    var today = DateTime.now();
                                    return datetime.isAfter(today) &&
                                        datetime.isBefore(
                                            today.add( const Duration(days: 5)));
                                  })
                                  .map((entry) {
                                    return DateTime.parse(entry['dt_txt'])
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0];
                                  })
                                  .toSet()
                                  .toList(); // Convert to a list to access by index

                              // Get the current date based on index
                              var currentDate = uniqueDates[index];

                              // Filter the forecast for the current date
                              var filteredForecast = forecast.where((entry) {
                                var datetime =
                                    DateTime.parse(entry['dt_txt']).toLocal();
                                return datetime.toString().split(' ')[0] ==
                                    currentDate;
                              }).toList();

                              // Get the first entry for the current date
                              var entry = filteredForecast.first;
                              var datetime = DateTime.parse(entry['dt_txt']);
                              var dayName = DateFormat('EEEE')
                                  .format(datetime); // Day name (e.g., Monday)
                              var date = DateFormat('MMM d')
                                  .format(datetime); // Date (e.g., Aug 31)
                              var temp = entry['main']['temp']; // Temperature
                              var description = entry['weather'][0]
                                  ['description']; // Weather description
                              var icon =
                                  entry['weather'][0]['icon']; // Weather icon

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: Row(
                                  children: [
                                   SizedBox(
                                      height: 41,
                                      width: 90,
                                      child: Column(
                                        children: [
                                          // Display day name
                                          Text(
                                            dayName,
                                            style:  const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          // Display date
                                          Text(
                                            date,
                                            style:  const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // Weather icon
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.network(
                                        'http://openweathermap.org/img/wn/$icon.png', // Load icon from network
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    // Weather description
                                    Text(
                                      description,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    const Spacer(),
                                    // Temperature
                                    Text(
                                      '${temp.toStringAsFixed(1)}\u00B0C', // Display temperature with degree symbol
                                      style:const  TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 232,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today Weather",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.1, color: Colors.white54)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              //1st column
                              Column(
                                children: [
                                  todayUpdate(
                                      const Icon(
                                        Icons.water_drop_outlined,
                                        color: Colors.white,
                                      ),
                                      "Humidity",
                                      0),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  todayUpdate(
                                      const Icon(
                                        Icons.visibility_outlined,
                                        color: Colors.white,
                                      ),
                                      "Visibility",
                                      1),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  todayUpdate(
                                      const Icon(
                                        Icons.thermostat,
                                        color: Colors.white,
                                      ),
                                      "Pressure",
                                      2),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              //2nd column
                              Column(
                                children: [
                                  todayUpdate(
                                      const Icon(
                                        Icons.thermostat_auto,
                                        color: Colors.white,
                                      ),
                                      "Dew Point",
                                      3),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  todayUpdate(
                                      const Icon(Icons.line_weight_rounded,
                                          color: Colors.white),
                                      "Real Feel",
                                      4),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  todayUpdate(
                                      const Icon(
                                        Icons.line_weight_outlined,
                                        color: Colors.white,
                                      ),
                                      "windspeed",
                                      5),
                                ],
                              ),
                            ],
                          )
                        ]),
                  )
                ],
              ),
            )
          ]),
        ),
      ]),
    );
  }

  Widget todayUpdate(Icon iconname, String name, int index) {
    return Row(
      children: [
        Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: iconname),
        const SizedBox(
          width: 60,
        ),
      weather!=null?Column(
          children: [
            Text(
              index == 0
                  ? "${weather!.humidity}%"
                  : index == 1
                      ? "${forecast[0]["visibility"] / 1000}km"
                      : index == 2
                          ? "${weather!.pressure}mb"
                          : index == 3
                              ? dewpoint()
                              : index == 4
                                  ? "${weather!.tempFeelsLike!.celsius!.toStringAsFixed(0)}\u00B0C"
                                  : "${weather!.windSpeed}",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ): const CircularProgressIndicator(),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.white10)),
        )
      ],
    );
  }

  String dewpoint() {
    if(weather!=null){
    double temperature = weather!.temperature!.celsius! ;
    double humidity = weather!.humidity!;
    double dewPointca = temperature - ((100 - humidity) / 5.0);
    return dewPointca.toStringAsFixed(1);
    }
    else{
      return "";
    }
  }

  Widget dailyUpdate() {
    return Row(
      children: [
        const Column(
          children: [
            Text(
              "Thu",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            Text(
              "8/29",
              style: TextStyle(fontSize: 12, color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          height: 20,
          width: 20,
          // child: Image.asset(''),
        ),
        const SizedBox(
          width: 7,
        ),
        const Text(
          "Showers",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const Spacer(),
        const Text(
          "21\u00B0C",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "26\u00B0C",
          style: TextStyle(fontSize: 15, color: Colors.white),
        )
      ],
    );
  }

  Widget hourlyUpdate() {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          child: Image.asset('assets/mostly.png'),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "28\u00B0C",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        const Text(
          "11:00",
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
      ],
    );
  }

  Widget builddrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                const Text(
                  'Setting',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      width: 200, child: Image.asset('assets/whethericon.png')),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text("WeatherNow",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text("V1.0.0.0",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Container(
              padding:
                  EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 15),
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.file_copy_outlined,
                          color: Colors.white60,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Terms of services",
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.white54)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.policy,
                          color: Colors.white60,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Privacy policy",
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
