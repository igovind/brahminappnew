import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/database.dart';
import 'package:flutter/material.dart';

class AstroSelect extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rate;
  final String keyword;
  final String time;

  final String uid;
  final String details;
  final String offer;

  const AstroSelect(
      {Key key,
      this.imageUrl,
      this.name,
      this.rate,
      this.keyword,
      @required this.uid,
      this.details,
      this.time,
      this.offer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String yourRate;
    String duration;
    String additional;
    final _astroFormKey = GlobalKey<FormState>();
    bool _validateAndSaveForm() {
      final form = _astroFormKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    Future<void> _submit() async {
      if (_validateAndSaveForm()) {
        FireStoreDatabase(uid: uid).setAstrology(
          details: details,
          name: name,
          price: yourRate,
          description: additional,
          imageUrl: imageUrl,
          duration: duration,
          keyword: keyword,
        );
        BotToast.showText(
            text: offer == null ? "$name is added" : "$name is updated");
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
      }
    }

    return Form(
      key: _astroFormKey,
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
              //height: 400,
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    //height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(imageUrl),
                        Text(
                          '$name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              offer == null ? 'Normal rate' : 'Your Rate',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '\₹$rate',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),

                        Divider(
                          thickness: 1,
                          color: Colors.deepOrange[100],
                        ),
                        Text('$details')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.deepOrange[100],
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Your Price'),
                      initialValue: offer == null ? '' : '$rate',
                      validator: (value) =>
                          value.isNotEmpty ? null : 'Price can\'t be empty',
                      onSaved: (value) => yourRate = value,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.deepOrange[100],
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Duration'),
                      initialValue: offer == null ? '' : '$time',
                      validator: (value) =>
                          value.isNotEmpty ? null : 'Duration can\'t be empty',
                      onSaved: (value) => duration = value,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.deepOrange[100],
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Additional details'),
                      initialValue: offer == null ? '' : '$offer',
                      validator: (value) =>
                          value.isNotEmpty ? null : 'Details can\'t be empty',
                      onSaved: (value) => additional = value,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomRaisedButton(
                    color: Colors.deepOrange,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _submit();
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
