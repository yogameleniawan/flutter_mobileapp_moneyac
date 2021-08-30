import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  static Future<void> addTransactionList({
    String transactionId,
    String docId,
    String name,
    String uid,
    int inflow,
    int outflow,
    String year,
    String month,
    String weekday,
    int day,
  }) async {
    CollectionReference<
        Map<String,
            dynamic>> transactions = FirebaseFirestore.instance.collection(
        "transaction/$transactionId/transaction_detail/$docId/transaction_list");
    var data = {
      'idDocument': docId,
      'name': name,
      'uid': uid,
      'inflow': inflow,
      'outflow': outflow,
      'year': year,
      'weekday': weekday,
      'month': month,
      'day': day,
      'transaction_id': transactionId
    };
    await transactions
        .add(data)
        .then((value) => print("Transaction List with CustomID added"))
        .catchError((error) => print("Failed to add transaction: $error"));
  }

  static Future<void> addTransactionDetail({
    String transactionId,
    String docId,
    String name,
    String uid,
    int inflow,
    int outflow,
    String year,
    String month,
    String weekday,
    int day,
    String selectedType,
  }) async {
    DocumentReference<Map<String, dynamic>> transaction_detail =
        FirebaseFirestore.instance
            .collection("transaction")
            .doc(transactionId)
            .collection("transaction_detail")
            .doc(docId);
    var dataDetail = {
      'idDocument': docId,
      'uid': uid,
      'inflow': inflow,
      'outflow': outflow,
      'year': year,
      'weekday': weekday,
      'month': month,
      'day': day,
      'transaction_id': transactionId
    };
    await transaction_detail
        .set(dataDetail)
        .then((value) => print("Transaction with CustomID added"))
        .catchError((error) => print("Failed to add transaction: $error"));
  }

  static Future<void> setTransactionDetail({
    String transactionId,
    String docId,
    String name,
    String uid,
    int inflow,
    int inflowDetail,
    int outflow,
    int outflowDetail,
    String year,
    String month,
    String weekday,
    int day,
    String selectedType,
  }) async {
    DocumentReference<Map<String, dynamic>> transaction_detail =
        FirebaseFirestore.instance
            .collection("transaction")
            .doc(transactionId)
            .collection("transaction_detail")
            .doc(docId);
    var dataDetail = {
      'idDocument': docId,
      'uid': uid,
      'inflow': inflow,
      'outflow': outflow,
      'year': year,
      'weekday': weekday,
      'month': month,
      'day': day,
      'transaction_id': transactionId
    };
    transaction_detail
        .set(dataDetail)
        .then((value) => print("Set Transaction Success"))
        .catchError((error) => print("Failed to set transaction: $error"));
  }

  static Future<void> updateAmountUser({
    String uid,
  }) async {
    int totalAmount = 0;
    FirebaseFirestore.instance.collection('transaction/').get().then((value) {
      value.docs.forEach((element) {
        String id = element.id;
        FirebaseFirestore.instance
            .collection('transaction/$id/transaction_detail/')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('transaction/$id/transaction_detail/')
                .doc(element.id)
                .snapshots()
                .listen((value) async {
              int total = value.get('inflow') - value.get('outflow');
              totalAmount = totalAmount + total;
              DocumentReference<Map<String, dynamic>> users =
                  FirebaseFirestore.instance.collection("users").doc(uid);
              var data = {
                'totalAmount': totalAmount,
              };
              await users
                  .update(data)
                  .then((value) => print("Update Amount User"))
                  .catchError(
                      (error) => print("Failed to update amount: $error"));
            });
          });
        });
      });
    });
  }

  static Future<void> updateTransactionFlowMonth({
    String uid,
    String idDocument,
    String idTransactionMonth,
  }) async {
    int totalInflow = 0;
    int totalOutflow = 0;
    FirebaseFirestore.instance
        .collection(
            'transaction/$idDocument/transaction_detail/$idTransactionMonth/transaction_list/')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection(
                'transaction/$idDocument/transaction_detail/$idTransactionMonth/transaction_list/')
            .doc(element.id)
            .snapshots()
            .listen((value) async {
          int inflow = value.get('inflow');
          int outflow = value.get('outflow');
          totalInflow = totalInflow + inflow;
          totalOutflow = totalOutflow + outflow;
          DocumentReference<Map<String, dynamic>> transaction =
              FirebaseFirestore.instance
                  .collection("transaction")
                  .doc(idDocument)
                  .collection("transaction_detail")
                  .doc(idTransactionMonth);
          var data = {
            'inflow': totalInflow,
            'outflow': totalOutflow,
          };
          await transaction
              .update(data)
              .then((value) => print("Transaction Flow Month Updated"))
              .catchError((error) =>
                  print("Failed to update transaction month: $error"));
        });
      });
    });
  }

  static Future<void> updateTransactionListDefault({
    String idDocument,
    String idDocumentDetail,
  }) async {
    DocumentReference<Map<String, dynamic>> document = FirebaseFirestore
        .instance
        .collection("transaction")
        .doc(idDocument)
        .collection("transaction_detail")
        .doc(idDocumentDetail);
    var data = {
      'inflow': 0,
      'outflow': 0,
    };
    await document
        .update(data)
        .then((value) => print("Update Amount User"))
        .catchError((error) => print("Failed to update amount: $error"));
  }

  static Future<void> updateTransactionDetailDefault({
    String idDocument,
  }) async {
    DocumentReference<Map<String, dynamic>> document =
        FirebaseFirestore.instance.collection("transaction").doc(idDocument);
    var data = {
      'inflow': 0,
      'outflow': 0,
    };
    await document
        .update(data)
        .then((value) => print("Update Amount User"))
        .catchError((error) => print("Failed to update amount: $error"));
  }

  static Future<void> updateAmountDefault({
    String uid,
  }) async {
    DocumentReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection("users").doc(uid);
    var data = {
      'totalAmount': 0,
    };
    await users
        .update(data)
        .then((value) => print("Update Amount User"))
        .catchError((error) => print("Failed to update amount: $error"));
  }

  static Future<void> updateTransactionFlow({
    String idDocument,
  }) async {
    int totalInflow = 0;
    int totalOutflow = 0;
    FirebaseFirestore.instance
        .collection('transaction/$idDocument/transaction_detail/')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('transaction/$idDocument/transaction_detail/')
            .doc(element.id)
            .snapshots()
            .listen((value) async {
          int inflow = value.get('inflow');
          int outflow = value.get('outflow');
          totalInflow = totalInflow + inflow;
          totalOutflow = totalOutflow + outflow;
          DocumentReference<Map<String, dynamic>> transaction =
              FirebaseFirestore.instance
                  .collection("transaction")
                  .doc(idDocument);
          var data = {
            'inflow': totalInflow,
            'outflow': totalOutflow,
          };
          await transaction
              .update(data)
              .then((value) => print("Transaction Flow Year Updated"))
              .catchError(
                  (error) => print("Failed to update transaction: $error"));
        });
      });
    });
  }

  static Future<void> updateTransactionDetail({
    String transactionId,
    String docId,
    String name,
    String uid,
    int inflow,
    int inflowDetail,
    int outflow,
    int outflowDetail,
    String year,
    String month,
    String weekday,
    int day,
    String selectedType,
  }) async {
    DocumentReference<Map<String, dynamic>> transaction_amount =
        FirebaseFirestore.instance
            .collection("transaction")
            .doc(transactionId)
            .collection("transaction_detail")
            .doc(docId);
    int inflowTotal = inflow + inflowDetail;
    int outflowTotal = outflow + outflowDetail;
    if (selectedType == "Inflow") {
      var dataInflow = {
        'inflow': inflowTotal,
        'outflow': outflowDetail,
      };
      transaction_amount
          .update(dataInflow)
          .then((value) => print("Transaction Month Updated"))
          .catchError((error) => print("Failed to update transaction: $error"));
    } else if (selectedType == "Outflow") {
      var dataOutflow = {
        'inflow': inflowDetail,
        'outflow': outflowTotal,
      };
      await transaction_amount
          .update(dataOutflow)
          .then((value) => print("Transaction Month Updated"))
          .catchError((error) => print("Failed to update transaction: $error"));
    }
  }

  static Future<void> updateTransaction({
    String docId,
    String idDocument,
    String uid,
    int inflow,
    int outflow,
    String year,
    String month,
  }) async {
    DocumentReference<Map<String, dynamic>> transactions =
        FirebaseFirestore.instance.collection('/transaction').doc(docId);
    var data = {
      'idDocument': idDocument,
      'uid': uid,
      'inflow': inflow,
      'outflow': outflow,
      'year': year,
      'month': month,
    };
    await transactions
        .set(data)
        .then((value) => print("Transaction Updated"))
        .catchError((error) => print("Failed to update transaction: $error"));
  }

  static Future<void> updateNameUser({
    String uid,
    String name,
  }) async {
    DocumentReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection("users").doc(uid);
    var data = {'name': name};
    users.update(data);
  }

  static Future<void> updateEmailUser({
    String uid,
    String email,
  }) async {
    DocumentReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection("users").doc(uid);
    var data = {'email': email};
    users.update(data);
  }

  static Stream<QuerySnapshot> readTransaction({String month, String uid}) {
    var transactionCollection = FirebaseFirestore.instance
        .collection('transaction')
        .where('month', isEqualTo: month)
        .where('uid', isEqualTo: uid);

    return transactionCollection.snapshots();
  }

  static Stream<QuerySnapshot> readTransactionList(
      {String transactionId,
      String idDocument,
      String month,
      String year,
      String uid}) {
    var transactionListCollection = FirebaseFirestore.instance
        .collection(
            'transaction/$transactionId/transaction_detail/$idDocument/transaction_list/')
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .where('uid', isEqualTo: uid);

    return transactionListCollection.snapshots();
  }

  static Future<void> deleteTransaction({
    String idDocument,
  }) async {
    var transactionDocument =
        FirebaseFirestore.instance.collection('transaction').doc(idDocument);

    await transactionDocument
        .delete()
        .whenComplete(() => print('List deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<void> deleteTransactionList({
    String idTransactionDetail,
    String idDocumentTransaction,
    String listId,
  }) async {
    var transactionDocument = await FirebaseFirestore.instance
        .collection(
            'transaction/$idTransactionDetail/transaction_detail/$idDocumentTransaction/transaction_list')
        .doc(listId);
    await transactionDocument
        .delete()
        .whenComplete(() => print('List deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<void> deleteTransactionDetail({
    String idDocument,
    String idDetail,
    String idList,
  }) async {
    var transactionDocument = FirebaseFirestore.instance
        .collection(
            'transaction/$idDocument/transaction_detail/$idDetail/transaction_list')
        .doc(idList);

    await transactionDocument
        .delete()
        .whenComplete(() => print('List deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<void> deleteAllTransactionDetail({
    String idDocument,
  }) async {
    var transactionDetailDocument = FirebaseFirestore.instance
        .collection('transaction/$idDocument/transaction_detail')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('transaction/$idDocument/transaction_detail')
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
        String idDetail = element.id;
        FirebaseFirestore.instance
            .collection(
                'transaction/$idDocument/transaction_detail/$idDetail/transaction_list')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            deleteTransactionDetail(
                idDocument: idDocument, idDetail: idDetail, idList: element.id);
          });
        });
      });
    });
  }
}
