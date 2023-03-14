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
    final refreshKey = GlobalKey<RefreshIndicatorState>();
  List<String> messages = [];
  List<String> username = [];
  List<String> emails = [];
  // int expandedIndex = -1;
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
        emails.add(itr.current.child("email").value.toString());
        // print(messages);
        // print(username);
      }
      setState(() {});
    } else {
      print('No data available.');
    }
  }

  void deleteMessage(String user,int index) async {
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Message'),
        content: Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('No'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    final ref = FirebaseDatabase.instance.ref('users/$user');
    await ref.remove();
    setState(() {
      messages.removeAt(index);
      username.removeAt(index);
      emails.removeAt(index);
    //  if (index == expandedIndex) {
    //     expandedIndex = -1;
    //   }
    });
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
          RefreshIndicator(
                      key: refreshKey,
            onRefresh: () async {
              // call getData() method again to refresh the data
              messages.clear();
              username.clear();
              emails.clear();
              setState(() {
              getData();
              });
              },
            child: ListView.builder(
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
                      
                      contentPadding: EdgeInsets.all(5),
                      // tileColor: Colors.grey,
                      leading: Icon(Icons.person),
                      title: Text(username[index]),
                      subtitle:Column(
          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            SizedBox(height: 5),
                            Text(emails[index]),
                            SizedBox(height: 5),
                            Text(messages[index]),
                          ],
                        ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                           deleteMessage(username[index],index);
                      },
                      
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


