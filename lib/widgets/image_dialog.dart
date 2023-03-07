import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tangteevs/utils/color.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: SizedBox(
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 6,
                child: MaterialButton(
                  onPressed: () async {
                    String url = message;

                    final tempDir = await getTemporaryDirectory();
                    final path = '${tempDir.path}/TungTee.jpg';
                    try {
                      await Dio().download(url, path);
                      await GallerySaver.saveImage(path, albumName: 'TungTee')
                          .then((success) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      log('ErrorWhileSavingImg: $e');
                    }
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: green,
                    ),
                    child: const Icon(
                      Icons.download,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: redColor,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.07,
                left: MediaQuery.of(context).size.width * 0.001,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: PhotoView(
                    imageProvider: NetworkImage(message),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
