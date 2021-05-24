import 'package:brahminapp/app/astrology/astrology_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:flutter/material.dart';

class AstrologerForm extends StatefulWidget {
  final uid;

  const AstrologerForm({Key? key, this.uid}) : super(key: key);

  @override
  _AstrologerFormState createState() => _AstrologerFormState();
}

class _AstrologerFormState extends State<AstrologerForm> {
  bool astrologer = false;

  @override
  Widget build(BuildContext context) {
    return astrologer
        ? AstrologyPage(
            uid: widget.uid,
            snapshot: null,
          )
        : Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Text(
                  "Are you a Astrologer?",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        FireStoreDatabase(uid: widget.uid).updateData(data: {
                          'astrologer': true,
                        });
                        setState(() {
                          astrologer = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 3)
                            ],
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        FireStoreDatabase(uid: widget.uid).updateData(data: {
                          'astrologer': false,
                          'index': 2,
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 3)
                            ],
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
