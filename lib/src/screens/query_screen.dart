import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../../database.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  List<Map<String, dynamic>> _queryRows = [];

  final TextEditingController _insertTextController = TextEditingController();
  final TextEditingController _updateIdController = TextEditingController();
  final TextEditingController _updateNameController = TextEditingController();

  @override
  void dispose() {
    _insertTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _queryAll();
    if (kDebugMode) {
      print(_queryRows);
    }
  }

  void _queryAll() async {
    List<Map<String, dynamic>>? queryRows = await DatabaseHelper.instance.queryAll();
    /*  if (kDebugMode) {
    print(queryRows);
    for (Map item in queryRows!) {
      print("${item['_id']}   ${item['name']}");
    } */
    setState(() {
      _queryRows = queryRows as List<Map<String, dynamic>>;
    });
  }

  _insertIntoDb() async {
    String data = _insertTextController.text;
    var i = await DatabaseHelper.instance.insert({DatabaseHelper.columnName: data});
    setState(() {
      _queryAll();
    });

    if (kDebugMode) {
      print('The inserted id is $i');
    }
  }

  _updateDb() async {
    int id = int.parse(_updateIdController.text);
    String name = _updateNameController.text;
    int? rowsUpdated = await DatabaseHelper.instance
        .update({DatabaseHelper.columnId: id, DatabaseHelper.columnName: name});

    setState(() {
      _queryAll();
    });

    if (kDebugMode) {
      print('Updated $rowsUpdated row(s)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLLite'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // for the Insert
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              obscureText: false,
                              controller: _insertTextController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Name',
                              ),
                            ),
                          ),
                          const Gap(10),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(80, 20)),
                            child: const Text('Insert',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (_insertTextController.text.isNotEmpty) {
                                _insertIntoDb();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //const SizedBox(width: 15),
              Row(
                // for the Update
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              maxLength: 3,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: false, signed: false),
                              obscureText: false,
                              controller: _updateIdController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Id',
                                counterText: "",
                              ),
                            ),
                          ),
                          const Gap(3),
                          Expanded(
                            flex: 5,
                            child: TextField(
                              obscureText: false,
                              controller: _updateNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Name',
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(80, 20)),
                              child: const Text('Update',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (_updateIdController.text.isNotEmpty &&
                                    _updateNameController.text.isNotEmpty) {
                                  _updateDb();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _queryRows.length,
                  itemBuilder: (BuildContext context, int index) {
                    return QueryWidget(_queryRows[index]);
                  },
                )),
          ),
        ],
      )),
    );
  }

  Widget QueryWidget(item) {
    return Card(
      color: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                item['_id'].toString(),
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              item['name']!,
              style: const TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () async {
                  await DatabaseHelper.instance.delete(item['_id']);
                  setState(() {
                    _queryAll();
                  });
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  size: 30,
                )),
          )
        ],
      ),
    );
  }
}
