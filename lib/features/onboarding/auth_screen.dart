import 'package:flutter/material.dart';
import '../../core/services/state_service.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthScreen({super.key, required this.onAuthenticated});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController(text: "Abdul");
  final TextEditingController _emailController = TextEditingController(text: "abdul@margin.app");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarginColors.cream,
      appBar: AppBar(
        title: Text("Create Your Space", style: MarginTypography.headingMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to MARGIN",
                style: MarginTypography.headingLarge,
              ),
              const SizedBox(height: 6),
              Text(
                "Your personal workspace is ready. No need to choose rigid roles — MARGIN organically adapts to your writing.",
                style: MarginTypography.bodyMedium,
              ),
              const SizedBox(height: 28),
              // Profile Avatar Preview
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: MarginColors.purple,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text.substring(0, 1).toUpperCase()
                            : "A",
                        style: MarginTypography.displayLarge.copyWith(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: MarginColors.butter,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF8A5A00)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text("Your Name", style: MarginTypography.headingSmall.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  prefixIcon: Icon(Icons.person_outline_rounded, color: MarginColors.purple),
                ),
                onChanged: (val) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 18),
              Text("Email Address", style: MarginTypography.headingSmall.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.mail_outline_rounded, color: MarginColors.purple),
                ),
              ),
              const SizedBox(height: 24),
              // Automatic workspace info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MarginColors.lavenderGhost,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MarginColors.lavender.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: MarginColors.purple, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Personal Workspace", style: MarginTypography.bodyMediumBold),
                          const SizedBox(height: 2),
                          Text(
                            "Created automatically with encrypted local backup.",
                            style: MarginTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    StateService.instance.userName = _nameController.text.trim();
                    StateService.instance.userEmail = _emailController.text.trim();
                    widget.onAuthenticated();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarginColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: MarginRadii.buttonRadius),
                  ),
                  child: const Text("Enter MARGIN"),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton.icon(
                  onPressed: widget.onAuthenticated,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 24, color: MarginColors.textSecondary),
                  label: Text("Continue with Google", style: MarginTypography.button.copyWith(color: MarginColors.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
