import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsFeedSextion extends StatelessWidget {
  final uid;

  const NewsFeedSextion({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=Clt8Exonaus");
    print(videoId);
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    // BBAyRBTfsOU

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 9) {
            return SizedBox(
              height: 30,
            );
          }
          if (index == 0) {
            return SizedBox(
              height: 10,
            );
          }
          if (index == 2) {
            return Container(
              child: YoutubePlayer(
                controller: _controller,
                liveUIColor: Colors.amber,
              ),
            );
          }
          return NewFeedTile();
        },
      ),
    );
  }
}

class NewFeedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Colors.white,
      ),
      // height: 320,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 20),
            //color: Colors.grey[300],
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              //  borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://cdn11.bigcommerce.com/s-x49po/images/stencil/1280x1280/products/48724/64797/1581679193548_low__36768.1581921507.jpg?c=2",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Getting more profile views can #help you get found for the right opportunity"),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.deepOrangeAccent,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text("456"),
                      IconButton(
                          icon: Icon(Icons.thumb_up_alt), onPressed: () {}),
                    ],
                  ),
                  Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text("5636"),
                      IconButton(icon: Icon(Icons.comment), onPressed: () {})
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  IconButton(icon: Icon(Icons.save), onPressed: () {})
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
