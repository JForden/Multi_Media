import 'package:flutter/material.dart';
import 'wp_api.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
  // _ArticlePageState2 createState2() => _ArticlePageState2();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var itemCount = snapshot.data.length;

              print(" This is the Item Count");
              print(itemCount);
              return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index]['title']['rendered']),
                      subtitle: Image.network(snapshot.data[index]['_embedded']
                          ['wp:featuredmedia'][0]['source_url']),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// class _ArticlePageState extends State<ArticlePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/bg.jpg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Image.network(
//                 'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg',
//                 width: 200.0,
//               ),
//             ),
//             Text('Example Article Link 1',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Image.network(
//                 'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
//             Text('Example Article Link 2',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Image.network(
//                 'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
//             Text('Example Article Link 3',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             Image.network(
//                 'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
//             Text('Example Article Link 4',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }
