import 'package:brahminapp/app/home_page/drawer_tiles/puja_offering/catagories.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Category> trendingPujaList = [];
List<String> trendingPujaNameList = [];

class AddAndEditPuja extends StatefulWidget {
  final String uid;
  final DocumentSnapshot docSnap;

  const AddAndEditPuja({Key key, @required this.uid, @required this.docSnap})
      : super(key: key);

  @override
  _AddAndEditPujaState createState() => _AddAndEditPujaState();
}

class _AddAndEditPujaState extends State<AddAndEditPuja> {
  final _formKey = GlobalKey<FormState>();
  String puja = "Select puja";
  bool other = false;
  String _name;
  double _rate;
  String _benefits;
  String _samagri;
  String _additionalDisctription;
  String _time;
  String hr;
  Map keymap = {};
  Map samMap = {};
  dynamic keyword;

  int index = 0;

  //String _serviceId=widget.database
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    // if (_validateAndSaveForm()&&keyword!=null) {
    try {
      if (widget.docSnap == null) {
        if (_validateAndSaveForm() && keyword != null) {
          final String serviceId = DateTime.now().toIso8601String();
          FireStoreDatabase(uid: widget.uid).setPujaOffering(data: {
            'puja': _name,
            'price': _rate + 0.1,
            'Benefit': _benefits,
            'swastik':0,
            //'The significance or benefits of performing Lakshmi pooja are as given below: Family life becomes more harmonious– To each & every person in the world, their families are the most treasured people. Performing Lakshmi pooja with all the family members creates a sense of harmony & ensures a peaceful environment at home',
            'PanditD': _additionalDisctription,
            //'2 pandit will come .One will be purohit and one will be in practice pandit',
            'Pujan Samagri': _samagri,
            // 'दिवाली पूजा के लिए रोली यानी टीका, चावल (अक्षत), पान-सुपारी, लौंग, इलायची, धूप, कपूर, घी, तेल, दीपक, कलावा, नारियल, गंगाजल, फल, फूल, मिठाई, दूर्वा, चंदन, मेवे, खील, बताशे, चौकी, कलश, फूलों की माला, शंख, लक्ष्मी-गणेश की मूर्ति, थाली, चांदी का सिक्का, 11 दिए और इससे ज्यादा दिये अपनी श्रृद्धानुसार एकत्रित कर लें।',
            'time': _time,
            'keyword': keyword == null ? '#' + _name + '/' : keyword,
            'subscriber': 0,
            'profit': 0.1,
            'serviceId': serviceId,
          }, pid: serviceId).whenComplete(
              () => FireStoreDatabase(uid: widget.uid).updateKeyword(
                    keyword == null ? '#' + _name + '/' : keyword,
                  ));
        }
      } else {
        if (_validateAndSaveForm()) {
          FireStoreDatabase(uid: widget.uid).updatePujaOffering(data: {
            'puja': _name,
            'price': _rate,
            'Benefit': _benefits,
            'PanditD': _additionalDisctription,
            'Pujan Samagri': _samagri,
            'time': _time,
            // 'keyword': keyword == null ? '#' + _name + '/' : keyword,
          }, pid: widget.docSnap.id).whenComplete(
              () => FireStoreDatabase(uid: widget.uid).updateKeyword(
                    keyword == null ? '#' + _name + '/' : keyword,
                  ));
        }
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docSnap != null) {
      _name = widget.docSnap.data()['puja'];
      _rate = widget.docSnap.data()['price'];
      _benefits = widget.docSnap.data()['Benefit'];
      _samagri = widget.docSnap.data()['Pujan Samagri'];
      _additionalDisctription = widget.docSnap.data()['PanditD'];
      _time = widget.docSnap.data()['time'];
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        elevation: 2.0,
        title: Text(widget.docSnap != null ? 'Edit puja' : 'Add Puja'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              _submit();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: widget.uid).getTrendingList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          trendingPujaNameList.clear();
          keymap.clear();

          snapshot.data.docs.forEach((element) {
            keymap.addAll({element.data()['name']: element.id});
            samMap.addAll({element.data()['name']: element.data()['Samagri']});
          });
          print(keymap);
          keymap.forEach((key, value) {
            trendingPujaNameList.add(key);
          });
          //trendingPujaNameList.add('Others');
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildFormChildren(),
            ),
          );
        });
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Puja name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate', prefixText: '₹'),
        initialValue: _rate != null ? '$_rate' : '',
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _rate = double.tryParse(value) ?? 0,
      ),
      TextFormField(
        initialValue: _time,
        decoration:
            InputDecoration(labelText: 'Duration in min'),
        validator: (value) =>
            value.isNotEmpty ? null : 'Duration can\'t be empty',
        onSaved: (value) => _time = value, // = int.tryParse(value) ?? 0,
      ),
      other
          ? TextFormField(
              decoration: InputDecoration(labelText: 'Pujan samagri'),
              initialValue: _samagri,
              validator: (value) =>
                  value.isNotEmpty ? null : 'Pujan samagri can\'t be empty',
              onSaved: (value) => _samagri = value,
            )
          : SizedBox(),
      TextFormField(
        decoration: InputDecoration(labelText: 'Benefits from this puja'),
        initialValue: _benefits,
        validator: (value) =>
            value.isNotEmpty ? null : 'Benefits can\'t be empty',
        onSaved: (value) => _benefits = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Additional Description'),
        initialValue: _additionalDisctription,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _additionalDisctription = value,
      ),
      widget.docSnap != null
          ? SizedBox()
          : Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Choose Category",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                SizedBox(width: 15),
                DropdownButton<String>(
                  hint: Text("$puja"),
                  items: trendingPujaNameList.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      puja = value;
                      if (value == "Others") {
                        setState(() {
                          other = true;
                        });
                      } else {
                        setState(() {
                          _samagri = samMap[value];
                          keyword = keymap[value];
                          other = false;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
      SizedBox(
        height: 50,
      ),
    ];
  }
}
