// lib/widgets/language_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class AppLanguage {
  final String locale;
  final String nativeName;
  final String englishName;
  final String flag;
  const AppLanguage({
    required this.locale,
    required this.nativeName,
    required this.englishName,
    required this.flag,
  });
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(locale: 'en', nativeName: 'English',  englishName: 'English', flag: '🇬🇧'),
  AppLanguage(locale: 'hi', nativeName: 'हिन्दी',    englishName: 'Hindi',   flag: '🇮🇳'),
  AppLanguage(locale: 'mr', nativeName: 'मराठी',     englishName: 'Marathi', flag: '🇮🇳'),
  AppLanguage(locale: 'bn', nativeName: 'বাংলা',     englishName: 'Bengali', flag: '🇮🇳'),
];

class LanguageSwitcher {
  static void show(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageSheet(currentContext: context),
    );
  }
}

class _LanguageSheet extends StatefulWidget {
  final BuildContext currentContext;
  const _LanguageSheet({required this.currentContext});

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _selectedLocale;

  @override
  void initState() {
    super.initState();
    final code = Localizations.localeOf(widget.currentContext).languageCode;
    _selectedLocale = kSupportedLanguages.any((l) => l.locale == code) ? code : 'en';
  }

  void _apply(String locale) {
    HapticFeedback.selectionClick();
    setState(() => _selectedLocale = locale);
    Future.delayed(const Duration(milliseconds: 180), () {
      ISLConnectApp.setLocale(widget.currentContext, Locale(locale));
      Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.language_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Language / भाषा / भाषा / ভাষা',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    Text('Choose your preferred language',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.textSecondary.withOpacity(0.1), height: 1),
          const SizedBox(height: 8),
          ...kSupportedLanguages.map((lang) => _LanguageTile(
            language: lang,
            isSelected: _selectedLocale == lang.locale,
            onTap: () => _apply(lang.locale),
          )),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;
  const _LanguageTile({required this.language, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.nativeName,
                          style: TextStyle(
                            fontFamily: 'Nunito', fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          )),
                      Text(language.englishName,
                          style: const TextStyle(
                            fontFamily: 'Nunito', fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Container(
                    key: const ValueKey('check'),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                  )
                      : Container(
                    key: const ValueKey('circle'),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textSecondary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}