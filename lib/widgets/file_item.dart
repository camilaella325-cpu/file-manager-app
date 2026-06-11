import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/file_model.dart';
import '../providers/file_provider.dart';

class FileItem extends StatelessWidget {
  final FileModel file;

  const FileItem({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildIcon(),
      title: Text(file.name),
      subtitle: Text('${file.formattedSize} • ${file.formattedDate}'),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            child: const Text('Copy'),
            onTap: () => _showCopyDialog(context),
          ),
          PopupMenuItem(
            child: const Text('Move'),
            onTap: () => _showMoveDialog(context),
          ),
          PopupMenuItem(
            child: const Text('Rename'),
            onTap: () => _showRenameDialog(context),
          ),
          PopupMenuItem(
            child: const Text('Delete'),
            onTap: () => _showDeleteDialog(context),
          ),
        ],
      ),
      onTap: () {
        if (file.isDirectory) {
          context.read<FileProvider>().loadDirectory(file.path);
        }
      },
    );
  }

  Widget _buildIcon() {
    if (file.isDirectory) {
      return const Icon(Icons.folder, color: Colors.green);
    }

    final ext = file.extension.toLowerCase();
    if (['jpg', 'png', 'gif', 'jpeg'].contains(ext)) {
      return const Icon(Icons.image, color: Colors.green);
    } else if (['pdf'].contains(ext)) {
      return const Icon(Icons.picture_as_pdf, color: Colors.green);
    } else if (['mp4', 'avi', 'mov'].contains(ext)) {
      return const Icon(Icons.video_file, color: Colors.green);
    } else if (['mp3', 'wav', 'flac'].contains(ext)) {
      return const Icon(Icons.audio_file, color: Colors.green);
    } else if (['txt', 'doc', 'docx'].contains(ext)) {
      return const Icon(Icons.description, color: Colors.green);
    }

    return const Icon(Icons.insert_drive_file, color: Colors.green);
  }

  void _showCopyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Copy'),
        content:
            const Text('File copied to clipboard path'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move'),
        content: const Text('Move functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: file.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (file.isDirectory) {
                context
                    .read<FileProvider>()
                    .renameDirectory(file.path, controller.text);
              } else {
                context
                    .read<FileProvider>()
                    .renameFile(file.path, controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Are you sure you want to delete ${file.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (file.isDirectory) {
                context.read<FileProvider>().deleteDirectory(file.path);
              } else {
                context.read<FileProvider>().deleteFile(file.path);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
