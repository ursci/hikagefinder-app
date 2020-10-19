import 'package:flutter/material.dart';
import 'package:hikageapp/res/ColorParams.dart';
import 'package:hikageapp/res/StringsParams.dart';

class InfoPage extends StatefulWidget {
  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff777777),
        ),
        backgroundColor: Colors.white,
        title: Text(
          StringParams.locale["ImfoPage.appbar_title"],
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            ButtonTheme(
              minWidth: 300.0,
              //height: 35.0,
              child: RaisedButton(
                child: Text(
                  "ENGLISH",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: StringParams.locale["lang"] == "en"
                    ? ColorParams.fastestColor
                    : ColorParams.recommendedColor,
                onPressed: () => setState(() {
                  StringParams.locale = StringParams.en;
                }),
              ),
            ),
            ButtonTheme(
              minWidth: 300.0,
              //height: 35.0,
              child: RaisedButton(
                child: Text(
                  "日本語",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: StringParams.locale["lang"] == "jp"
                    ? ColorParams.fastestColor
                    : ColorParams.recommendedColor,
                onPressed: () => setState(() {
                  StringParams.locale = StringParams.jp;
                }),
              ),
            ),
            ButtonTheme(
              minWidth: 300.0,
              //height: 35.0,
              child: RaisedButton(
                child: Text(
                  "DEUTSCH",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: StringParams.locale["lang"] == "de"
                    ? ColorParams.fastestColor
                    : ColorParams.recommendedColor,
                onPressed: () => setState(() {
                  StringParams.locale = StringParams.de;
                }),
              ),
            ),
            ButtonTheme(
              minWidth: 300.0,
              //height: 35.0,
              child: RaisedButton(
                child: Text(
                  "FRANÇAIS",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: StringParams.locale["lang"] == "fr"
                    ? ColorParams.fastestColor
                    : ColorParams.recommendedColor,
                onPressed: () => setState(() {
                  StringParams.locale = StringParams.fr;
                }),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.0,
            ),
            Icon(
              Icons.map,
              size: 60,
              color: ColorParams.recommendedColor,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              StringParams.locale["InfoPage.title"],
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
              StringParams.locale["InfoPage.text"],
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
              text: TextSpan(
                children: [
                  TextSpan(
                      text: StringParams.locale["InfoPage.text2"],
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xff989998),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1625,
                      )),
                  TextSpan(
                    text: StringParams.locale["InfoPage.contact"],
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
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
        //),
      ),
    );
  }
}
