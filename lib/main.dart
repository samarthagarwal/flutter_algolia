import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: 'APP_ID',
      apiKey: 'SEARCH_API_KEY',
    );

    AlgoliaQuery query = algolia.instance.index('Posts');
    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Algolia Search"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Search"),
            TextField(
              controller: _searchText,
              decoration: InputDecoration(hintText: "Search query here..."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _search,
                ),
              ],
            ),
            Expanded(
              child: _searching == true
                  ? Center(
                      child: Text("Searching, please wait..."),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text("No results found."),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (index + 1).toString(),
                                ),
                              ),
                              title: Text(snap.data["post_title"]),
                              subtitle: Text(snap.data["post_text"]),
                            );
                          },
                        ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
