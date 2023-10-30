import 'package:flutter/material.dart';
import 'package:sample_project/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'DO DIRAC',
      theme: ThemeData(),
      home: const SplashScreenPage(),
    );
  }
}




































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// void main() {
//   runApp(MaterialApp(
//     title: 'Flutter Navigation',
//     theme: ThemeData(
//       // This is the theme of your application.
//       primarySwatch: Colors.green,
//     ),
//     home: MyApp(),
//   ));
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a blue toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'GET API'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // String dataToJson(Data data) => json.encode(data.toJson());
// // Map<String, dynamic> dataMap = jsonDecode();
// // var user = Data.fromJson(dataMap);

// class ApiData {
//   // final int id;
//   // final String email;
//   // final String first_name;
//   // final String last_name;
//   // final String avatar;
//   
//    ApiData({
//     this.page,
//     this.per_page,
//     this.total,
//     this.total_page,
//     this.data,
//   });

//   // Data(
//   //   {required this id;
//   //   required this email;
//   //   required this first_name;
//   //   required this last_name;
//   //   required this avatar;
//   //   }
//   // );

//   int? page;
//   int? per_page;
//   int? total;
//   int? total_page;
//   // String? avatar;
//   List<Items>? data;

//   factory ApiData.fromJson(Map<String, dynamic> json) => ApiData(
//         page: json["page"],
//         per_page: json["per_page"],
//         total: json["total"],
//         total_page: json["total_page"],
//         data: List<Items>.from(json["data"].map((x) => Items.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "page": page,
//         "per_page": per_page,
//         "total": total,
//         "total_page": total_page,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class Items {
//   Items({
//     this.id,
//     this.email,
//     this.first_name,
//     this.last_name,
//     this.avatar,
//   });

//   int? id;
//   String? email;
//   String? first_name;
//   String? last_name;
//   String? avatar;

//   factory Items.fromJson(Map<String, dynamic> json) => Items(
//         id: json["id"],
//         email: json["email"],
//         first_name: json["first_name"],
//         last_name: json["last_name"],
//         avatar: json["avatar"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "email": email,
//         "first_name": first_name,
//         "last_name": last_name,
//         "avatar": avatar,
//       };
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   ApiData? apiData;

//   // getUser(context);

//   void fetchUser() async {
//     const url = "https://reqres.in/api/users?page=2";
//     final uri = Uri.parse(url);
//     final response = await http.get(uri);
//     final body = response.body;
//     final responseData = jsonDecode(body);
//     apiData = ApiData.fromJson(responseData);
//     print(apiData);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SecondPage(
//           apidata: apiData!,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//         ),
//         // body: ListView.builder(
//         //     itemCount: users.length,
//         //     itemBuilder: (context, index) {
//         //       final user = users[index];
//         //       final firstName = user['first_name'];
//         //       final lastName = user['last_name'];
//         //       final email = user['email'];
//         //       final image = user['avatar'];
//         //       return ListTile(
//         //         leading: ClipRRect(
//         //           child: Image.network(image),
//         //         ),
//         //         title: Text('$firstName $lastName'),
//         //         subtitle: Text(email),
//         //       );
//         //     }),
//         body: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   child: ElevatedButton(
//                     child: Text('API'),
//                     onPressed: fetchUser,
//                   ),
//                 ),
//               ]),
//         )

//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: fetchUser,
//         //   tooltip: 'Get API',
//         // ));
//         );
//   }

//   // return Scaffold(
//   // appBar: AppBar(
//   //   // TRY THIS: Try changing the color here to a specific color (to
//   //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//   //   // change color while the other colors stay the same.
//   //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//   //   // Here we take the value from the MyHomePage object that was created by
//   //   // the App.build method, and use it to set our appbar title.
//   //   title: Text(widget.title),
//   // ),
//   // body: Center(
//   // Center is a layout widget. It takes a single child and positions it
//   // in the middle of the parent.

