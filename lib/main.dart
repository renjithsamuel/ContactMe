import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Me',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Contact Me'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Message {
  final String username;
  final String email;
  final String message;

  Message({required this.username, required this.email, required this.message});
}

FirebaseDatabase database = FirebaseDatabase.instance;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> messages = [];
  List<String> username = [];
  List<String> emails = [];

  @override
  void initState() {
    // super.initState();
    print("*hello");
    getData();
  }

  void getData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/').get();
    if (snapshot.exists) {
      var itr = snapshot.children.iterator;
      var i = 0;
      while (itr.moveNext()) {
        messages.add(itr.current.child("message").value.toString());
        username.add(itr.current.child("username").value.toString());
        emails.add(itr.current.child("emails").value.toString());
        // print(messages);
        // print(username);
      }
      setState(() {});
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                  child: ListTile(
                    
                    contentPadding: EdgeInsets.all(3),
                    // tileColor: Colors.grey,
                    leading: Icon(Icons.person),
                    title: Text(username[index]),
                    subtitle: Text(emails[index]),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {

                    },

                    
                  ),
                ),
              );
            },
          ),
        ],
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


