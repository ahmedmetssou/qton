import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class MainNavigationScreen extends StatelessWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  static const _tabs = [
    _TabItem(path: '/home', icon: Icons.home_rounded, label: 'Home'),
    _TabItem(path: '/search', icon: Icons.search_rounded, label: 'Search'),
    _TabItem(path: '/favorites', icon: Icons.favorite_rounded, label: 'Saved'),
    _TabItem(path: '/history', icon: Icons.history_rounded, label: 'History'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIdx = _selectedIndex(context);
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          border: const Border(
            top: BorderSide(color: AppConstants.dividerColor, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSelected = i == selectedIdx;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.path),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppConstants.accentRed.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              tab.icon,
                              size: 22,
                              color: isSelected
                                  ? AppConstants.accentRed
                                  : AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppConstants.accentRed
                                  : AppConstants.textSecondary,
                            ),
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
      ),
    );
  }
}

class _TabItem {
  final String path;
  final IconData icon;
  final String label;

  const _TabItem({
    required this.path,
    required this.icon,
    required this.label,
  });
}
