import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/responsive_helper.dart';

/// MODÜLER WIDGET: İlham Kartı
///
/// Ne İşe Yarar: Tek bir ilham alıntısını gösterir
/// Neden Modüler: Her ilham için aynı tasarım
/// Adaptive Özellikleri: 
///   - Responsive font size
///   - Responsive padding
///   - Responsive icon size
///   - Platform-specific colors
class InspirationQuoteCard extends StatelessWidget {
  final String text;
  final String author;
  final bool isUser; // Kullanıcının eklediği mi?
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;

  const InspirationQuoteCard({
    super.key,
    required this.text,
    required this.author,
    this.isUser = false,
    this.isLiked = false,
    this.onLike,
    this.onCopy,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Kart stilini kaldır, tam sayfa yap
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white, // ✅ Sade beyaz arka plan
      padding: ResponsiveHelper.responsive(
        context,
        mobile: const EdgeInsets.all(24),
        tablet: const EdgeInsets.all(32),
        desktop: const EdgeInsets.all(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Quote icon
          Container(
            padding: ResponsiveHelper.responsive(
              context,
              mobile: const EdgeInsets.all(12),
              tablet: const EdgeInsets.all(14),
              desktop: const EdgeInsets.all(16),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // ✅ Açık gri
              borderRadius: BorderRadius.zero,
            ),
            child: Icon(
              Icons.format_quote,
              color: Colors.black87, // ✅ Sade siyah
              size: ResponsiveHelper.responsive(
                context,
                mobile: 28.0,
                tablet: 32.0,
                desktop: 36.0,
              ),
            ),
          ),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 32.0,
              tablet: 40.0,
              desktop: 48.0,
            ),
          ),
          
          // Quote text - Responsive font size
          Text(
            '"$text"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Playpen Sans Thai',
              fontSize: ResponsiveHelper.responsiveFontSize(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 32.0,
              tablet: 40.0,
              desktop: 48.0,
            ),
          ),
          
          // Author badge
          Container(
            padding: ResponsiveHelper.responsive(
              context,
              mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // ✅ Açık gri
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Text(
              '— $author',
              style: TextStyle(
                fontFamily: 'Playpen Sans Thai',
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: FontWeight.w500,
                color: Colors.black87, // ✅ Sade siyah
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(
            height: ResponsiveHelper.responsive(
              context,
              mobile: 40.0,
              tablet: 48.0,
              desktop: 56.0,
            ),
          ),
          
          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Action buttons (like, copy, delete)
  Widget _buildActionButtons(BuildContext context) {
    final List<Widget> buttons = [];

    // Delete button (only for user inspirations)
    if (isUser && onDelete != null) {
      buttons.add(
        ModernIconButton(
          icon: Icons.delete_outline,
          onPressed: onDelete!,
          color: Colors.grey.shade600,
          backgroundColor: Colors.grey.shade100,
        ),
      );
      buttons.add(SizedBox(
        width: ResponsiveHelper.responsive(
          context,
          mobile: 24.0,
          tablet: 28.0,
          desktop: 32.0,
        ),
      ));
    }

    // Like button
    buttons.add(
      ModernIconButton(
        icon: isLiked ? Icons.favorite : Icons.favorite_border,
        onPressed: onLike ?? () {},
        color: isLiked ? Colors.black87 : Colors.grey.shade600,
        backgroundColor: isLiked
            ? Colors.grey.shade200
            : Colors.grey.shade100,
      ),
    );
    
    buttons.add(SizedBox(
      width: ResponsiveHelper.responsive(
        context,
        mobile: 24.0,
        tablet: 28.0,
        desktop: 32.0,
      ),
    ));

    // Copy button
    buttons.add(
      ModernIconButton(
        icon: Icons.copy,
        onPressed: onCopy ?? () {},
        color: const Color(0xFF6366F1),
        backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}

/// MODÜLER WIDGET: Modern İkon Butonu
///
/// Ne İşe Yarar: Animasyonlu, modern görünümlü ikon butonu
/// Neden Modüler: Her action için kullanılabilir
/// Adaptive Özellikleri: Responsive boyut ve padding
class ModernIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color backgroundColor;

  const ModernIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.backgroundColor,
  });

  @override
  State<ModernIconButton> createState() => _ModernIconButtonState();
}

class _ModernIconButtonState extends State<ModernIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              // Responsive padding
              padding: ResponsiveHelper.responsive(
                context,
                mobile: const EdgeInsets.all(12),
                tablet: const EdgeInsets.all(14),
                desktop: const EdgeInsets.all(16),
              ),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.zero,
                border: Border.all(
                  color: widget.color.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                // Responsive icon size
                size: ResponsiveHelper.responsive(
                  context,
                  mobile: 20.0,
                  tablet: 22.0,
                  desktop: 24.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// MODÜLER WIDGET: Scroll İndikatörü
///
/// Ne İşe Yarar: "Kaydır" mesajı ve ok ikonu gösterir
/// Neden Modüler: Farklı sayfalarda kullanılabilir
/// Adaptive Özellikleri: Responsive konum ve boyut
class ScrollIndicator extends StatelessWidget {
  final String message;
  final bool showArrow;

  const ScrollIndicator({
    super.key,
    this.message = 'Kaydır',
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ResponsiveHelper.responsive(
        context,
        mobile: 80.0,
        tablet: 100.0,
        desktop: 120.0,
      ),
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: ResponsiveHelper.responsive(
            context,
            mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                Icon(
                  Platform.isIOS
                      ? CupertinoIcons.arrow_down
                      : Icons.arrow_downward,
                  color: Colors.white,
                  size: ResponsiveHelper.responsive(
                    context,
                    mobile: 16.0,
                    tablet: 18.0,
                    desktop: 20.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