//   // child: Column(
//   // Column is also a layout widget. It takes a list of children and
//   // arranges them vertically. By default, it sizes itself to fit its
//   // children horizontally, and tries to be as tall as its parent.
//   //
//   // Column has various properties to control how it sizes itself and
//   // how it positions its children. Here we use mainAxisAlignment to
//   // center the children vertically; the main axis here is the vertical
//   // axis because Columns are vertical (the cross axis would be
//   // horizontal).
//   //
//   // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//   // action in the IDE, or press "p" in the console), to see the
//   // wireframe for each widget.
//   // mainAxisAlignment: MainAxisAlignment.center,
//   // children: <Widget>[
//   // TextField(
//   //   onChanged: (text) => { setState(() =>value = text) },
//   //   decoration: InputDecoration(
//   //   border: OutlineInputBorder(),
//   // ),
//   // ),
//   //  _quetesIndex = Random().nextInt(value.length);
//   // for (int i; i<=value.length; i++)
//   // Text("Get API"),
//   // FloatingActionButton(
//   //     onPressed: fetchUser,
//   //     tooltip: 'API Button',
//   //     child: const Icon(Icons.add),
//   //   )

//   // Text(
//   //   '$_counter',
//   //   style: Theme.of(context).textTheme.headlineMedium,
//   // ),
//   // if(_show==1)
//   //     FloatingActionButton(
//   //       onPressed: _shoBtnA,
//   //       tooltip: 'ButtonA',
//   //       child: const Icon(Icons.add),
//   //     )
//   // else
//   //     FloatingActionButton(
//   //       onPressed: _shoBtnB,

//   //       tooltip: 'ButtonB',
//   //       child: const Icon(Icons.remove),
//   //     ),

//   // ],
//   // ),

//   // ),
//   // floatingActionButton: FloatingActionButton(
//   // onPressed: fetchUser,
//   // tooltip: 'Get API',
//   // child: const Icon(Icons.add),
//   // ), // This trailing comma makes auto-formatting nicer for build methods.
//   // );
// }

// class SecondPage extends StatefulWidget {
//   const SecondPage({
//     Key? key,
//     required this.apidata,
//   }) : super(key: key);

//   // This widget is the root of your application.
//   // @override
//   // Widget build(BuildContext context) => Scaffold(
//   //       appBar: AppBar(
//   //         title: Text('Second Page'),
//   //         centerTitle: true,
//   //       ),
//   //       body: ListView.builder(
//   //           itemCount: apidata.length,
//   //           itemBuilder: (context, index) {
//   //             final user = apidata[index];
//   //             final firstName = user['first_name'];
//   //             final lastName = user['last_name'];
//   //             final email = user['email'];
//   //             final image = user['avatar'];

//   // return ListTile(
//   //   leading: ClipRRect(
//   //     child: Image.network(image),
//   //   ),
//   //   title: Text('$firstName $lastName'),
//   //   subtitle: Text(email),
//   // );

//   // return GestureDetector(
//   //   onLongPress: () => print(firstName),
//   //   child: Card(
//   //     //I am the clickable child
//   //     child: Column(
//   //       children: <Widget>[
//   //         ListTile(
//   //           leading: ClipRRect(
//   //             child: Image.network(image),
//   //           ),
//   //           title: Text('$firstName $lastName'),
//   //           subtitle: Text(email),
//   //         ),
//   //       ],
//   //     ),
//   //   ),
//   // );
//   //       }),
//   // );
//   final ApiData apidata;

//   @override
//   State<SecondPage> createState() => _SecondPageSatate();
// }

// class _SecondPageSatate extends State<SecondPage> {
//   List<Items>? listOfItem = [];

//   bool valuefirst = false;
//   bool valuesecond = false;

//   @override
//   void initState() {
//     super.initState();
//     listOfItem = widget.apidata.data;
//   }

