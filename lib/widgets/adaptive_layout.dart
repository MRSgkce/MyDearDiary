import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/responsive_helper.dart';

/// Adaptif layout wrapper
class AdaptiveLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool useSafeArea;
  final bool scrollable;

  const AdaptiveLayout({
    super.key,
    required this.child,
    this.padding,
    this.useSafeArea = true,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    Widget content = child;

    // Padding uygula
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    } else {
      // Responsive padding
      final responsivePadding = ResponsiveHelper.responsivePadding(context);
      content = Padding(padding: responsivePadding, child: content);
    }

    // Scrollable yap
    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    // Safe area uygula
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    // Landscape için özel layout
    if (isLandscape && deviceType == DeviceType.tablet) {
      content = _buildLandscapeLayout(context, content);
    }

    return content;
  }

  Widget _buildLandscapeLayout(BuildContext context, Widget content) {
    return Row(
      children: [
        Expanded(flex: 1, child: content),
        // Sidebar veya ek bilgi alanı eklenebilir
      ],
    );
  }
}

/// Adaptif grid layout
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final int? maxColumns;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.maxColumns,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    int columns = ResponsiveHelper.responsiveGridColumns(context);

    // Landscape mode için column sayısını artır
    if (isLandscape && deviceType == DeviceType.tablet) {
      columns = (columns * 1.5).round();
    }

    // Max column limiti
    if (maxColumns != null && columns > maxColumns!) {
      columns = maxColumns!;
    }

    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio ?? _getResponsiveAspectRatio(context),
      crossAxisSpacing: crossAxisSpacing ?? 16,
      mainAxisSpacing: mainAxisSpacing ?? 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  double _getResponsiveAspectRatio(BuildContext context) {
    return ResponsiveHelper.responsive(
      context,
      mobile: 1.2,
      tablet: 1.1,
      desktop: 1.0,
    );
  }
}

/// Adaptif card wrapper
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final deviceSize = ResponsiveHelper.getDeviceSize(context);

    return Container(
      margin: margin ?? _getResponsiveMargin(context),
      child: Card(
        elevation: elevation ?? _getResponsiveElevation(deviceType),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? _getResponsiveBorderRadius(deviceType),
        ),
        color: backgroundColor,
        child: Padding(
          padding: padding ?? _getResponsivePadding(context, deviceSize),
          child: child,
        ),
      ),
    );
  }

  EdgeInsets _getResponsiveMargin(BuildContext context) {
    return ResponsiveHelper.responsive(
      context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(12),
      desktop: const EdgeInsets.all(16),
    );
  }

  double _getResponsiveElevation(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 4;
      case DeviceType.desktop:
        return 6;
      case DeviceType.largeDesktop:
        return 8;
    }
  }

  BorderRadius _getResponsiveBorderRadius(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return BorderRadius.circular(12);
      case DeviceType.tablet:
        return BorderRadius.circular(16);
      case DeviceType.desktop:
        return BorderRadius.circular(20);
      case DeviceType.largeDesktop:
        return BorderRadius.circular(24);
    }
  }

  EdgeInsets _getResponsivePadding(
    BuildContext context,
    DeviceSize deviceSize,
  ) {
    final basePadding = ResponsiveHelper.responsive(
      context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    switch (deviceSize) {
      case DeviceSize.compact:
        return EdgeInsets.all(basePadding * 0.8);
      case DeviceSize.normal:
        return EdgeInsets.all(basePadding);
      case DeviceSize.large:
        return EdgeInsets.all(basePadding * 1.2);
    }
  }
}

/// Adaptif text widget
class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AdaptiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    return Text(
      text,
      style: _getResponsiveTextStyle(context, deviceType),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? _getResponsiveTextStyle(
    BuildContext context,
    DeviceType deviceType,
  ) {
    if (style == null) return null;

    double fontSizeMultiplier = 1.0;

    switch (deviceType) {
      case DeviceType.mobile:
        fontSizeMultiplier = 1.0;
        break;
      case DeviceType.tablet:
        fontSizeMultiplier = 1.1;
        break;
      case DeviceType.desktop:
        fontSizeMultiplier = 1.2;
        break;
      case DeviceType.largeDesktop:
        fontSizeMultiplier = 1.3;
        break;
    }

    return style!.copyWith(
      fontSize: (style!.fontSize ?? 14) * fontSizeMultiplier,
    );
  }
}

/// Adaptif button
class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final bool isFullWidth;

  const AdaptiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    Widget button;

    if (icon != null) {
      button = ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: AdaptiveText(text),
        style: style ?? _getResponsiveButtonStyle(context, deviceType),
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: style ?? _getResponsiveButtonStyle(context, deviceType),
        child: AdaptiveText(text),
      );
    }

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  ButtonStyle _getResponsiveButtonStyle(
    BuildContext context,
    DeviceType deviceType,
  ) {
    final basePadding = ResponsiveHelper.responsive(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );

    return ElevatedButton.styleFrom(
      padding: basePadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsive(
            context,
            mobile: 8,
            tablet: 12,
            desktop: 16,
          ),
        ),
      ),
    );
  }
}
