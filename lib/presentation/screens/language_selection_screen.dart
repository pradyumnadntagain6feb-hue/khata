import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../state/register_provider.dart';
import 'todays_register_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  AppLanguage _selectedLanguage = AppLanguage.hindi;

  void _proceed() {
    final provider = RegisterProviderScope.of(context);
    provider.completeOnboarding(_selectedLanguage);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const TodaysRegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = _selectedLanguage == AppLanguage.hindi;

    return Scaffold(
      backgroundColor: AppColors.bgParchment,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // App Branding / Khata Logo Badge
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.navyLedger,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x331A2634),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'ख',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title & Subtitle
              Center(
                child: Text(
                  isHindi ? 'अपनी भाषा चुनें' : 'Choose Your Language',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  isHindi
                      ? 'मस्टर रजिस्टर ऐप का उपयोग किस भाषा में करना चाहते हैं?'
                      : 'Select your preferred language for the muster book',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Language Cards
              _LanguageCard(
                title: 'हिन्दी (Hindi)',
                subtitle: 'मस्टर, हाजिरी, दिहाड़ी, बाकी राशि',
                symbol: 'अ',
                isSelected: _selectedLanguage == AppLanguage.hindi,
                onTap: () {
                  setState(() {
                    _selectedLanguage = AppLanguage.hindi;
                  });
                },
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                title: 'English',
                subtitle: 'Muster, Attendance, Earnings, Ledger',
                symbol: 'A',
                isSelected: _selectedLanguage == AppLanguage.english,
                onTap: () {
                  setState(() {
                    _selectedLanguage = AppLanguage.english;
                  });
                },
              ),

              const Spacer(),

              // Subtext note
              Center(
                child: Text(
                  isHindi
                      ? 'आप इसे बाद में भी कभी भी बदल सकते हैं'
                      : 'You can change this anytime from app header',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Big Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navyLedger,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isHindi ? 'आगे बढ़ें' : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String symbol;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bgCard : const Color(0x88FFFDF7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.navyLedger : AppColors.borderCard,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x1A1A2634),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.navyLedger : AppColors.bgParchment,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.navyLedger : AppColors.borderCard,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                symbol,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.goldAccent : AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.textDark
                          : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.navyLedger,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
