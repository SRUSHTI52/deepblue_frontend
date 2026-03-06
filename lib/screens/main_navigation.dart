// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';
import 'home_screen.dart';
import 'educational_hub_screen.dart';
import 'chatbot_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    EducationalHubScreen(),
    ChatbotScreen(),
  ];

  void _onTabSelected(int index) {
    HapticFeedback.lightImpact();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navItems = [
      _NavItem(label: l10n.navHome,  icon: Icons.home_outlined,            activeIcon: Icons.home_rounded,            tooltip: l10n.navHomeTooltip),
      _NavItem(label: l10n.navLearn, icon: Icons.menu_book_outlined,        activeIcon: Icons.menu_book_rounded,        tooltip: l10n.navLearnTooltip),
      _NavItem(label: l10n.navChat,  icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded,    tooltip: l10n.navChatTooltip),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavBar(context, navItems),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, List<_NavItem> navItems) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: Semantics(
                  label: item.tooltip,
                  selected: isSelected,
                  button: true,
                  child: InkWell(
                    onTap: () => _onTabSelected(index),
                    splashColor: AppColors.primary.withOpacity(0.08),
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 26),
                        ),
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontFamily: 'Nunito', fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String tooltip;
  const _NavItem({required this.label, required this.icon, required this.activeIcon, required this.tooltip});
}