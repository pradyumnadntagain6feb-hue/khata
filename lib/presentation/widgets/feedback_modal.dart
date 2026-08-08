import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/register_provider.dart';

class FeedbackModal extends StatefulWidget {
  const FeedbackModal({super.key});

  @override
  State<FeedbackModal> createState() => _FeedbackModalState();
}

class _FeedbackModalState extends State<FeedbackModal> {
  String _selectedCategory = 'PDF Export';
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      final provider = RegisterProviderScope.of(context);
      provider.submitFeedback(_selectedCategory, message);

      final strings = provider.strings;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.thankYouFeedback),
          backgroundColor: AppColors.stampPBorder,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = RegisterProviderScope.of(context);
    final strings = provider.strings;

    final categories = [
      strings.topicPdf,
      strings.topicWhatsapp,
      strings.topicCloud,
      strings.topicOther,
    ];

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgParchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.appFeedback,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Text(
            strings.feedbackSub,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.selectTopic,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    color: isSel ? Colors.white : AppColors.textDark,
                  ),
                ),
                selected: isSel,
                selectedColor: AppColors.navyLedger,
                backgroundColor: AppColors.bgCard,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: strings.feedbackHint,
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.textLight),
              filled: true,
              fillColor: AppColors.bgCard,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderCard),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyLedger,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                strings.submitFeedback,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
