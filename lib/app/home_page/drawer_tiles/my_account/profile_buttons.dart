import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
class ProfileButtons extends StatelessWidget {
  final String title;
  final Widget child;
  final Icon icon;

  const ProfileButtons({Key key, this.title, this.child, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRaisedButton(
        color: Colors.deepOrange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: icon,
              onPressed: null,
              iconSize: 20,
              color: Colors.white,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
          ],
        ),
        borderRadius: 20,
        onPressed: () {
          showDialog(context: context, child: Container(child: child));
        });
  }
}
