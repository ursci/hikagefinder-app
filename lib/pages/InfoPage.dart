import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff777777),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Info",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xff777777),
            //fontSize: 28,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.25,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: 350.0,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Icon(
                  Icons.map,
                  size: 60,
                  color: Colors.blue[900],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "What is Hikage Finder?",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Hikage finder let’s you find a route between two locations that has a lower amount of sunshine exposure than the fastest way which is usually suggested by other map services. \n\nTo select your departure and destination point, move the map with one finger and release your finger when the pointer hovers over your desired location.",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff777777),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.1625,
                  ),
                ),
                SizedBox(
                  height: 22.0,
                ),
                RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                          text:
                              "Hikage Finder is developed by the University of Tokyo in corporation with Georepublic Japan.\n\nFor questions and feedback feel free to contact us at",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff989998),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.1625,
                          )),
                      new TextSpan(
                        text: "  contact@hikagefinder.jp",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xff23289d),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.1625,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
