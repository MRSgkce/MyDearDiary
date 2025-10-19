import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../utils/responsive_helper.dart';

/// Adaptif navigation bar
class AdaptiveNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<AdaptiveNavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AdaptiveNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return Platform.isIOS
        ? _buildCupertinoNavigationBar(context, deviceType, isLandscape)
        : _buildMaterialNavigationBar(context, deviceType, isLandscape);
  }

  Widget _buildCupertinoNavigationBar(
    BuildContext context,
    DeviceType deviceType,
    bool isLandscape,
  ) {
    if (deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop) {
      return _buildDesktopSidebar(context);
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white, // ✅ Sade beyaz arka plan
        borderRadius: BorderRadius.zero, // Tamamen düz köşeler
        // ✅ Tam ekran için gölge efekti
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFFF5F5F5) // ✅ Açık gri seçili arka plan
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: isSelected ? 22 : 20,
                      color: isSelected 
                          ? Colors.black87 // ✅ Sade siyah
                          : Colors.grey, // ✅ Sade gri
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                            ? Colors.black87 // ✅ Sade siyah
                            : Colors.grey, // ✅ Sade gri
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMaterialNavigationBar(
    BuildContext context,
    DeviceType deviceType,
    bool isLandscape,
  ) {
    if (deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop) {
      return _buildDesktopSidebar(context);
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white, // ✅ Sade beyaz arka plan
        borderRadius: BorderRadius.zero, // Tamamen düz köşeler
        // ✅ Tam ekran için gölge efekti
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFFF5F5F5) // ✅ Açık gri seçili arka plan
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: isSelected ? 22 : 20,
                      color: isSelected 
                          ? Colors.black87 // ✅ Sade siyah
                          : Colors.grey, // ✅ Sade gri
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                            ? Colors.black87 // ✅ Sade siyah
                            : Colors.grey, // ✅ Sade gri
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context) {
    return Container(
      width: ResponsiveHelper.responsive(
        context,
        mobile: 200,
        tablet: 250,
        desktop: 280,
        largeDesktop: 320,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF2F2F2),
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo/Title
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'MyDearDiary',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
                fontWeight: FontWeight.bold,
                color: selectedItemColor ?? const Color(0xFF6B46C1),
              ),
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    selected: isSelected,
                    selectedTileColor:
                        (selectedItemColor ?? const Color(0xFF6B46C1))
                            .withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected
                          ? selectedItemColor ?? const Color(0xFF6B46C1)
                          : unselectedItemColor ?? Colors.grey,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? selectedItemColor ?? const Color(0xFF6B46C1)
                            : unselectedItemColor ?? Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () => onTap(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowLabels(DeviceType deviceType, bool isLandscape) {
    if (isLandscape && deviceType == DeviceType.mobile) {
      return false; // Landscape mobile'da label gösterme
    }

    switch (deviceType) {
      case DeviceType.mobile:
        return true;
      case DeviceType.tablet:
        return true;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return true;
    }
  }

}

/// Navigation item model
class AdaptiveNavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AdaptiveNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Adaptif scaffold
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? navigationBar;
  final Widget? floatingActionButton;
  final List<AdaptiveNavigationItem>? navigationItems;
  final int? selectedIndex;
  final ValueChanged<int>? onNavigationTap;
  final bool showNavigationBar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.navigationBar,
    this.floatingActionButton,
    this.navigationItems,
    this.selectedIndex,
    this.onNavigationTap,
    this.showNavigationBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    if (deviceType == DeviceType.desktop ||
        deviceType == DeviceType.largeDesktop) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Sidebar navigation
        if (showNavigationBar &&
            navigationItems != null &&
            onNavigationTap != null)
          AdaptiveNavigationBar(
            selectedIndex: selectedIndex ?? 0,
            onTap: onNavigationTap!,
            items: navigationItems!,
          ),

        // Main content
        Expanded(
          child: Column(
            children: [
              // App bar
              if (appBar != null) appBar!,

              // Body
              Expanded(child: body),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (Platform.isIOS) {
      // iOS için appBar'ı ObstructingPreferredSizeWidget olarak kullan
      ObstructingPreferredSizeWidget? cupertinoAppBar;
      if (appBar != null && appBar is ObstructingPreferredSizeWidget) {
        cupertinoAppBar = appBar as ObstructingPreferredSizeWidget;
      }

      return CupertinoPageScaffold(
        navigationBar: cupertinoAppBar,
        child: SafeArea(
          bottom: false, // Bottom safe area'yı devre dışı bırak
          child: Column(
            children: [
              Expanded(child: body),
              if (showNavigationBar && navigationBar != null) navigationBar!,
            ],
          ),
        ),
      );
    } else {
      // Android için appBar'ı PreferredSizeWidget olarak kullan
      PreferredSizeWidget? materialAppBar;
      if (appBar != null && appBar is PreferredSizeWidget) {
        materialAppBar = appBar as PreferredSizeWidget;
      }

      return Scaffold(
        appBar: materialAppBar,
        body: body,
        bottomNavigationBar: showNavigationBar ? navigationBar : null,
        floatingActionButton: floatingActionButton,
      );
    }
  }
}
