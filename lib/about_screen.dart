import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/animation_utils.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // Social Media URLs - Update these with your actual profiles
  static const String githubURL = 'https://github.com/camilaella325-cpu';
  static const String twitterURL = 'https://twitter.com';
  static const String linkedinURL = 'https://linkedin.com';

  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Opening link...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
        return;
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
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
                // App Icon with animation
                AnimatedListItem(
                  delay: 0,
                  child: const Icon(Icons.folder, size: 80, color: Colors.green),
                ),
                const SizedBox(height: 20),
                
                // App Name
                AnimatedListItem(
                  delay: 1,
                  child: const Text(
                    'File Manager App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Version
                AnimatedListItem(
                  delay: 2,
                  child: const Text('Version 1.0.0'),
                ),
                const SizedBox(height: 30),
                
                // App Description
                AnimatedListItem(
                  delay: 3,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'A powerful and intuitive file manager app for managing your files and folders. Organize, browse, and manage your device storage with ease.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Developer Section
                AnimatedListItem(
                  delay: 4,
                  child: const Text(
                    'Developer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedListItem(
                  delay: 5,
                  child: const Text(
                    'Abraham Matthew',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Social Media Links
                AnimatedListItem(
                  delay: 6,
                  child: const Text(
                    'Follow Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                
                AnimatedListItem(
                  delay: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // GitHub
                      SocialMediaButton(
                        icon: Icons.code,
                        label: 'GitHub',
                        onPressed: () => _launchURL(context, githubURL),
                      ),
                      const SizedBox(width: 15),
                      
                      // Twitter
                      SocialMediaButton(
                        icon: Icons.public,
                        label: 'Twitter',
                        onPressed: () => _launchURL(context, twitterURL),
                      ),
                      const SizedBox(width: 15),
                      
                      // LinkedIn
                      SocialMediaButton(
                        icon: Icons.work,
                        label: 'LinkedIn',
                        onPressed: () => _launchURL(context, linkedinURL),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Go Back Button
                AnimatedListItem(
                  delay: 8,
                  child: AnimatedElevatedButton(
                    label: 'Go Back',
                    onPressed: () => Navigator.pop(context),
                  ),
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
class SocialMediaButton extends StatefulWidget {
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
  State<SocialMediaButton> createState() => _SocialMediaButtonState();
}

class _SocialMediaButtonState extends State<SocialMediaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.85).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green.shade300,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onTap,
                borderRadius: BorderRadius.circular(30),
                child: Icon(widget.icon, size: 24, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
