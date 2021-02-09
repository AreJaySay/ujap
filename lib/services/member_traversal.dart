class MemberTraverser{
  List<int> getIds({List from}){
    List<int> ids = [];
    for(var clients in from){
      ids.add(int.parse(clients['client_id'].toString()));
    }
    return ids;
  }

  List<int> getIdsRaw({List from}){
    List<int> ids = [];
    for(var client in from){
      ids.add(int.parse(client['id'].toString()));
    }
    return ids;
  }
}