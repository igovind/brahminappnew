import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class AstroSelect extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rate;
  final String keyword;

  final String uid;
  final String details;

  const AstroSelect(
      {Key key,
      this.imageUrl,
      this.name,
      this.rate,
      this.keyword,
      this.uid,
      this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String yourRate;
    String duration;
    String offer;
    return Dialog(
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
                            'Normal rate',
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
                    decoration: InputDecoration(labelText: 'Your Rate'),
                    //initialValue: 'ya rabba ',
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Description can\'t be empty',
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
                    //initialValue: 'ya rabba ',
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Description can\'t be empty',
                    onSaved: (value) => duration = value,
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
                  onPressed: () {},
                )
              ],
            )),
      ),
    );
  }
}
