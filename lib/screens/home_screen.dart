import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/file_provider.dart';
import '../widgets/file_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/storage_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FileProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
        centerTitle: false,
        elevation: 1,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          Consumer<FileProvider>(
            builder: (context, fileProvider, _) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: fileProvider.currentPath.isEmpty
                    ? null
                    : () => fileProvider.goBack(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const StorageInfo(),
          const SearchBar(),
          Expanded(
            child: Consumer<FileProvider>(
              builder: (context, fileProvider, _) {
                if (fileProvider.currentFiles.isEmpty) {
                  return const Center(
                    child: Text('No files found'),
                  );
                }
                return const FileList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
