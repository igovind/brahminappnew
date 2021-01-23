import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientDetailPage extends StatelessWidget {
  final String name;
  final String location;
  final String link;
  final String service;
  final bool paid;
  final String date;
  final String time;
  final String pic;
  final bool cod;
  final String bookingId;

  const ClientDetailPage(
      {Key key,
        this.link,
      @required this.name,
      @required this.location,
      @required this.service,
      @required this.paid,
      @required this.date,
      @required this.time,
      @required this.pic,
      @required this.bookingId,
      @required this.cod}): super(key: key);

  void launcher()async{
    var url = '$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenLength = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
        child: Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      height: screenLength * 0.7,
      width: screenWidth * 0.8,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CircularProfileAvatar(
                '',
                child: Image.network(pic),
                radius: screenWidth * 0.22,
                backgroundColor: Colors.grey[300],
                borderWidth: 0.5,
                borderColor: Colors.deepOrange,
                elevation: 1,
              ),
              SizedBox(
                height: screenLength * 0.04,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: screenLength * 0.035, color: Colors.black54),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black54,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                service,
                style: TextStyle(
                    fontSize: screenLength * 0.037, color: Colors.pink),
              ),
              Text(
                '$date $time',
                style: TextStyle(
                    color: Colors.black54, fontSize: screenLength * 0.018),
              ),
              Text(
                paid ? 'Online Paid' : cod ? 'Cash on Delivery' : 'Not Paid yet',
                style: TextStyle(
                    color: paid
                        ? Colors.green
                        : cod ? Colors.deepPurple : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: screenLength * 0.024),
              ),
              SizedBox(
                height: screenLength * 0.05,
              ),
              Text('ID: $bookingId',style: TextStyle(fontSize: 18),),
              SizedBox(
                height: screenLength * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.deepOrange,
                    iconSize: screenLength * 0.05,
                    onPressed: () {
                      launcher();
                    },
                  ),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                          fontSize: screenLength * 0.017,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenLength * 0.05,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
