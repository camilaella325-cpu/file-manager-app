import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/file_model.dart';

class FileProvider extends ChangeNotifier {
  List<FileModel> _currentFiles = [];
  String _currentPath = '';
  List<String> _pathHistory = [];
  String _searchQuery = '';

  List<FileModel> get currentFiles {
    if (_searchQuery.isEmpty) {
      return _currentFiles;
    }
    return _currentFiles
        .where((file) =>
            file.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String get currentPath => _currentPath;
  String get searchQuery => _searchQuery;

  Future<void> initialize() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      await loadDirectory(appDir.path);
    } catch (e) {
      debugPrint('Error initializing: $e');
    }
  }

  Future<void> loadDirectory(String path) async {
    try {
      final directory = Directory(path);
      _currentPath = path;
      _pathHistory.add(path);
      _currentFiles = [];

      final entities = directory.listSync();
      for (var entity in entities) {
        if (entity is File) {
          _currentFiles.add(FileModel.fromFile(entity));
        } else if (entity is Directory) {
          _currentFiles.add(FileModel.fromDirectory(entity));
        }
      }

      _currentFiles.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.compareTo(b.name);
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading directory: $e');
    }
  }

  Future<void> goBack() async {
    if (_pathHistory.length > 1) {
      _pathHistory.removeLast();
      await loadDirectory(_pathHistory.last);
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();
      _currentFiles.removeWhere((f) => f.path == filePath);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  Future<void> deleteDirectory(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      await dir.delete(recursive: true);
      _currentFiles.removeWhere((f) => f.path == dirPath);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting directory: $e');
    }
  }

  Future<void> renameFile(String oldPath, String newName) async {
    try {
      final file = File(oldPath);
      final newPath =
          '${file.parent.path}/$newName';
      final renamedFile = await file.rename(newPath);

      final index = _currentFiles.indexWhere((f) => f.path == oldPath);
      if (index != -1) {
        _currentFiles[index] = FileModel.fromFile(renamedFile);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error renaming file: $e');
    }
  }

  Future<void> renameDirectory(String oldPath, String newName) async {
    try {
      final dir = Directory(oldPath);
      final newPath = '${dir.parent.path}/$newName';
      final renamedDir = await dir.rename(newPath);

      final index = _currentFiles.indexWhere((f) => f.path == oldPath);
      if (index != -1) {
        _currentFiles[index] = FileModel.fromDirectory(renamedDir);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error renaming directory: $e');
    }
  }

  Future<void> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final fileName = sourceFile.path.split('/').last;
      final destFile =
          File('$destinationPath/$fileName');
      await sourceFile.copy(destFile.path);
      notifyListeners();
    } catch (e) {
      debugPrint('Error copying file: $e');
    }
  }

  Future<void> moveFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final fileName = sourceFile.path.split('/').last;
      final destFile =
          File('$destinationPath/$fileName');
      await sourceFile.rename(destFile.path);
      _currentFiles.removeWhere((f) => f.path == sourcePath);
      notifyListeners();
    } catch (e) {
      debugPrint('Error moving file: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
