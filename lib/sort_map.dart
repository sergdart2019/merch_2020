void main() {
  List<Map<String, dynamic>> dataMap = [
    {'name': 'B', 'adresa': 'D'},
    {'name': 'D', 'adresa': 'B'},
    {'name': 'A', 'adresa': 'Cb'},
    {'name': 'Ca', 'adresa': 'Ca'},
    {'name': 'Cb', 'adresa': 'A'},

  ];

  dataMap.sort((e1, e2) => e1['name'].compareTo(e2['name']));
  print(dataMap);
  /* Sortirano po imenu
  [
    {name: A, adresa: Cb},
    {name: B, adresa: D},
    {name: Ca, adresa: Ca},
    {name: Cb, adresa: A},
    {name: D, adresa: B}
  ]
   */
  dataMap.sort((e1, e2) => e1['adresa'].compareTo(e2['adresa']));
  print(dataMap);
  /* Sortirano po adresi
  [
    {name: Cb, adresa: A},
    {name: D, adresa: B},
    {name: Ca, adresa: Ca},
    {name: A, adresa: Cb},
    {name: B, adresa: D}
  ]
   */


  Map map = {1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five'};

  var sortedMap = Map.fromEntries(
      map.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)));

  print(sortedMap); // {5: five, 4: four, 1: one, 3: three, 2: two}

  Map map1 = {1: 'one', 2: 'two', 3: 'three'};

  var transformedMap = map1.map((k, v) {
    return MapEntry('($k)', v.toUpperCase());
  });

  print(transformedMap); // {(1): ONE, (2): TWO, (3): THREE}
}
