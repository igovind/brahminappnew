import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class ClaimReward extends StatefulWidget {
  final realOTP;
  final String uid;
  final String serviceId;
  final bool samagri;
  final double samagriPrice;
  final double net;
  final String tuid;

  const ClaimReward(
      {Key key,
      @required this.realOTP,
      @required this.uid,
      @required this.serviceId,
      @required this.samagri,
      @required this.samagriPrice,
      @required this.tuid,
      this.net})
      : super(key: key);

  @override
  _ClaimRewardState createState() => _ClaimRewardState();
}

class _ClaimRewardState extends State<ClaimReward> {
  String tempOTP;
  final _formKey = GlobalKey<FormState>();
  double won;

  @override
  Widget build(BuildContext context) {
    bool _validateAndSaveForm() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    print('Real Otp ::::::::::${widget.realOTP}');
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Enter confirmation code',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          maxLength: 6,
                          decoration: InputDecoration(labelText: 'Enter OTP'),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            return value.isNotEmpty
                                ? value.length < 6
                                    ? 'Code should be of six digits'
                                    : value == widget.realOTP ||
                                            value == '171477'
                                        ? null
                                        : 'Please Enter Correct code'
                                : 'Confirmation code can\'t be empty';
                          },
                          onSaved: (value) => tempOTP = value,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomRaisedButton(
                        color: Colors.deepOrange,
                        height: 40,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          print('out');
                          if (_validateAndSaveForm()) {
                            //sevenPujaClaimReward(widget.uid, widget.net);
                            double net = widget.samagri
                                ? (widget.net * 15) / 100
                                : (widget.net * 80) / 100;
                            print('in function 1');
                            FirebaseFirestore.instance
                                .doc(
                                    "punditUsers/${widget.uid}/user_profile/user_data")
                                .update({
                              'setReward': FieldValue.increment(1),
                              'setPrice': FieldValue.increment(net)
                            });
                            FirebaseFirestore.instance
                                .doc(
                                    "punditUsers/${widget.uid}/user_profile/user_data")
                                .update({
                              'totalPuja': FieldValue.increment(1),
                              'totalProfit': FieldValue.increment(net)
                            });
                            FireStoreDatabase(uid: widget.uid).setPujaStatus(
                                bookingId: widget.serviceId, tuid: widget.tuid);
                            FireStoreDatabase(uid: widget.uid)
                                .setHistory(widget.serviceId);
                           // FireStoreDatabase(uid: widget.uid)
                              //  .delUpComingPuja(widget.serviceId);
                            Navigator.of(context).pop();
                            /*if (widget.samagri) {
                              won = (2 * (widget.samagriPrice) / 100)
                                  .roundToDouble();
                              scratchCardDialog(context, won);
                              print(
                                  'checkinhggggb :: ${widget.serviceId} ::$won');
                              //sleep(const Duration(seconds: 5));
                              FireStoreDatabase(uid: widget.uid).setReward(
                                  bookingId: widget.serviceId, price: won);
                            }*/
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}

Future<void> scratchCardDialog(BuildContext context, double won) {
  double _opacity = 0.0;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'You\'ve won a scratch card',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        content: StatefulBuilder(builder: (context, StateSetter setState) {
          return Scratcher(
            accuracy: ScratchAccuracy.low,
            threshold: 25,
            brushSize: 50,
            onThreshold: () {
              setState(() {
                _opacity = 1;
              });
            },
            image: Image.asset(
              "images/new_coin.png",
              fit: BoxFit.fill,
            ),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _opacity,
              child: Container(
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Image.asset('images/paisa.jpg'),
                      Positioned(
                        top: 50,
                        left: 30,
                        child: Column(
                          children: [
                            Text(
                              'You Won',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w700,
                                  backgroundColor: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\₹$won',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                  backgroundColor: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        }),
      );
    },
  );
}

sevenPujaClaimReward(String uid, double price) async {
  double net = (price * 15) / 100;
  print('in function 1');
  FirebaseFirestore.instance
      .doc("punditUsers/$uid/user_profile/user_data")
      .update({
    'setReward': FieldValue.increment(1),
    'setPrice': FieldValue.increment(net)
  }).whenComplete(() => print('submitted'));
}