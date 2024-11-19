

import 'package:flutter/material.dart';

import '../helper/dbhelper.dart';
import '../model/model.dart';
import '../service/service.dart';

class ExpenseProvider extends ChangeNotifier {
  List notesList = [];
  var txttitle = TextEditingController();
  var txtcategory = TextEditingController();
  var txtamount = TextEditingController();
  var txtSearch = TextEditingController();
  String date = '';
  int id = 0;

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  void clearAll() {
    txtamount.clear();
    txtcategory.clear();
    txttitle.clear();
    date = '';
    notifyListeners();
  }

  Future<void> syncCloudToLocal() async {
    final snapshot =
    await ExpenseServices.expenseServices.readDataFromStore().first;
    final cloudExpense = snapshot.docs.map(
          (doc) {
        final data = doc.data();
        return ExpenseModal(
          id: data['id'],
          title: data['title'],
          category: data['category'],
          date: data['date'],
          amount: data['amount'].toString(),
        );
      },
    ).toList();

    for (var expense in cloudExpense) {
      bool exists =
      await DatabaseHelper.databaseHelper.expenseExist(expense.id);

      if (exists) {
        await updateDatabase(
          id: expense.id,
          title: expense.title,
          date: expense.date,
          amount: double.parse(expense.amount),
          category: expense.category,
        );
      } else {
        await insertExpenseToDatabase(
          id: expense.id,
          title: expense.title,
          date: expense.date,
          amount: double.parse(expense.amount),
          category: expense.category,
        );
      }
    }
  }

  Future<void> addDataInStore({
    required int id,
    required String title,
    required String date,
    required double amount,
    required String category,
  }) async {
    await ExpenseServices.expenseServices.addDataInStore(
      id: id,
      title: title,
      date: date,
      amount: amount,
      category: category,
    );
  }

  List<ExpenseModal> searchListCategory = [];
  List searchList = [];
  String search = '';

  void getSearch(String value) {
    search = value;
    getCategoryExpense();
    notifyListeners();
  }

  Future<List<Map<String, Object?>>> getCategoryExpense() async {
    return searchList =
    await DatabaseHelper.databaseHelper.getExpenseByCategory(search);
  }

  Future<void> insertExpenseToDatabase({
    required int id,
    required String title,
    required String date,
    required double amount,
    required String category,
  }) async {
    await DatabaseHelper.databaseHelper.addExpenseToDatabase(
      id,
      title,
      date,
      amount.toString(),
      category,
    );
    readDataFromDatabase();
    clearAll();
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    return notesList = await DatabaseHelper.databaseHelper.readAllExpense();
  }

  Future<void> updateDatabase({
    required int id,
    required String title,
    required String date,
    required double amount,
    required String category,
  }) async {
    await DatabaseHelper.databaseHelper.updateExpense(
      id,
      title,
      date,
      amount.toString(),
      category,
    );
    readDataFromDatabase();
    clearAll();
  }

  Future<void> deleteDatabase({required int id}) async {
    await DatabaseHelper.databaseHelper.deleteExpense(id);
    readDataFromDatabase();
    notifyListeners();
  }

  NotesProvider() {
    initDatabase();
  }
}


