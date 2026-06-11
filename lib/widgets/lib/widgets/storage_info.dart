import 'package:flutter/material.dart';
import 'dart:io';

class StorageInfo extends StatefulWidget {
  const StorageInfo({Key? key}) : super(key: key);

  @override
  State<StorageInfo> createState() => _StorageInfoState();
}

class _StorageInfoState extends State<StorageInfo> {
  late Future<Map<String, dynamic>> _storageInfo;

  @override
  void initState() {
    super.initState();
    _storageInfo = _getStorageInfo();
  }

  Future<Map<String, dynamic>> _getStorageInfo() async {
    try {
      final result = await Process.run('df', []);
      return {
        'status': 'success',
        'data': result.stdout,
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Unable to fetch storage info',
      };
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Storage Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Storage',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _formatBytes(1099511627776), // 1TB example
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Space',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _formatBytes(549755813888), // 512GB example
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
