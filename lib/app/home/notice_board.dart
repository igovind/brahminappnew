import 'package:flutter/material.dart';

import '../languages.dart';

class NoticeBoard extends StatelessWidget {
  final noticeBoardList;
  final language;

  const NoticeBoard({Key? key, this.noticeBoardList, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)],
          ),
          child: ListTile(
              trailing: noticeBoardList[index]['important']
                  ? Icon(
                      Icons.circle,
                      color: Colors.red,
                    )
                  : null,
              title: Text(
                "${Language(code: language, text: noticeBoardList[index]['title']).getText}",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Container(
                // height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Language(code: language, text: noticeBoardList[index]['subtitle']).getText}",
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.deepOrangeAccent,
                    ),
                    Text(
                      "${Language(code: language, text: noticeBoardList[index]['description']).getText}",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: Image.network(
                            "${noticeBoardList[index]['image']}")),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${noticeBoardList[index]['date'].toDate().day}/${noticeBoardList[index]['date'].toDate().month}/${noticeBoardList[index]['date'].toDate().year}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: noticeBoardList.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
    );
  }
}
