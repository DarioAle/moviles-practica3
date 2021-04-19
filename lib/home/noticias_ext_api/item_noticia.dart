import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_login/home/nueva_noticia/bloc/crear_noticias_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:share/share.dart';

class ItemNoticia extends StatefulWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  _ItemNoticiaState createState() => _ItemNoticiaState();
}

class _ItemNoticiaState extends State<ItemNoticia> {
  CrearNoticiasBloc newsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        newsBloc = CrearNoticiasBloc();
        return newsBloc;
      },
      child: BlocConsumer<CrearNoticiasBloc, CrearNoticiasState>(
        listener: (context, state) {
          if (state is SavedNewState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Noticia guardada.."),
                ),
              );
          } else if (state is ErrorMessageState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Error al guardar noticia"),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _createItem();
        },
      ),
    );
  }

  Widget _createItem() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ExtendedImage.network(
                  widget.noticia.urlToImage,
                  cache: true,
                  height: 150,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${widget.noticia.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${widget.noticia.publishedAt}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${widget.noticia.description ?? "Descripcion no disponible"}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${widget.noticia.author ?? "Autor no disponible"}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(children: [
                  IconButton(
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () {
                      newsBloc.add(SaveNewElementEvent(
                          noticia: New(
                              isApi: true,
                              author: (widget.noticia.author ??
                                  "Autor no disponible"),
                              title: widget.noticia.title,
                              description: (widget.noticia.description ??
                                  "Descripcion no disponible"),
                              publishedAt: widget.noticia.publishedAt,
                              urlToImage: widget.noticia.urlToImage)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      _onShare(context, widget.noticia);
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onShare(BuildContext context, New noticia) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final itemToShare = "${noticia.title} ${noticia.url}";
    await Share.share(itemToShare,
        subject: noticia.description,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
