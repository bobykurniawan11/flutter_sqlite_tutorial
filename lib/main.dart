import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:offlinedatabase/user.dart';

import 'database_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _namaController = TextEditingController();

  @override
  void initState() {
    checkCurrentData();
  }

  checkCurrentData() {
    DatabaseHandler.db.getAllData().then((value) {
      for (var data in value) {
        print(data.nama);
      }
    });
  }

  Future<List<User>> fetchData() async {
    print("fetch");
    return await DatabaseHandler.db.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showForm(context);
        },
      ),
      body: FutureBuilder<List<User>>(
          future: fetchData(),
          initialData: [],
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData == true) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //var parsedDate = DateTime.parse(snapshot.data[index].event_date);
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.greenAccent,
                          icon: Icons.edit,
                          onTap: () {
                            _emailController.text = snapshot.data[index].email;
                            _namaController.text = snapshot.data[index].nama;
                            showEditForm(context);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            DatabaseHandler.db
                                .deleteData(snapshot.data[index].email);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                          },
                        ),
                      ],
                      child: ListTile(
                        title: Text(snapshot.data[index].nama),
                        subtitle: Text(snapshot.data[index].email),
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  void showForm(context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: EdgeInsets.all(10),
            child: new Wrap(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                ),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.greenAccent,
                      child: Text("Simpan"),
                      onPressed: () {
                        User users = new User(
                            email: _emailController.text,
                            nama: _namaController.text);
                        DatabaseHandler.db.addData(users);
                        _emailController.text = "";
                        _namaController.text = "";
                        Navigator.pop(context);
                        setState(() {
                          fetchData();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditForm(context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: EdgeInsets.all(10),
            child: new Wrap(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                ),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.greenAccent,
                      child: Text("Ubah Data"),
                      onPressed: () {
                        User users = new User(
                            email: _emailController.text,
                            nama: _namaController.text);
                        DatabaseHandler.db.updateUser(users);
                        fetchData();
                        _emailController.text = "";
                        _namaController.text = "";
                        Navigator.pop(context);
                        setState(() {
                          fetchData();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
