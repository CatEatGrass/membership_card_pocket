import 'package:flutter/material.dart';
import 'package:membership_card_pocket/card_db.dart' as c_db;
import 'package:membership_card_pocket/card.dart' as CARD;
//import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:membership_card_pocket/user.dart';
import 'package:membership_card_pocket/database_helper.dart' as u_db;


void main() {
  runApp(MyApp());
}
/*
String title="Membership card pocket";
void main() {
  runApp(const MyApp());
}
*/
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership card pocket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //const MyHomePage({super.key, required this.title});

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final database_helper = u_db.DatabaseHelper.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Membership card pocket"),),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
          children:<Widget>[
            const Text('Please Login I'
                'n',textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding:  EdgeInsets.all(20),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            /*
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => forgotpassword()));
              },
              child: const Text('Forgot Password',textAlign: TextAlign.center),
            ),

            */
            ElevatedButton(
              onPressed: () async {
                //if(true){
                if((await u_db.DatabaseHelper.instance.checkLogin(_usernameController.text,_passwordController.text))&&
                    _usernameController.text.isNotEmpty&&_passwordController.text.isNotEmpty){
                  await Navigator.push(
                      context,
                      await MaterialPageRoute(builder: (context) => Cardpage()));
                  _showMessageInScaffold("login successful!");
                }else{
                  _showMessageInScaffold("Wrong username or password");
                  Text('Wrong username or password');
                }
              },
              child: Text('Login'),
            ),


            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup()));
              },
              child: const Text('Sign up',textAlign: TextAlign.center),
            ),

          ]
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cardpage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      */
    );
  }
}

class signup extends StatelessWidget {
  @override

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context){
    void _showMessageInScaffold(String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
    Future<int> _insert(username, password) async {
      // row to insert
      Map<String, dynamic> row = {
        u_db.DatabaseHelper.columnName: username,
        u_db.DatabaseHelper.columnPassword: password
      };
      final database_helper = u_db.DatabaseHelper.instance;
      User user = User.fromMap(row);
      final id = await database_helper.insert(user);
      //_showMessageInScaffold("New user id: $id");
      return id;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("LAB TEST 209231")),
      body: ListView(

        children: <Widget> [

          const Text('Sign Up Page',textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.pink,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Register your username and password',textAlign: TextAlign.center),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
              ),
            ),


          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String username = usernameController.text;
              String password = passwordController.text;
              if(usernameController.text.isNotEmpty&&passwordController.text.isNotEmpty&&
                  usernameController.text!=''&&usernameController.text!=null&&
                  passwordController.text!=''&&passwordController.text!=null) {
                  _insert(username, password);
                  _showMessageInScaffold("Registration successful");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
              }else{
                _showMessageInScaffold("Username or password cannot be empty");
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}



class Cardpage extends StatefulWidget{
  @override
  _CardpageState createState() =>_CardpageState();
}

class _CardpageState extends State<Cardpage>{
  String temp=' ';
  final card_db = c_db.DatabaseHelper.instance;
  List<CARD.Card> cards = [];
  List<CARD.Card> cardsByName = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController datasController = TextEditingController();
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController datasUpdateController = TextEditingController();
  TextEditingController idDeleteController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  int onetime=0;
  @override
  Widget build(BuildContext context) {
    //Refresh operation when entering the page
    if(onetime==0) {
      c_db.DatabaseHelper.instance.queryAllRows().then((cards) {
        setState(() {
          this.cards.clear();
          //this.cards.addAll(cards);
          _queryAll();
        });
      });
      onetime++;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Membership Card Pocket"),
      ),body: Container(
      child: Column(
          children: [
            Container(
                child: Text(temp,textScaleFactor: 0.5)
            ),
            const Text('Member card list', textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cards[index].name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<Widget>(builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(title: Text(cards[index].name)),
                                  body: Center(
                                    child: Hero(
                                      tag: cards[index].name,
                                      child: Material(
                                        child: (
                                          Image.network('https://api.qnfcp.xyz/qr/?text=${cards[index].datas}')
                                        )
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                          //subtitle: Text(cards[index].datas),
                          trailing:
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                //_queryAll();
                                c_db.DatabaseHelper.instance.delete(cards[index].id).then((_) {
                                  cards.removeAt(index);
                                  c_db.DatabaseHelper.instance.queryAllRows().then((cards) {
                                    setState(() {
                                      this.cards.clear();
                                      //this.cards.addAll(cards);
                                      _queryAll();
                                    });
                                  });
                                });
                                _showMessageInScaffold('Delete completed.');
                              });
                              //_showMessageInScaffold("Try delete data with id: $index");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        c_db.DatabaseHelper.instance.queryAllRows().then((cards) {
                          setState(() {
                            this.cards.clear();
                            //this.cards.addAll(cards);
                            _queryAll();
                          });
                        });
                      });
                    },
                    child: const Text("Refresh"),
                  ),
                  Container(
                      child: Text(temp,textScaleFactor: 1.5)
                  ),
                ],
              ),
            ),
            const Text('Select the member card to be displayed', textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),Container(
                child: Text(temp,textScaleFactor: 6)
            ),
          ]
      ),

    ),floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanQR()));
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
    );
  }

  // Insert method
  void _insert(name, datas) async {
    // row to insert
    Map<String, dynamic> row = {
      c_db.DatabaseHelper.columnName: name,
      //DatabaseHelper.columnDatas: datas
      c_db.DatabaseHelper.columnDatas: datas
    };

    CARD.Card card = CARD.Card.fromMap(row);
    final id = await card_db.insert(card);
    //_showMessageInScaffold("insert row id: $id");
    _showMessageInScaffold("Successfully added membership card: $name");
  }

  // List all data in database
  void _queryAll() async {
    final allRows = await card_db.queryAllRows();
    cards.clear();
    allRows.forEach((row) => cards.add(CARD.Card.fromMap(row)));
    setState(() {});
  }

  // Select card name
  void _query(name) async {
    final allRows = await card_db.queryRows(name);
    cardsByName.clear();
    allRows.forEach((row) => cardsByName.add(CARD.Card.fromMap(row)));
  }

  // Update existing card
  void _update(id, name, datas) async {
    // row to update
    CARD.Card card = CARD.Card(id, name, datas);
    final rowsAffected = await card_db.update(card);
    _showMessageInScaffold('updated $rowsAffected row(s)');
  }

  // Delete
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await card_db.delete(id);
    _showMessageInScaffold('deleted $rowsDeleted row(s): row $id');
  }

}


