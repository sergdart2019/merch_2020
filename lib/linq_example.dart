void main() {
  List<int> numbers = <int>[4, 2, 7, 2, 7, 8, 0];
  var result = numbers.where((val) => val < 5);
  // print(result); /* [4, 2, 2, 0] */

  var numbersSetResult = numbers.toSet(); // removes duplicates
  print(numbersSetResult); // {4, 2, 7, 8, 0}
  // .union() .intersection()

  var numsAndStrings = <dynamic>['1', 3, 4.5, 3, 'Serg'];
  var resDouble = numsAndStrings.where((val) => val is double);
  var resString =
      numsAndStrings.where((val) => val is String && val.length < 2);
  var numsInt = numsAndStrings.where((val) => val is int).toSet();
  print(resDouble); // (4.5)
  print(resString); // (1)
  print(numsInt); // {3}

  List<Customer> listCustomer = <Customer>[
    Customer(1, 'John', [
      Order(1, 220.0, DateTime(2015, 9, 1)),
    ]),
    Customer(3, 'Will', [
      Order(4, 180.0, DateTime(2015, 9, 21)),
      Order(5, 155.0, DateTime(2015, 9, 16)),
    ]),
    Customer(2, 'Marc', [
      Order(2, 1020.0, DateTime(2015, 9, 15)),
      Order(3, 2040.0, DateTime(2015, 9, 10)),
    ]),
  ];

  var result1 = listCustomer
      .where((Customer c) => c.idCustomer == 2)
      .map((Customer c) => '${c.idCustomer} ${c.nameCustomer}');
  // print(result1); /* (2 Marc) */

  var result2 = listCustomer
      .where((Customer c) => c.nameCustomer.startsWith('W'))
      .map((Customer c) => {'id': c.idCustomer, 'name': c.nameCustomer});
  // print(result2); /* ({id: 3, name: Will}) */

  var result3 = listCustomer
      .expand((Customer c) => c.listOrderCustomer)
      .where((Order o) => o.priceOrder > 1000)
      .map((Order o) => '${o.idOrder} ${o.priceOrder}');
  // print(result3); /* (2 1020.0, 3 2040.0) */

  var result4 = listCustomer
      .expand((Customer c) => c.listOrderCustomer
          .map((Order o) => '${c.nameCustomer} ${o.idOrder} ${o.priceOrder}'))
      .toList();
  // result4.forEach((val) => print(val));
  /*
  John 1 220.0
  Marc 2 1020.0
  Marc 3 2040.0
  Will 4 180.0
  Will 5 155.0
   */
  result4.sort();
  // print(result4);

  var result5 = listCustomer
      .expand((Customer c) => c.listOrderCustomer
          .where((Order o) => o.priceOrder > 1000)
          .map((Order o) => '${c.nameCustomer} ${o.idOrder} ${o.priceOrder}'))
      .take(
          1) // .skip(1) .takeWhile((val) => val...) .first() .elementAt(index)
      .toList();
  // result5.forEach((val) => print(val));
  /*
  Marc 2 1020.0
   */
}

class Customer {
  int idCustomer;
  String nameCustomer;
  List<Order> listOrderCustomer;

  Customer(this.idCustomer, this.nameCustomer, this.listOrderCustomer);
}

class Order {
  int idOrder;
  double priceOrder;
  DateTime timeOrder;

  Order(this.idOrder, this.priceOrder, this.timeOrder);
}
