import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:developer';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = "a";
  String postsURL = "https://www.googleapis.com/books/v1/volumes?q=";
  final myController = TextEditingController();
  filtersearch(String text) {
    setState(() {
      if (text != "") {
        this.search = text;
      }
    });
  }

  Future<List<Book>> _getBook() async {
    var data = await http
        .get("https://www.googleapis.com/books/v1/volumes?q=" + this.search);

    var jsonData = json.decode(data.body);
    print(" " + this.search);
    List<Book> Books = [];
    print(jsonData["items"].length);
    for (var item in jsonData["items"]) {
      Book book = new Book(
          item["id"],
          item["selfLink"],
          item["volumeInfo"]["authors"][0],
          item["volumeInfo"]["imageLinks"]["thumbnail"],
          item["volumeInfo"]["imageLinks"]["smallThumbnail"],
          item["description"],
          item["volumeInfo"]["publishedDate"],
          item["volumeInfo"]["subtitle"],
          item["volumeInfo"]["title"]);

      Books.add(book);
      // print(book.id +
      //     "" +
      //     book.smallThumbnail +
      //     " " +
      //     book.authors +
      //     "" +
      //     book.title);
    }
    return Books;
  }

  test() async {}

  checkNull(img, message) {
    if (img != null) {
      return img;
    }

    return message;
  }

  listviewBody() => Container(
        constraints: BoxConstraints(
          minHeight: 50.0,
          maxHeight: 460.0,
        ),
        child: FutureBuilder(
            future: _getBook(),
            builder: (BuildContext context, AsyncSnapshot futureTrunks) {
              if (futureTrunks.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: futureTrunks.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomListItemTwo(
                      thumbnail:
                          Image.network(futureTrunks.data[index].thumbnail),
                      title: futureTrunks.data[index].title,
                      subtitle: checkNull(
                          futureTrunks.data[index].subtitle, "no subtitle"),
                      author: futureTrunks.data[index].authors,
                      publishDate: futureTrunks.data[index].publishedDate,
                    );
                  },
                );
              } else if (futureTrunks.data == null) {
                return Center(
                  child: Container(
                      width: 160,
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 80,
                            height: 80,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text('Fetching Book List...'),
                          )
                        ],
                      )),
                );
              }
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30))),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Find Your',
                      style: TextStyle(color: Colors.black87, fontSize: 25),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Dream Book',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 243, 243, 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black87,
                            ),
                            hintText: "Search you're looking for",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          onSubmitted: (String str) {
                            setState(() {
                              if (str != "") {
                                this.search = str;
                              } else {
                                this.search = "a";
                              }
                            });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              listviewBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class Book {
  final String id;
  final String selfLink;
  final String description;
  final String subtitle;
  final String smallThumbnail;
  final String thumbnail;
  final String authors;

  final String publishedDate;
  final String title;

  Book(
      this.id,
      this.selfLink,
      this.authors,
      this.thumbnail,
      this.smallThumbnail,
      this.description,
      this.publishedDate,
      this.subtitle,
      this.title);
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
