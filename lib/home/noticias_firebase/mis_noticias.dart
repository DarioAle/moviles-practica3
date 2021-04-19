import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/item_noticia.dart';

import 'bloc/my_news_bloc.dart';

class MisNoticias extends StatefulWidget {
  MisNoticias({Key key}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  @override
  void initState() {
    BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyNewsBloc, MyNewsState>(
      listener: (context, state) {
        if (state is LoadingState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Cargando..."),
              ),
            );
        } else if (state is ErrorMessageState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("${state.errorMsg}"),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is LoadedNewsState) {
          state.noticiasList
              .sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
          // state.noticiasList.forEach((element) {
          //   print("-----" + element.publishedAt.toString());
          //   print("");
          //   });
          return RefreshIndicator(
            child: ListView.builder(
              itemCount: state.noticiasList.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemNoticia(noticia: state.noticiasList[index]);
              },
            ),
            onRefresh: () async {
              BlocProvider.of<MyNewsBloc>(context).add(RequestAllNewsEvent());
              return;
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
