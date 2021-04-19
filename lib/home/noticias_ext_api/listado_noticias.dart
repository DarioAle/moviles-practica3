import 'package:flutter/material.dart';
import 'package:google_login/utils/news_repository.dart';

import 'item_noticia.dart';

class ListadoNoticias extends StatefulWidget {
  ListadoNoticias({Key key}) : super(key: key);

  @override
  _ListadoNoticiasState createState() => _ListadoNoticiasState();
}

class _ListadoNoticiasState extends State<ListadoNoticias> {
  String _keywords;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: NewsRepository().getAvailableNoticias(_keywords),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
            );
          }
          if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.only(top: 100),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ItemNoticia(
                        noticia: snapshot.data[index],
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Ingresa titulo",
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (content) {
                        setState(() {
                          _keywords = content;
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
