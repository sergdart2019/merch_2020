import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merch_2020/model_user/model_user.dart';

class ServiceDatabase {
  /// Collection reference, once this is called, this creates collection
  final CollectionReference _collectionStores =
      Firestore.instance.collection('stores');
  final CollectionReference _collectionCards =
      Firestore.instance.collection('cards');
  final CollectionReference _collectionPersonalData =
      Firestore.instance.collection('personal_data');

  /// Create and update Personal Data
  Future createPersonalData(
    String name,
    String address,
    String serviceType,
    String pib,
    String accountNumber,
    String email,
    String commentOne,
    String commentTwo,
  ) async {
    final DocumentReference documentReference =
        await _collectionPersonalData.add({});
    final String documentId = documentReference.documentID;
    return await _collectionPersonalData.document(documentId).setData({
      'name': name,
      'address': address,
      'serviceType': serviceType,
      'pib': pib,
      'accountNumber': accountNumber,
      'email': email,
      'commentOne': commentOne,
      'commentTwo': commentTwo,
      'id': documentId,
    });
  }

  List<PersonalData>_personalDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return PersonalData(
        name: doc.data['name'] ?? '-',
        address: doc.data['address'] ?? '-',
        serviceType: doc.data['serviceType'] ?? 0,
        pib: doc.data['pib'] ?? '-',
        accountNumber: doc.data['accountNumber'] ?? '-',
        email: doc.data['email'] ?? '-',
        commentOne: doc.data['commentOne'] ?? '-',
        commentTwo: doc.data['commentTwo'] ?? '-',
        id: doc.data['id'] ?? '-',
      );
    }).toList(); // instead of Iterable, convert to List
  }

  Stream<List<PersonalData>> get personalData {
    return _collectionPersonalData.snapshots().map(_personalDataFromSnapshot);
  }

  /// Create and then update document
  Future createStore(
    String name,
    String address,
    List<String> cards,
    String user,
    String time,
  ) async {
    final DocumentReference documentReference =
        await _collectionStores.add({}); // Create document first!
    final String documentId =
        documentReference.documentID; // Get the document reference
    // Now set the fields with id!
    return await _collectionStores.document(documentId).setData({
      'name': name,
      'address': address,
      'cards': cards,
      'user': user,
      'time': time,
      'id': documentId,
    });
  }

  /// Delete document from DB
  Future deleteStore(String documentId) async {
    return await _collectionStores.document(documentId).delete();
  }

  /// Update Data List
  void updateDataList(List<String> cards, String documentId, String date) {
    _collectionStores
        .document(documentId)
        .updateData({'cards': cards, 'time': date});
  }

  /// Data List from Snapshot
  List<Store> _dataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Store(
        name: doc.data['name'] ?? '-',
        address: doc.data['address'] ?? '-',
        cards: doc.data['cards'] ?? 0,
        time: doc.data['time'] ?? '-',
        user: doc.data['user'] ?? '-',
        id: doc.data['id'] ?? '-',
      );
    }).toList(); // instead of Iterable, convert to List
  }

  /// Get stream Stores
  Stream<List<Store>> get data {
    return _collectionStores.snapshots().map(_dataListFromSnapshot);
  }

  /// DataCards List from Snapshot
  List<GreetingCard> _dataCardsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GreetingCard(
        id: doc.data['id'] ?? '-',
        name: doc.data['name'] ?? '-',
        path: doc.data['path'] ?? '-',
      );
    }).toList();
  }

  /// Get stream Cards
  Stream<List<GreetingCard>> get dataCards {
    return _collectionCards.snapshots().map(_dataCardsListFromSnapshot);
  }
}
