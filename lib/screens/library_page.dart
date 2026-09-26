import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

import '../bookModels.dart';
import 'detail_book_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyLibrary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBookPage(bookIndex: index),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                title: Text(
                  bookList[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookList[index].author),
                    Text(bookList[index].year.toString()),
                  ],
                ),
                leading: BookLeadingImage(imageUrl: bookList[index].imageUrl),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookLeadingImage extends StatefulWidget {
  final String imageUrl;
  const BookLeadingImage({super.key, required this.imageUrl});

  @override
  State<BookLeadingImage> createState() => _BookLeadingImageState();
}

class _BookLeadingImageState extends State<BookLeadingImage> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasError) {
              setState(() => _hasError = true);
            }
          });

          return Container(
            width: 50,
            height: 50,
            color: AppTheme.grey,
            child: const Icon(
              Icons.image_not_supported,
              size: 30,
              color: Colors.white,
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            if (_hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _hasError = false);
              });
            }
          }
          return child;
        },
      ),
    );

    return _hasError
        ? Tooltip(message: 'Unable to load the image', child: imageWidget)
        : imageWidget;
  }
}