class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}


class _ScanQRState extends State<ScanQR> {
  String temp=' ';
  final card_db = c_db.DatabaseHelper.instance;
  List<CARD.Card> cards = [];
  List<CARD.Card> cardsByName = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController datasController = TextEditingController();
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController datasUpdateController = TextEditingController();
  TextEditingController idDeleteController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  String qrCodeResult = 'Not Yet Scanned';

  var key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Member Card'),
      ),
      body: Container(
        color: Colors.white12,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please enter card information:',
              //'FOR TEST: QR Code Result:' + qrCodeResult,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
              width: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Membership card issuer',
                ),
              ),
            ),


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),

                ),

              ),

              onPressed: () async {
                if(nameController.text.isNotEmpty&&nameController.text!=""&&nameController.text!=null){
                  ScanResult codeScanner = await BarcodeScanner.scan();
                  String qrResult =codeScanner.rawContent;
                  String name=nameController.text;
                  setState(() {
                    qrCodeResult = qrResult;
                    _insert(name, qrResult);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cardpage()));
                  });
                }
                else{
                  _showMessageInScaffold("Please enter the card issuer");
                }

                /*
                if(qrResult.indexOf('http://')!=-1 || qrResult.indexOf('https://')!=-1){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewPage(key:key,url: qrResult)));
                  setState(() {
                    qrCodeResult = qrResult;
                  });
                }else{
                  setState(() {
                    qrCodeResult = qrResult;
                  });
                }
                */

              },
              child: Text(
                'Scan to add',
                style: TextStyle(color: Colors.white),
              ),
            ),Container(
                child: Text(temp,textScaleFactor: 1)
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addcard()));
              },
              child: const Text('Manually enter card information',textAlign: TextAlign.center,style: TextStyle(
                color: Colors.pink,
                fontSize: 21.0, decoration: TextDecoration.underline)),
            ),
            // Button having rounded rectangle border
          ],
        ),
      ),
    );

  }
  // Insert method
  void _insert(name, datas) async {
    // row to insert
    Map<String, dynamic> row = {
      c_db.DatabaseHelper.columnName: name,
      c_db.DatabaseHelper.columnDatas: datas
    };

    CARD.Card card = CARD.Card.fromMap(row);
    final id = await card_db.insert(card);
    //_showMessageInScaffold("insert row id: $id");
    _showMessageInScaffold("Successfully added membership card: $name");
  }
}

class Addcard extends StatefulWidget {
  @override
  _Addcard createState() => _Addcard();
}

// 2. create _ScanQRState state widget
class _Addcard extends State<Addcard> {
  // 2.1 string not yet scanned
  final card_db = c_db.DatabaseHelper.instance;
  List<CARD.Card> cards = [];
  List<CARD.Card> cardsByName = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController datasController = TextEditingController();
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController datasUpdateController = TextEditingController();
  TextEditingController idDeleteController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  String qrCodeResult = 'Not Yet Scanned';

  var key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Member Card'),
      ),
      body: Container(
        color: Colors.white12,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please enter card information:',
              //'FOR TEST: QR Code Result:' + qrCodeResult,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
              width: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Membership card issuer',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: datasController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card number',
                ),
              ),
            ),
            // 2nd Text

            // Button to Scan QR code
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),

                ),

              ),
              // 1st option - get the free text in QR Code
              onPressed: () async {

                if(nameController.text.isNotEmpty&&nameController.text!=""&&nameController.text!=null
                    &&datasController.text.isNotEmpty&&datasController.text!=""&&datasController.text!=null){
                  //ScanResult codeScanner = await BarcodeScanner.scan();
                  String number =datasController.text;
                  String name=nameController.text;

                  setState(() {
                    _insert(name, number);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cardpage()));
                  });
                }
                else{
                  _showMessageInScaffold("Please enter the card issuer");
                }

                /*
                if(qrResult.indexOf('http://')!=-1 || qrResult.indexOf('https://')!=-1){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewPage(key:key,url: qrResult)));
                  setState(() {
                    qrCodeResult = qrResult;
                  });
                }else{
                  setState(() {
                    qrCodeResult = qrResult;
                  });
                }
                */

              },
              child: Text(
                'Add Card',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Button having rounded rectangle border
          ],
        ),
      ),
    );

  }
  // Insert method
  void _insert(name, datas) async {
    // row to insert
    Map<String, dynamic> row = {
      c_db.DatabaseHelper.columnName: name,
      c_db.DatabaseHelper.columnDatas: datas
    };

    CARD.Card card = CARD.Card.fromMap(row);
    final id = await card_db.insert(card);
    //_showMessageInScaffold("insert row id: $id");
    _showMessageInScaffold("Successfully added membership card: $name");
  }
}
.