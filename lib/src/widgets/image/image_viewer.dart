import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, this.imageProvider}) : super(key: key);

  final ImageProvider<Object>? imageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              imageProvider: imageProvider,
            ),
          ),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity as needed
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
