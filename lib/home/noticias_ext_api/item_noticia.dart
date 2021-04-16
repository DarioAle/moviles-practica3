import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';
import 'package:share/share.dart';

class ItemNoticia extends StatelessWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ExtendedImage.network(
                  noticia.urlToImage,
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
                        "${noticia.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${noticia.publishedAt}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${noticia.description ?? "Descripcion no disponible"}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${noticia.author ?? "Autor no disponible"}",
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
                child: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    _onShare(context, noticia);
                  },
                ),
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
