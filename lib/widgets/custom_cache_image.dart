import 'package:ancientpeoplemobile/widgets/progress_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// author Liu Yin
/// date 2020/6/11
/// Description:自定义带有缓存的Image

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  CustomCachedImage({Key key, @required this.imageUrl, this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            fit: fit,
            imageUrl: imageUrl,
            placeholder: (context, url) => new ProgressView(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          )
        : Container();
  }
}
