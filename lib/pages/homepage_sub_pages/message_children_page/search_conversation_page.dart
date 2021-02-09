import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/string_formatter.dart';

class SearchConversationPage extends StatefulWidget {
  final int channelId;
  SearchConversationPage({@required this.channelId});
  @override
  _SearchConversationPageState createState() => _SearchConversationPageState();
}

class _SearchConversationPageState extends State<SearchConversationPage> {
  TextEditingController _search = new TextEditingController();
  String _searchText = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
              color: kPrimaryColor
          ),
          title: Text("Rechercher une conversation",style: TextStyle(
              color: kPrimaryColor
          ),),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Theme(
                data: ThemeData(
                  primaryColor: kPrimaryColor
                ),
                child: TextField(
                  controller: _search,
                  cursorColor: kPrimaryColor,
                  onChanged: (text) => setState(() => _searchText = text),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    hintText: "Rechercher"
                  ),
                ),
              )
            ),
            Expanded(
              child: StreamBuilder<List>(
                stream: conversationService.convo,
                builder: (context, snapshot) {
                  try{
                    List data = snapshot.data.where((element) => int.parse(element['id'].toString()) == widget.channelId).toList()[0]['messages'].where((element) => element['message'] != null).toList();
                    data.sort((a,b){
                      DateTime aDate = DateTime.parse(a['date_sent'].toString());
                      DateTime bDate = DateTime.parse(b['date_sent'].toString());
                      return bDate.compareTo(aDate);
                    });
                    data = data.where((element) => element['message'].toString().toLowerCase().contains(_search.text.toLowerCase())).toList();
                    if(data != null && data.length > 0){
                      return ListView.builder(
                        itemCount: data.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        itemBuilder: (context, index) => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000),
                                    color: Colors.grey[300],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: data[index]['client']['filename'].toString() == "null" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${data[index]['client']['filename']}')
                                  )
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "${StringFormatter().titlize(data: data[index]['client']['name'])}\n",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "${data[index]['message']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                        )
                                      )
                                    ]
                                  ),
                                )
                              ),
                              RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                    text: "${DateFormat('yyyy/MM/dd').format(DateTime.parse(data[index]['date_sent'].toString().split(' ')[0]))}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13.5
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "\n${DateFormat().add_jms().format(DateTime.parse(data[index]['date_sent']))}"
                                      )
                                    ]
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }else{
                      return Center(
                        child: Text("Pas de messages"),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                    );
                  }catch(e){
                    return Center(
                      child: Text("Oops! Something went wrong, please try again $e"),
                    );
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
