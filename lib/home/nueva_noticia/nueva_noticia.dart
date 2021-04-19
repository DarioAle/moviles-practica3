import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/nueva_noticia/bloc/crear_noticias_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/home/noticias_firebase/bloc/my_news_bloc.dart' as newsBloc;

class NuevaNoticia extends StatefulWidget {
  NuevaNoticia({Key key}) : super(key: key);

  @override
  _NuevaNoticiaState createState() => _NuevaNoticiaState();
}

class _NuevaNoticiaState extends State<NuevaNoticia> {
  CrearNoticiasBloc _crearNoticiasBloc;
  File slectedImage;
  var autorTc = TextEditingController();
  var tituloTc = TextEditingController();
  var descrTc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _crearNoticiasBloc = CrearNoticiasBloc();
        return _crearNoticiasBloc;
      },
      child: BlocConsumer<CrearNoticiasBloc, CrearNoticiasState>(
        listener: (context, state) {
          if (state is PickedImageState) {
            slectedImage = state.image;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Imagen seleccionada"),
                ),
              );
          } else if (state is SavedNewState) {
            BlocProvider.of<newsBloc.MyNewsBloc>(context)
              .add(newsBloc.RequestAllNewsEvent());
            autorTc.clear();
            tituloTc.clear();
            descrTc.clear();
            slectedImage = null;
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
                  content: Text("${state.errorMsg}"),
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
          return _createForm();
        },
      ),
    );
  }

  Widget _createForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slectedImage != null
                ? Image.file(
                    slectedImage,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: autorTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Autor',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Titulo',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descrTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripcion',
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Imagen"),
              color: Colors.blueGrey,
              onPressed: () {
                _crearNoticiasBloc.add(PickImageEvent());
              },
            ),
            MaterialButton(
              child: Text("Guardar"),
              color: Colors.blueGrey,
              onPressed: () {
                _crearNoticiasBloc.add(
                  SaveNewElementEvent(
                    noticia: New(
                      isApi: false,
                      author: autorTc.text,
                      title: tituloTc.text,
                      description: descrTc.text,
                      publishedAt: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
