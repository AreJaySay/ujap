import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/event_listview.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/no_data_fetch.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/past_events_matches.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/push_notification_enable_listener.dart';
import 'package:ujap/services/searches/search_service.dart';
// import 'package:worm_indicator/shape.dart';
// import 'package:worm_indicator/worm_indicator.dart';
import 'package:http/http.dart' as http;

class Home_parent extends StatefulWidget {
  @override
  _Home_parentState createState() => _Home_parentState();
}

class _Home_parentState extends State<Home_parent> {
  ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    middleController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: adListener.stream$,
      builder: (context, snapshot) {
        return Scaffold(
                        body: Container(
                          alignment: Alignment.topCenter,
                        width: screenwidth,
                        height: screenheight,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                             Container(
                              width: double.infinity,
                              height: bannerDisplay.position == 1 && snapshot.hasData && snapshot.data ? 60 : 50,
                              color: kPrimaryColor.withOpacity(0.83),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                shrinkWrap: true,
                                controller: _scrollController,
                                slivers: [
//                                  SliverToBoxAdapter(
//                                    child: bannerDisplay.position == 1 && snapshot.data ? Container(
//                                      width: double.infinity,
//                                      height: 60,
//                                      color: kPrimaryColor.withOpacity(0.83),
//                                    ) : Container(),
//                                  ),
                                  SliverToBoxAdapter(
                                      child: snapshot.hasData && snapshot.data ? Container(
//                                          margin: EdgeInsets.only(top: bannerDisplay.position == 1 ? 60 : 0),
                                          color: kPrimaryColor,
                                          child: bannerDisplay.showBanner(context,position: 1)
                                      ) : Container()
                                  ),
                                  SliverAppBar(
                                    pinned: false,
                                    elevation: 0,
                                    floating: true,
//                                    shape: ContinuousRectangleBorder(
//                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(100))
//                                    ),
                                    backgroundColor: Colors.white,
                                    forceElevated: false,
                                    automaticallyImplyLeading: false,
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.white
                                                )
                                            )
                                        ),
                                        child:  EventsList(),
                                      ),
                                    ),
                                    expandedHeight: screenwidth < 700 ? BannerDisplay().heightCounter() - 50 : BannerDisplay().heightCounter() - 40,
                                    titleSpacing: 0,

                                  ),
                                  SliverToBoxAdapter(
                                      child: snapshot.hasData && snapshot.data ? Container(
                                          child: bannerDisplay.showBanner(context,position: 2)
                                      ) : Container()
                                  ),
                                  SliverList(
                                    delegate: SliverChildListDelegate(
                                        [
                                          Container(
                                            width: screenwidth,
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            color: Colors.white,
                                            width: double.infinity,
                                            height: screenwidth < 700 ? screenwidth/3.5 :  screenwidth/4.5,
                                            child: Past_events_matches(),
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: Bottom_listview_data(),
                                          )
                                        ]
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    )
            );
      }
    );

  }

}

