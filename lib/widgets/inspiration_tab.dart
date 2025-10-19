import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../services/inspiration_service.dart';
import '../providers/inspiration_provider.dart';
import 'inspiration_widgets.dart'; // ✅ Modüler widget'lar
import '../utils/responsive_helper.dart'; // ✅ Responsive helper

class InspirationTab extends ConsumerStatefulWidget {
  const InspirationTab({super.key, this.isCupertino = false});

  final bool isCupertino;

  @override
  ConsumerState<InspirationTab> createState() => _InspirationTabState();
}

class _InspirationTabState extends ConsumerState<InspirationTab> {

  static const List<_InspirationQuote> _quotes = [
    _InspirationQuote(
      text:
          'Başarı küçük çabaların toplamıdır; her gün düzenli olarak tekrar edilen.',
      author: 'Robert Collier',
    ),
    _InspirationQuote(
      text: 'Mutluluk bir varış noktası değil, bir yolculuk tarzıdır.',
      author: 'Jim Rohn',
    ),
    _InspirationQuote(
      text:
          'İyimserlik, başarıya giden yoldur. Umut ve güven olmadan hiçbir şey başarılmaz.',
      author: 'Helen Keller',
    ),
    _InspirationQuote(
      text: 'Düşlerinin peşinden git; çünkü hayaller, geleceğin tohumlarıdır.',
      author: 'Calvin Coolidge',
    ),
    _InspirationQuote(
      text:
          'Kendine inan, çünkü yapabileceğine inandığında yolun yarısı geride kalır.',
      author: 'Theodore Roosevelt',
    ),
  ];

  /// ✅ ÖĞRENİN: Adaptive InspirationTab
  ///
  /// ÖNCEKİ SORUNLAR:
  /// ❌ Sabit yükseklik (MediaQuery.of(context).size.height - 200)
  /// ❌ Responsive olmayan tasarım
  /// ❌ Modüler olmayan card yapısı
  ///
  /// YENİ ÖZELLİKLER:
  /// ✅ ResponsiveHelper ile dinamik boyutlar
  /// ✅ Modüler InspirationQuoteCard kullanımı
  /// ✅ Platform-specific scroll physics
  @override
  Widget build(BuildContext context) {
    final inspirations = ref.watch(inspirationsProvider);

    // Kullanıcının kaydettiği ilhamlar + varsayılan ilhamlar
    final allInspirations = <_InspirationItem>[];

    // Kullanıcının ilhamları
    for (final inspiration in inspirations.reversed) {
      allInspirations.add(_InspirationItem.user(inspiration));
    }

    // Varsayılan ilhamlar
    for (final quote in _quotes) {
      allInspirations.add(_InspirationItem.defaultQuote(quote));
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white, // ✅ Sade beyaz arka plan
      child: Stack(
        children: [
          // Ana içerik - Responsive height
          SizedBox(
            // ✅ Responsive height - cihaza göre otomatik ayarlanır
            height: ResponsiveHelper.responsive(
              context,
              mobile: MediaQuery.of(context).size.height - 180,
              tablet: MediaQuery.of(context).size.height - 160,
              desktop: MediaQuery.of(context).size.height - 140,
            ),
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              // ✅ Platform-specific scroll physics
              physics: widget.isCupertino
                  ? const BouncingScrollPhysics(parent: PageScrollPhysics())
                  : const PageScrollPhysics(),
              itemCount: allInspirations.length,
              itemBuilder: (context, index) {
                final item = allInspirations[index];
                // ✅ Modüler InspirationQuoteCard kullanımı
                return _buildInspirationCard(context, ref, item);
              },
            ),
          ),
          // ✅ Lottie arka plan animasyonu
          Positioned.fill(
            child: IgnorePointer(
              child: _buildLottieAnimation(context),
            ),
          ),
          // ✅ Modüler scroll indicator
          const ScrollIndicator(message: 'Kaydır'),
        ],
      ),
    );
  }

  /// ✅ Modüler inspirasyon kartı oluştur
  Widget _buildInspirationCard(
    BuildContext context,
    WidgetRef ref,
    _InspirationItem item,
  ) {
    return InspirationQuoteCard(
      text: item.text,
      author: item.author,
      isUser: item.isUser,
      isLiked: false, // TODO: Favori sistemi eklenebilir
      onLike: () {
        // TODO: Beğenme fonksiyonu
      },
      onCopy: () {
        // TODO: Kopyalama fonksiyonu
      },
      onDelete: item.isUser
          ? () => _deleteInspiration(ref, item.userInspiration!.id)
          : null,
    );
  }

  Future<void> _deleteInspiration(WidgetRef ref, String id) async {
    await ref.read(inspirationsProvider.notifier).deleteInspiration(id);
  }

  /// ✅ Lottie animasyon widget'ı
  Widget _buildLottieAnimation(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    
    // ✅ Daha belirgin opacity - cihaza göre
    final opacity = deviceType == DeviceType.mobile ? 0.35 : 
                   deviceType == DeviceType.tablet ? 0.30 : 0.25;
    
    return Opacity(
      opacity: opacity,
      child: Lottie.asset(
        'assets/animations/Autumn leaves.json',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        animate: true,
        repeat: true,
        frameRate: FrameRate(30),
      ),
    );
  }
}

/// ✅ İlham öğesi modeli
/// Kullanıcı ve varsayılan ilhamları temsil eder
class _InspirationItem {
  final _InspirationQuote? defaultQuote;
  final InspirationEntry? userInspiration;
  final bool isUser;

  _InspirationItem._({
    this.defaultQuote,
    this.userInspiration,
    required this.isUser,
  });

  factory _InspirationItem.defaultQuote(_InspirationQuote quote) {
    return _InspirationItem._(defaultQuote: quote, isUser: false);
  }

  factory _InspirationItem.user(InspirationEntry inspiration) {
    return _InspirationItem._(userInspiration: inspiration, isUser: true);
  }

  String get text => isUser ? userInspiration!.text : defaultQuote!.text;
  String get author =>
      isUser ? (userInspiration!.author ?? 'Sen') : defaultQuote!.author;
}

/// ✅ İlham alıntısı modeli
class _InspirationQuote {
  const _InspirationQuote({required this.text, required this.author});

  final String text;
  final String author;
}
