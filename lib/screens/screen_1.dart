import 'package:flutter/material.dart';
import 'package:lg_task2/components/connection_flag.dart';
import 'package:lg_task2/screens/home_page.dart';
import 'package:lg_task2/connections/ssh.dart';
import 'package:lg_task2/screens/screen_2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height, // Full screen height
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/home_bg.jpg'), // Replace with your image path
            fit: BoxFit.cover, // Ensures the image covers the whole screen
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ConnectionFlag(
                      status: ConnectionStatus,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(top: 20),
              //       child: TextButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               WidgetStateProperty.all(Color(0xFF385B9D)),
              //           minimumSize:
              //               WidgetStateProperty.all(const Size(300, 80)),
              //           shape: WidgetStateProperty.all(
              //             RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(15), // Set corner radius
              //             ),
              //           ),
              //         ),
              //         onPressed: () async {
              //           await ssh.tester();
              //           // if (result == null) {
              //           //   developer.log('not sent');
              //           // }
              //         },
              //         child: const Text(
              //           'Tester',
              //           style: TextStyle(
              //             color: Colors.white, // Set text color
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF385B9D)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 80)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set corner radius
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ssh.displaySpecificKML("wild");
                      },
                      child: const Text(
                        'Los Angeles Wildfires',
                        style: TextStyle(
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF385B9D)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 80)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set corner radius
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ssh.displaySpecificKML("air");
                      },
                      child: const Text(
                        'Los Angeles Air',
                        style: TextStyle(
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF385B9D)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 80)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set corner radius
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ssh.setLogos();
                      },
                      child: const Text(
                        'Set Logo',
                        style: TextStyle(
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF385B9D)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 80)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set corner radius
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ssh.cleanLogos();
                      },
                      child: const Text(
                        'Clear Logos',
                        style: TextStyle(
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF385B9D)),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 80)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Set corner radius
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ssh.clearKml();
                      },
                      child: const Text(
                        'Clear KMLs',
                        style: TextStyle(
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
