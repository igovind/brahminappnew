import 'package:flutter/material.dart';

class NewsFeedTile extends StatelessWidget {
  final imageUrl;
  final title;
  final subtitle;
  final description;
  final date;

  const NewsFeedTile(
      {Key key,
      this.imageUrl,
      this.title,
      this.subtitle,
      this.description,
      this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              title == null
                  ? SizedBox()
                  : Text(
                      title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
              subtitle == null
                  ? SizedBox()
                  : Divider(
                      thickness: 0.5,
                      color: Colors.black54,
                    ),
              subtitle == null
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ),
              description == null
                  ? SizedBox()
                  : SizedBox(
                      height: 30,
                    ),
              description == null ? SizedBox() : Text(description),
              imageUrl == null
                  ? SizedBox()
                  : SizedBox(
                      height: 20,
                    ),
              imageUrl == null
                  ? SizedBox()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrl),
                    ),
              date == null
                  ? SizedBox()
                  : SizedBox(
                      height: 20,
                    ),
              date == null
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        date,
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
