import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkBloc extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

   getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref = firestore.collection('users').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap['loved items'];
    List filteredData = [];
    if (d.isNotEmpty) {
      try {
        await firestore
            .collection('contents')
            .where('timestamp', whereIn: d).limit(10)
            .get()
            .then((QuerySnapshot snap) {
          filteredData = snap.docs;
        });
      }catch(e){
        ref.update({
          'loved items':FieldValue.arrayRemove(d)
        });
      }
    }

    notifyListeners();
    return filteredData;
  }
}
