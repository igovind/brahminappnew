import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  final uid;

  const ContactUsPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Contact us'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('punditUsers/$uid/issues')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.size,
                  itemBuilder: (context, index) {
                    final title = snapshot.data.docs[index].data()['title'];
                    final description =
                        snapshot.data.docs[index].data()['description'];
                    final check = snapshot.data.docs[index].data()['flag'];
                    final Timestamp date =
                        snapshot.data.docs[index].data()['date'];

                    final DateTime tdate =
                        date == null ? DateTime.now() : date.toDate();
                    final String d =
                        'on ${tdate.day}/${tdate.month}/${tdate.year} at ${tdate.hour}:${tdate.minute}';

                    return Column(
                      children: [
                        Align(
                          alignment: check == 'sender'
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                color: check == 'sender'
                                    ? Colors.grey[200]
                                    : Colors.deepOrange[100],
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                title == null
                                    ? SizedBox()
                                    : Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black54,
                                ),
                                description == null
                                    ? SizedBox()
                                    : Text(description),
                                date == null
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 12,
                                      ),
                                date == null
                                    ? SizedBox()
                                    : Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          d,
                                          style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.black54),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFFffbd59),
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              child: IssuePad(
                uid: uid,
              ));
        },
      ),
    );
  }
}

class IssuePad extends StatelessWidget {
  final uid;

  const IssuePad({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKeyU = GlobalKey<FormState>();

    String title;
    String description;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKeyU,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Write issue',
                    style: TextStyle(fontSize: 28, color: Colors.black54),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title of your issue'),
                  validator: (value) =>
                      value.isNotEmpty ? null : 'Title can\'t be empty',
                  onSaved: (value) => title = value,
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Description of your issue'),
                  validator: (value) =>
                      value.isNotEmpty ? null : 'Description can\'t be empty',
                  onSaved: (value) => description = value,
                  maxLines: 5,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomRaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () {
                    if (_formKeyU.currentState.validate()) {
                      _formKeyU.currentState.save();
                      final gid = DateTime.now().toIso8601String();
                      FirebaseFirestore.instance
                          .collection('issues')
                          .doc(gid)
                          .set({
                        'title': title,
                        'description': description,
                        'flag': 'sender',
                        'date': FieldValue.serverTimestamp(),
                        'uid': uid,
                      });
                      FirebaseFirestore.instance
                          .collection('punditUsers/$uid/issues')
                          .doc(gid)
                          .set({
                        'title': title,
                        'description': description,
                        'flag': 'sender',
                        'date': FieldValue.serverTimestamp(),
                        'uid': uid,
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  borderRadius: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
