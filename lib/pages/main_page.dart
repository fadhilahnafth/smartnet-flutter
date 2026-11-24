import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/coba.dart';
import 'package:smart_agriculture_jadi/pages/home_page.dart';
import 'package:smart_agriculture_jadi/pages/message_page.dart';
import 'package:smart_agriculture_jadi/pages/ml_prediksi_panen.dart';
import 'package:smart_agriculture_jadi/pages/report_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ReportPage(),
    const MlPrediksiPanenPage(),
    MessagePage(),
    Coba(),
  ];

  static const _navItems = [
    _NavItem(Icons.home_rounded, 'Home'),
    _NavItem(Icons.paste_rounded, 'Report'),
    _NavItem(Icons.psychology_rounded, 'AI'),
    _NavItem(Icons.mail_rounded, 'Message'),
    _NavItem(Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isActive = i == _currentIndex;
              final isAI = i == 2;

              // AI item gets special treatment — center highlight
              if (isAI) {
                return _buildAINavItem(item, isActive);
              }
              return _buildNavItem(item, isActive, i);
            }),
          ),
        ),
      ),
    );
  }

  // --- Regular nav item ---
  Widget _buildNavItem(_NavItem item, bool isActive, int index) {
    const activeColor = Color(0xFF4CAF50);
    final inactiveColor = Colors.grey[500]!;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 22,
              color: isActive ? activeColor : inactiveColor,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  color: activeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- AI nav item (special) ---
  Widget _buildAINavItem(_NavItem item, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_rounded,
              size: 22,
              color: isActive ? Colors.white : Colors.deepPurple[400],
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              const Text(
                'AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
