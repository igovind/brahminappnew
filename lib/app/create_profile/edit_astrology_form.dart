import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/custom_multi_select_file.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown/multiple_select.dart';

class EditAstrologyForm extends StatefulWidget {
  final uid;
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const EditAstrologyForm({Key key, this.uid, this.snapshot}) : super(key: key);

  @override
  _EditAstrologyFormState createState() => _EditAstrologyFormState();
}

class _EditAstrologyFormState extends State<EditAstrologyForm> {
  String messagePrice = "0";

  String audioPrice = "0";

  String videoPrice = "0";

  String description = "";

  String expertise = "";

  String experience = "";

  String languages = "";

  bool astrologer = false;

  final _formKeyNK = GlobalKey<FormState>();

  List<DropdownMenuItem> dropdownMenuItem = [
    DropdownMenuItem(
      child: Text("Rs/- 3", style: TextStyle(fontWeight: FontWeight.w700)),
      value: "3",
    ),
    DropdownMenuItem(
      child: Text("Rs/- 5", style: TextStyle(fontWeight: FontWeight.w700)),
      value: "5",
    ),
    DropdownMenuItem(
      child: Text(
        "Rs/- 7",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
      ),
      value: "7",
    ),
  ];

  List<DropdownMenuItem> dropdownMenuItemExperience =
      List<DropdownMenuItem>.generate(
          80,
          (index) => DropdownMenuItem(
                child: Text(
                  "${index + 2} Years",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                value: "${index + 2} Years",
              ));

  List<MultipleSelectItem> elements = [
    MultipleSelectItem.build(
      value: 1,
      display: 'Hindi',
      content: 'Hindi',
    ),
    MultipleSelectItem.build(
      value: 2,
      display: 'English',
      content: 'English',
    ),
    MultipleSelectItem.build(
      value: 3,
      display: 'Kannada',
      content: 'Kannada',
    ),
    MultipleSelectItem.build(
      value: 4,
      display: 'Malayalam',
      content: 'Malayalam',
    ),
    MultipleSelectItem.build(
      value: 5,
      display: 'Odia',
      content: 'Odia',
    ),
    MultipleSelectItem.build(
      value: 6,
      display: 'Punjabi',
      content: 'Punjabi',
    ),
    MultipleSelectItem.build(
      value: 7,
      display: 'Gujarati',
      content: 'Gujarati',
    ),
    MultipleSelectItem.build(
      value: 8,
      display: 'Urdu',
      content: 'Urdu',
    ),
    MultipleSelectItem.build(
      value: 9,
      display: 'Tamil',
      content: 'Tamil',
    ),
    MultipleSelectItem.build(
      value: 10,
      display: 'Telugu',
      content: 'Telugu',
    ),
    MultipleSelectItem.build(
      value: 11,
      display: 'Marathi',
      content: 'Marathi',
    ),
    MultipleSelectItem.build(
      value: 12,
      display: 'Bengali',
      content: 'Bengali',
    ),
  ];

  List _selectedValues = [];

  @override
  void initState() {
    // TODO: implement initState
    messagePrice =
        widget.snapshot == null ? null : widget.snapshot.data.data()["chat"];
    audioPrice =
        widget.snapshot == null ? null : widget.snapshot.data.data()["call"];
    videoPrice =
        widget.snapshot == null ? null : widget.snapshot.data.data()["video"];
    description = widget.snapshot == null
        ? null
        : widget.snapshot.data.data()["description"];
    expertise = widget.snapshot == null
        ? null
        : widget.snapshot.data.data()["expertise"];
    experience = widget.snapshot == null
        ? null
        : widget.snapshot.data.data()["experience"].toString();
    languages =
        widget.snapshot == null ? "" : widget.snapshot.data.data()["language"];
    super.initState();
  }

  bool _validateAndSaveForm() {
    final form = _formKeyNK.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submit() {
    if (_validateAndSaveForm()) {
      String string = "";
      for (int i = 0; i < _selectedValues.length; i++) {
        string = elements[i].content + "," + string;
      }
      FireStoreDatabase(uid: widget.uid).updateData(data:{
        "chat": messagePrice,
        "call": audioPrice,
        "video": videoPrice,
        "description": description,
        "expertise": expertise,
        "experience": experience,
        "astrologer": true,
        "language": string,
        "index": 2,
        'online': false,
        'chatOk': false,
        'callOk': false,
        'videoOk': false,
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection('Avaliable_pundit/${widget.uid}/astro')
            .doc('#astro')
            .set({
          'detail': description ?? 'Not Available',
          'name': 'Astrology',
          'offer': description ?? 'Not Available',
          'keyword': '#astro',
          'image':
          'https://assets.teenvogue.com/photos/5f31a0d6861f578bcc3baf40/16:9/w_2560%2Cc_limit/GettyImages-1192843057.jpg'
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height(40),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          FlatButton(
            onPressed: () {
              _submit();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3)],
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKeyNK,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  radius: 10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price per 10 message"),
                          Container(
                            width: width(100),
                            child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return "This field can't empty";
                                  }
                                  return null;
                                },
                                value: messagePrice,
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none),
                                icon: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.deepOrangeAccent,
                                ),
                                style: TextStyle(color: Colors.green),
                                //value: price,
                                items: dropdownMenuItem,
                                onChanged: (value) {
                                  setState(() {
                                    messagePrice = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Audio call per minute price"),
                          Container(
                            width: width(100),
                            child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return "This field can't empty";
                                  }
                                  return null;
                                },
                                value: audioPrice,
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none),
                                icon: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.deepOrangeAccent,
                                ),
                                style: TextStyle(color: Colors.green),
                                //value: price,
                                items: dropdownMenuItem,
                                onChanged: (value) {
                                  setState(() {
                                    audioPrice = value;
                                  });
                                }),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Video call per minute price"),
                          Container(
                            width: width(100),
                            child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return "This field can't empty";
                                  }
                                  return null;
                                },
                                value: videoPrice,
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none),
                                icon: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.deepOrangeAccent,
                                ),
                                style: TextStyle(color: Colors.green),
                                //value: price,
                                items: dropdownMenuItem,
                                onChanged: (value) {
                                  setState(() {
                                    videoPrice = value;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Year of experience"),
                      Container(
                        width: width(100),
                        child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "This field can't empty";
                              }
                              return null;
                            },
                            //value: experience??"",
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none),
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Colors.deepOrangeAccent,
                            ),
                            style: TextStyle(color: Colors.green),
                            items: dropdownMenuItemExperience,
                            onChanged: (value) {
                              setState(() {
                                experience = value;
                              });
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height(100),
                ),
                CustomContainer(
                  radius: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Language",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("$languages",
                          style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      CustomMultipleDropDown(
                        icon: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        placeholder: 'Select language',
                        disabled: false,
                        values: _selectedValues,
                        elements: elements,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                    radius: 10,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none, labelText: "Expertise"),
                      initialValue: expertise,

                      onSaved: (value) {
                        setState(() {
                          expertise = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This field can't empty";
                        }
                        return null;
                      }, //_benefits = value,
                    )),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                    radius: 10,
                    child: CustomTextField(
                      onSaved: (String newValue) {},
                      lableText: "Additional description",
                      initialValue: description,
                    )),
                SizedBox(
                  height: height(10),
                ),
                /*Row(
                  children: [
                    Text(
                      "Vastu shastra",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomContainer(
                  radius: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "At home",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate per kilometer"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "On video call",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "With map",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                    ],
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
