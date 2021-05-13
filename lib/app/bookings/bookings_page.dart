import 'package:brahminapp/app/bookings/booking_history.dart';
import 'package:brahminapp/app/bookings/booking_request.dart';
import 'package:brahminapp/app/bookings/upcoming.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import '../languages.dart';

class BookingsPage extends StatefulWidget {
  final UserId userId;
  final language;

  BookingsPage({Key key, this.userId, this.language}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      new Tab(
        text: Language(code: widget.language, text: [
          "Request ",
          "निवेदन ",
          "অনুরোধ ",
          "கோரிக்கை ",
          "అభ్యర్థన "
        ]).getText,
      ),
      new Tab(
        text: Language(code: widget.language, text: [
          "Upcoming ",
          "आगामी ",
          "আসন্ন ",
          "வரவிருக்கும் ",
          "రాబోయే "
        ]).getText,
      ),
      new Tab(
        text: Language(
                code: widget.language,
                text: ["History ", "समाप्त ", "সমাপ্ত ", "முடி ", "ముగించు "])
            .getText,
      )
    ];
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
      appBar: new AppBar(
        toolbarHeight: height(65),
        backgroundColor: Colors.white,
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: height(25),
            indicatorColor: Colors.orange,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
            // Other flags
            // indicatorRadius: 1,
            // insets: EdgeInsets.all(1),
            // padding: EdgeInsets.all(10)
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      //backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
          stream: FireStoreDatabase(uid: widget.userId.uid).getBookingRequest,
          builder: (context, bookingRequestSnapshot) {
            if (bookingRequestSnapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder<QuerySnapshot>(
                stream:
                    FireStoreDatabase(uid: widget.userId.uid).getUpComingPuja,
                builder: (context, upcomingPujaSnapshot) {
                  if (upcomingPujaSnapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder<QuerySnapshot>(
                      stream:
                          FireStoreDatabase(uid: widget.userId.uid).getHistory,
                      builder: (context, bookingHistorySnapshot) {
                        if (bookingHistorySnapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return TabBarView(
                            controller: _tabController,
                            children: [
                              BookingRequest(
                                language: widget.language,
                                snapshot: bookingRequestSnapshot,
                                userId: widget.userId,
                              ),
                              Upcoming(
                                language: widget.language,
                                userId: widget.userId,
                                snapshot: upcomingPujaSnapshot,
                              ),
                              BookingHistory(
                                language: widget.language,
                                snapshot: bookingHistorySnapshot,
                                userId: widget.userId,
                              ),
                            ]);
                      });
                });
          }),
    );
  }
}