//   bool isSelected = true;
//   var color = Colors.white;
//   var itemId = [];

//   void multiSelection(int id) {
//     if (itemId.contains(id)) {
//       itemId.remove(id);
//       setState(() => isSelected = false);
//     } else {
//       itemId.add(id);
//       setState(() => isSelected = true);
//     }
//     print(itemId);
//     // setState(() {
//     //   if (isSelected) {
//     //     color = Colors.white;
//     //     isSelected = false;
//     //   } else {
//     //     color = Colors.lightBlue;
//     //     isSelected = true;
//     //   }
//     // });
//   }

//   // var copyList = listOfItem;
//   void onDelete() {
//     for (var i = 0; i < itemId.length; i++) {
//       print("internal $itemId");
//       for (var j = 0; j < listOfItem!.length; j++) {
//         if (listOfItem![j].id == (itemId[i])) {
//           listOfItem!.remove(listOfItem![j]);
//           print("external $itemId");
//           break;
//         }
//       }
//     }
//     // for (var x in itemId) {
//     //   for (int y in listOfItem) {
//     //     if (x["id"]) {
//     //       listOfItem.remove(x);
//     //       break;
//     //     }
//     //   }
//     // }

//     // print("y");
//     // print(listOfItem[i]["id"]);
//     // print("5");
//     // listOfItem.where((item) => {print("${item}")});
//     // dynamic x=listOfItem[i];
//     // for (x["id"] in itemId){
//     //     personData.add(listOfItem[i]);
//     // }
//     itemId.clear();
//     // print(personData);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         colorSchemeSeed: Colors.cyan.shade900,
//         useMaterial3: true,
//       ),
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Second Page'),
//             centerTitle: true,
//           ),
//           body: ListView.builder(
//               itemCount: listOfItem!.length,
//               itemBuilder: (context, index) {
//                 //   leading: ClipRRect(
//                 //     child: Image.network(image),
//                 //   ),
//                 //   title: Text('$firstName $lastName'),
//                 //   subtitle: Text(email),
//                 // );
//                 return ListTile(
//                     // child:(),
//                     leading: GestureDetector(
//                         child: ClipRRect(
//                       child: Image.network(listOfItem![index].avatar!),
//                     )),
//                     title: Text(
//                         '${listOfItem![index].first_name!} ${listOfItem![index].last_name!}'),
//                     subtitle: Text(listOfItem![index].email!),
//                     trailing: GestureDetector(
//                       onTap: () {
//                         multiSelection(listOfItem![index].id!);
//                       },
//                       child: Icon(
//                         Icons.add,
//                         color: Colors.white,
//                       ),
//                     ));
//               }

//               //   Container(
//               //   // margin: EdgeInsets.all(25),
//               //   child: FlatButton(
//               //     child: Text('Add', style: TextStyle(fontSize: 20.0),),
//               //     color: Colors.blueAccent,
//               //     textColor: Colors.white,
//               //     // onPressed: () {},
//               //   ),
//               // ),

//               ),
//           floatingActionButton: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               (isSelected
//                   ? FloatingActionButton(
//                       heroTag: "btn1",
//                       onPressed: () {},
//                       tooltip: 'Add Item',
//                       child: const Icon(Icons.add),
//                     )
//                   : FloatingActionButton(
//                       heroTag: "btn2",
//                       onPressed: () {},
//                       tooltip: 'Add Item',
//                       // child: const Icon(Icons.add),
//                     )),
//               (isSelected
//                   ? FloatingActionButton(
//                       heroTag: "btn3",
//                       onPressed: onDelete,
//                       tooltip: 'Delete Item',
//                       child: const Icon(Icons.delete),
//                     )
//                   : FloatingActionButton(
//                       heroTag: "btn4",
//                       onPressed: onDelete,
//                       tooltip: 'Delete Item',
//                       // child: const Icon(Icons.delete),
//                     )),
//             ],
//           )),
//     );
//   }
// }
