import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import 'file_item.dart';

class FileList extends StatelessWidget {
  const FileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        final files = fileProvider.currentFiles;
        
        if (files.isEmpty) {
          return const Center(
            child: Text('No files or folders'),
          );
        }

        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            return FileItem(file: files[index]);
          },
        );
      },
    );
  }
}
