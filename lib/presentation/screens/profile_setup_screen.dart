import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../state/register_provider.dart';
import 'todays_register_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _businessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authService = AuthService();
    final googleName = authService.userName;
    if (googleName != null && googleName.isNotEmpty) {
      _nameController.text = googleName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final name = _nameController.text.trim();
    final business = _businessController.text.trim();

    if (name.isNotEmpty) {
      final provider = RegisterProviderScope.of(context);
      final finalBusiness = business.isEmpty ? 'Muster Khata' : business;

      provider.setOwnerProfile(
        name: name,
        businessName: finalBusiness,
      );

      final authService = AuthService();
      final user = authService.currentUser;
      if (user != null) {
        final firestoreService = FirestoreService();
        await firestoreService.saveOwnerProfile(
          userId: user.uid,
          ownerName: name,
          businessName: finalBusiness,
          email: user.email,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const TodaysRegisterScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;

    return Scaffold(
      backgroundColor: AppColors.bgParchment,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // App Logo
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.navyLedger,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'ख',
                    style: TextStyle(
                      fontFamily: 'serif',
                      color: AppColors.goldAccent,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Text(
                strings.isHindi ? 'अपनी प्रोफ़ाइल सेट करें' : 'Set Up Your Profile',
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.isHindi
                    ? 'अपना नाम और दुकान/साइट का नाम दर्ज करें ताकि रिपोर्ट पर आपका नाम दिखे'
                    : 'Enter your name and business/site name for your register headers',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Owner Name Field
              Text(
                strings.isHindi ? 'आपका नाम (ठेकेदार/मालिक का नाम)' : 'Your Name (Owner/Manager)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'जैसे: रमेश यादव',
                  prefixIcon: const Icon(Icons.person_outline,
                      size: 20, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Business / Site Name Field
              Text(
                strings.isHindi ? 'दुकान / साईट का नाम (ऑप्शनल)' : 'Shop / Site Name (Optional)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _businessController,
                decoration: InputDecoration(
                  hintText: 'जैसे: यादव कंस्ट्रक्शन / साईट 4',
                  prefixIcon: const Icon(Icons.storefront_outlined,
                      size: 20, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navyLedger,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    strings.isHindi ? 'रजिस्टर शुरू करें ➔' : 'Start Register ➔',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
