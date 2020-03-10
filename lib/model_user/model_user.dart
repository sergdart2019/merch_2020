class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

class Store {
  String name;
  String address;
  List<dynamic> cards;
  String time;
  String user;
  String id;

  Store({
    this.name,
    this.address,
    this.cards,
    this.time,
    this.user,
    this.id,
  });
}

class GreetingCard {
  String id;
  String name;
  String path;

  GreetingCard({this.id, this.name, this.path});
}

class PersonalData {
  String name;
  String address;
  String serviceType;
  String pib;
  String accountNumber;
  String email;
  String commentOne;
  String commentTwo;
  String id;

  PersonalData({
    this.name,
    this.address,
    this.serviceType,
    this.pib,
    this.accountNumber,
    this.email,
    this.commentOne,
    this.commentTwo,
    this.id,
  });
}
