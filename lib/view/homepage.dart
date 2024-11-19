import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<ExpenseProvider>(context);
    var providerFalse = Provider.of<ExpenseProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,

        title:  Text('Homepage'),
        actions: [
          TextButton(
            onPressed: () async {
              await providerFalse.syncCloudToLocal();
            },
            child: Text(
              ' localdata',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              List<ExpenseModal> notes;
              notes = providerTrue.notesList
                  .map(
                    (e) => ExpenseModal.fromMap(e),
                  )
                  .toList();
              for (int i = 0; i < providerTrue.notesList.length; i++) {
                providerFalse.addDataInStore(
                  id: notes[i].id,
                  title: notes[i].title,
                  amount: double.parse(notes[i].amount),
                  category: notes[i].category,
                  date: notes[i].date,
                );
              }

            },
            child: Icon(Icons.backup,color: Colors.black,)
          ),

        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: InputDecoration(label: Text('Search'),enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),),
          ),
          SizedBox(
            height: 10,
          ),

          FutureBuilder(
            future: providerFalse.readDataFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ExpenseModal> expModal = [];

                expModal = providerTrue.notesList
                    .map(
                      (e) => ExpenseModal.fromMap(e),
                    )
                    .toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: expModal.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        providerTrue.id = expModal[index].id;
                        providerTrue.txttitle.text = expModal[index].title;
                        providerTrue.txtcategory.text =
                            expModal[index].category;
                        providerTrue.txtamount.text = expModal[index].amount;


                      },
                      leading: Text(expModal[index].id.toString()),
                      title: Text(expModal[index].title),
                      subtitle: Text(expModal[index].category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Column(children: [


                        ],),
                          IconButton(
                            onPressed: () async {
                              await providerFalse.deleteDatabase(
                                  id: expModal[index].id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          InkWell(onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Update Expense'),
                                actions: [
                                  TextField(
                                    controller: providerTrue.txttitle,
                                    decoration: InputDecoration(
                                        label: Text('Title'),
                                        enabledBorder: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: providerTrue.txtcategory,
                                    decoration: InputDecoration(
                                        label: Text('Category'),
                                        enabledBorder: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: providerTrue.txtamount,
                                    decoration: InputDecoration(
                                        label: Text('Amount'),
                                        enabledBorder: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          providerTrue.date =
                                          '${DateTime.now().hour}:${DateTime.now().minute}';
                                          providerFalse.updateDatabase(
                                            id: expModal[index].id,
                                            title: providerTrue.txttitle.text,
                                            date: providerTrue.date,
                                            amount: double.parse(
                                                providerTrue.txtamount.text),
                                            category: providerTrue.txtcategory.text,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },child: Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add '),
              actions: [
                TextField(
                  controller: providerTrue.txttitle,
                  decoration: InputDecoration(
                      label: Text('Title'),
                      enabledBorder: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: providerTrue.txtcategory,
                  decoration: InputDecoration(
                      label: Text('Category'),
                      enabledBorder: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: providerTrue.txtamount,
                  decoration: InputDecoration(
                      label: Text('Amount'),
                      enabledBorder: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        providerTrue.id = providerTrue.notesList.length + 1;
                        providerTrue.date =
                            '${DateTime.now().hour}:${DateTime.now().minute}';
                        providerFalse.insertExpenseToDatabase(
                          id: providerTrue.id,
                          title: providerTrue.txttitle.text,
                          date: providerTrue.date,
                          amount: double.parse(providerTrue.txtamount.text),
                          category: providerTrue.txtcategory.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
