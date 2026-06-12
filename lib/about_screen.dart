import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // Social Media URLs - Update these with your actual profiles
  static const String githubURL = 'https://github.com/camilaella325-cpu';
  static const String twitterURL = 'https://twitter.com';
  static const String linkedinURL = 'https://linkedin.com';

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback if URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // App Icon
                const Icon(Icons.folder, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                
                // App Name
                const Text(
                  'File Manager App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Version
                const Text('Version 1.0.0'),
                const SizedBox(height: 30),
                
                // App Description
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'A powerful and intuitive file manager app for managing your files and folders. Organize, browse, and manage your device storage with ease.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Developer Section
                const Text(
                  'Developer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Abraham Matthew',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                
                // Social Media Links
                const Text(
                  'Follow Me',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GitHub
                    SocialMediaButton(
                      icon: Icons.code,
                      label: 'GitHub',
                      onPressed: () => _launchURL(githubURL),
                    ),
                    const SizedBox(width: 15),
                    
                    // Twitter
                    SocialMediaButton(
                      icon: Icons.public,
                      label: 'Twitter',
                      onPressed: () => _launchURL(twitterURL),
                    ),
                    const SizedBox(width: 15),
                    
                    // LinkedIn
                    SocialMediaButton(
                      icon: Icons.work,
                      label: 'LinkedIn',
                      onPressed: () => _launchURL(linkedinURL),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Go Back Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Social Media Button Widget
class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SocialMediaButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green.shade300,
          child: IconButton(
            icon: Icon(icon, size: 24, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
