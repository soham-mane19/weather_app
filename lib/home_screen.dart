import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: builddrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/newimage.jpg'),
                        fit: BoxFit.cover)),
              ),
              Column(children: [
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
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      const Text(
                        "Khatgun",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
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
                    Column(
                      children: [
                        const Text(
                          "24",
                          style: TextStyle(fontSize: 85, color: Colors.white),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset('assets/mostly.png')),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Mostly cloudly",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    )
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
                        padding: EdgeInsets.all(10),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black54),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hourly Forecast",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  hourlyUpdate(),
                                ],
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                            dailyUpdate(),
                            const SizedBox(
                              height: 15,
                            ),
                            dailyUpdate(),
                            const SizedBox(
                              height: 15,
                            ),
                            dailyUpdate(),
                            const SizedBox(
                              height: 15,
                            ),
                            dailyUpdate(),
                            const SizedBox(
                              height: 15,
                            ),
                            dailyUpdate(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 230,
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
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
                                      todayUpdate(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      todayUpdate(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      todayUpdate(),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //2nd column
                                  Column(
                                    children: [
                                        todayUpdate(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      todayUpdate(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      todayUpdate(),
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
              const Positioned(
                  top: 190,
                  right: 130,
                  child: Text(
                    "\u00B0C",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  )),
            ]),
          ],
        ),
      ),
    );
  }

  Widget todayUpdate() {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
          ),
          child: const Icon(
            Icons.water_drop_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 60,
        ),
        const Column(
          children: [
            Text(
              "86%",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              "Humidity",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
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
          child: Image.asset(''),
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
