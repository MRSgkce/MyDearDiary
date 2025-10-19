import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ✨ TAM EKRAN WRAPPER
///
/// Ne İşe Yarar: Herhangi bir widget'ı tam ekran yapar
/// Kullanım: FullScreenWrapper(child: YourWidget())
/// Özellikler:
///   - Status bar gizleme
///   - Navigation bar gizleme
///   - Safe area yönetimi
///   - Gesture handling
///   - Responsive padding

class FullScreenWrapper extends StatefulWidget {
  final Widget child;
  final bool hideStatusBar;
  final bool hideNavigationBar;
  final Color? statusBarColor;
  final Color? navigationBarColor;
  final bool extendBodyBehindAppBar;
  final EdgeInsets? safeAreaPadding;

  const FullScreenWrapper({
    super.key,
    required this.child,
    this.hideStatusBar = true,
    this.hideNavigationBar = true,
    this.statusBarColor,
    this.navigationBarColor,
    this.extendBodyBehindAppBar = true,
    this.safeAreaPadding,
  });

  @override
  State<FullScreenWrapper> createState() => _FullScreenWrapperState();
}

class _FullScreenWrapperState extends State<FullScreenWrapper>
    with WidgetsBindingObserver {
  bool _isFullScreen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setFullScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _setFullScreen();
    }
  }

  void _setFullScreen() {
    if (!mounted) return;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: widget.hideStatusBar && widget.hideNavigationBar
          ? []
          : widget.hideStatusBar
              ? [SystemUiOverlay.bottom]
              : widget.hideNavigationBar
                  ? [SystemUiOverlay.top]
                  : [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: widget.statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor:
            widget.navigationBarColor ?? Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Ekrana dokunulduğunda sistem UI'ları gizle/göster
      onTap: _toggleSystemUI,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          // ✅ Safe area yönetimi
          top: !widget.hideStatusBar,
          bottom: !widget.hideNavigationBar,
          left: true,
          right: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: widget.safeAreaPadding,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _toggleSystemUI() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
    }
  }
}

/// ✅ TAM EKRAN SCAFFOLD
///
/// Ne İşe Yarar: Tam ekran scaffold wrapper
/// Kullanım: FullScreenScaffold(body: YourContent())
class FullScreenScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;

  const FullScreenScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FullScreenWrapper(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

/// ✅ TAM EKRAN CONTAINER
///
/// Ne İşe Yarar: Tam ekran container wrapper
/// Kullanım: FullScreenContainer(child: YourContent())
class FullScreenContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;

  const FullScreenContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return FullScreenWrapper(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

/// ✅ TAM EKRAN HELPER
///
/// Ne İşe Yarar: Tam ekran yardımcı fonksiyonlar
class FullScreenHelper {
  /// Status bar'ı gizle
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  /// Navigation bar'ı gizle
  static void hideNavigationBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top],
    );
  }

  /// Her iki bar'ı da gizle (tam ekran)
  static void hideAllBars() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  /// Tüm bar'ları göster
  static void showAllBars() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  /// Landscape modda tam ekran
  static void setLandscapeFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    hideAllBars();
  }

  /// Portrait modda tam ekran
  static void setPortraitFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    hideAllBars();
  }

  /// Tüm yönlere izin ver
  static void setAllOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
