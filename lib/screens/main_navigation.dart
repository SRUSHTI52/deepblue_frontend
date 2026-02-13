// lib/screens/main_navigation.dart
// ISL Connect – Main Navigation Shell
//
// Bottom navigation with 3 tabs:
//   1. Home (Sign Detection)
//   2. Educational Hub
//   3. Chatbot
//
// Uses an IndexedStack to preserve scroll position on tab switches.
// The active tab is indicated by a floating pill indicator for modern M3 feel.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
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
  // ── Currently selected tab index ──────────────────────────────────────────
  int _selectedIndex = 0;

  // ── Tab screens – IndexedStack keeps all pages alive ─────────────────────
  static const List<Widget> _screens = [
    HomeScreen(),
    EducationalHubScreen(),
    ChatbotScreen(),
  ];

  // ── Tab bar item configs ──────────────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      tooltip: 'Sign Detection Home',
    ),
    _NavItem(
      label: 'Learn',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      tooltip: 'Educational Hub - ISL Categories',
    ),
    _NavItem(
      label: 'Chat',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      tooltip: 'ISL Chatbot Assistant',
    ),
  ];

  void _onTabSelected(int index) {
    // Light haptic feedback on tab switch
    HapticFeedback.lightImpact();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens mounted and preserves state
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // ── Custom bottom navigation bar ─────────────────────────────────────
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ── Custom Material 3–style nav bar with pill indicator ───────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Icon with pill background when selected ──────
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 20 : 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 26,
                            ),
                          ),

                          const SizedBox(height: 2),

                          // ── Label ────────────────────────────────────────
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
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

// ── Nav item data class ───────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String tooltip;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.tooltip,
  });
}
