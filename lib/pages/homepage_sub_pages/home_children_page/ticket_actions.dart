import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/sendGmail.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_download_pdf.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_ticket.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/list_of_clients.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_message_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_parent_page.dart';
import 'package:ujap/services/api.dart';

class TicketActions extends StatefulWidget {
  @override
  _TicketActionsState createState() => _TicketActionsState();
}

class _TicketActionsState extends State<TicketActions> {
  List<String> _btn = ['btn6','btn5'];
  bool _downloadLoading = false;
  int _loadingPercent = 0;

  Stream _loading()async*{
    setState(() {
      loading_indicator = loading_indicator;
      _loadingPercent = int.parse(loading_indicator.toString().replaceAll('%', ''));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    floating_action = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      height: screenheight,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.only(right: screenwidth < 700 ? screenheight/23 :  screenheight/33,bottom: screenwidth < 700 ? 20 : 30),
              width: floating_action ? screenwidth < 500 ? 270 : 300  : 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000)
              ),
              child:  ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(247, 171, 45, 0.9),
                            borderRadius: BorderRadius.circular(1000)
                        ),
                      ),
                      Builder(
                        builder: (context)=> GestureDetector(
                          child: Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 171, 45, 0.9),
                                  borderRadius: BorderRadius.circular(1000)
                              ),
                              child: Image(
                                color: Colors.white,
                                image: AssetImage('assets/home_icons/email.png'),
                              )
                          ),
                          onTap: (){
                              opponentTeam = teamNameandlogo[0]['name'].toString();
                              sendGmailValidation = true;
                              uploadPDF();
                              Navigator.push(context, PageTransition(child:  SendGmail(
                              ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                              },
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(238, 124, 65, 0.9),
                            borderRadius: BorderRadius.circular(1000)
                        ),
                      ),
                      Builder(
                        builder: (context)=> GestureDetector(
                          child: Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 124, 65, 0.9),
                                  borderRadius: BorderRadius.circular(1000)
                              ),
                              child: Image(
                                color: Colors.white,
                                image: AssetImage('assets/home_icons/message.png'),
                              )
                          ),
                          onTap: (){
                            setState(() {
                              print(ticketFilename.toString());
                              uploadPDF();
                              currentindex = 2;
                              indexListener.update(data: 2);
                              Navigator.push(context, PageTransition(child: NewMessage(), type: PageTransitionType.leftToRightWithFade));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  // StreamBuilder(
                  //   stream:  _loading(),
                  //        builder: (context, snapshot) {
                  //     return
                        Container(
                        padding: EdgeInsets.all(5),
                        child: Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color:  _downloadLoading && loadingIndicator != 100 ? Colors.white : Color.fromRGBO(46, 170, 221, 0.9),
                                  borderRadius: BorderRadius.circular(1000)
                              ),
                            ),
                            _downloadLoading && loadingIndicator != 100 ?
                            Stack(
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                    )),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Icon(Icons.file_download,color: kPrimaryColor,size: 25,),
                                  ),
                                )
                              ],
                            )
                                : Builder(
                              builder: (context)=> GestureDetector(
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(46, 170, 221, 0.9),
                                        borderRadius: BorderRadius.circular(1000)
                                    ),
                                    child: loadingIndicator == 100 ?
                                    Container(
                                      child: Center(
                                          child: Icon(Icons.visibility,size: 27,color: Colors.white,)),
                                    ) :
                                    Container(
                                      child: Center(
                                          child: Icon(Icons.file_download,size: 27,color: Colors.white,)),
                                    )
                                ),
                                onTap: (){
                                   if (loadingIndicator == 100) {
                                    Navigator.push(context, PageTransition(child: ViewDownloadPdf(
                                    ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                  }
                                  else{
                                   setState(() {
                                     showSnackBar_download(context, 'Démarrage du téléchargement du ticket ..',Icon(Icons.file_download));
                                     uploadPDF();
                                     _downloadLoading = true;
                                   });
                                  }
                                },
                              ),
                            ),

                          ],
                        ),
                    //   );
                    // }
                  ),
                ],
              ),
            ),
          ),
          for (var x = 0; x < 2; x++)
            events_allocation == 0 ? Container() : Container(
              alignment: Alignment.bottomRight,
              width: screenwidth,
              child: Container(
                margin: EdgeInsets.only(right: 25,bottom: 20),
                width: screenwidth < 700 ? 60 : 80,
                height: screenwidth < 700 ? 60 : 80,
                child: FloatingActionButton(
                  heroTag: _btn[x],
                  backgroundColor: Color.fromRGBO(1, 81, 147, 0.9),
                  child: Icon(Icons.more_vert,size: screenwidth < 700 ? 30 : 40),
                  onPressed: (){
                    if (events_allocation == 0){
                      showSnackBar(context, 'Désolé, vous ne pouvez pas utiliser cette fonctionnalité sans ticket de match');
                    }else{
                      if (floating_action == true){
                        setState(() {
                          floating_action = false;
                        });
                      }
                      else{
                        setState(() {
                          floating_action = true;
                        });
                      }
                    }
                  },

                ),
              ),
            ),
        ],
      ),
    );
  }
}
