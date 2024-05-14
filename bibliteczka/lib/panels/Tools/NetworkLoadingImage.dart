import 'package:flutter/material.dart';

class NetworkLoadingImage extends StatelessWidget {
  const NetworkLoadingImage({
    super.key,
    required this.pathToImage,
  });

  final String pathToImage;

  @override
  Widget build(BuildContext context) {
    print(context.widget.key);
    return Image.network(
      pathToImage.trim(),
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
            'assets/images/brak_ksiazki.png',
            fit: BoxFit.fill);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}