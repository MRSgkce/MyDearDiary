import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../services/inspiration_service.dart';
import '../providers/inspiration_provider.dart';

class InspirationTab extends ConsumerWidget {
  const InspirationTab({super.key, this.isCupertino = false});

  final bool isCupertino;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Stack(
      children: [
        // Ana içerik
        SizedBox(
          height:
              MediaQuery.of(context).size.height -
              200, // AppBar ve Navigation için alan bırak
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            physics: isCupertino
                ? const BouncingScrollPhysics(parent: PageScrollPhysics())
                : const PageScrollPhysics(),
            itemCount: allInspirations.length,
            itemBuilder: (context, index) {
              final item = allInspirations[index];
              return _InspirationCard(
                item: item,
                isCupertino: isCupertino,
                onDelete: item.isUser
                    ? (id) => _deleteInspiration(ref, id)
                    : null,
              );
            },
          ),
        ),
        // Lottie animasyonu - düşen yapraklar (arka plan, flu)
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.15, // %15 şeffaflık
              child: Lottie.asset(
                'assets/animations/Autumn leaves.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteInspiration(WidgetRef ref, String id) async {
    await ref.read(inspirationsProvider.notifier).deleteInspiration(id);
  }
}

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

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({
    required this.item,
    required this.isCupertino,
    this.onDelete,
  });

  final _InspirationItem item;
  final bool isCupertino;
  final Function(String)? onDelete;

  @override
  Widget build(BuildContext context) {
    final TextStyle quoteStyle = isCupertino
        ? const TextStyle(
            fontFamily: 'Playpen Sans Thai',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
            height: 1.5,
          )
        : Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'Playpen Sans Thai',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ) ??
              const TextStyle(
                fontFamily: 'Playpen Sans Thai',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 1.5,
              );

    final TextStyle authorStyle = isCupertino
        ? const TextStyle(
            fontFamily: 'Playpen Sans Thai',
            fontSize: 18,
            color: CupertinoColors.systemGrey,
          )
        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'Playpen Sans Thai',
                color: Colors.black54,
              ) ??
              const TextStyle(
                fontFamily: 'Playpen Sans Thai',
                fontSize: 18,
                color: Colors.black54,
              );

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: constraints.maxHeight,
          child: Container(
            color: const Color(0xFFF2F2F2), // Soft grey arka plan
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '"${item.text}"',
                        textAlign: TextAlign.center,
                        style: quoteStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '— ${item.author}',
                        style: authorStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _ActionRow(
                        isCupertino: isCupertino,
                        isUser: item.isUser,
                        onDelete: item.isUser
                            ? () => onDelete!(item.userInspiration!.id)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.isCupertino,
    this.isUser = false,
    this.onDelete,
  });

  final bool isCupertino;
  final bool isUser;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (isUser && onDelete != null) {
      // Kullanıcının ilhamı ise silme butonu ekle
      actions.addAll([
        isCupertino
            ? _CupertinoIconButton(
                icon: CupertinoIcons.delete,
                onPressed: onDelete!,
                color: CupertinoColors.destructiveRed,
              )
            : _MaterialIconButton(
                icon: Icons.delete_outline,
                onPressed: onDelete!,
                color: Colors.red,
              ),
        const SizedBox(width: 32),
      ]);
    }

    // Diğer butonlar - Beğenme ve Kopyalama
    if (isCupertino) {
      actions.addAll([
        const _CupertinoIconButton(icon: CupertinoIcons.heart),
        const SizedBox(width: 32),
        const _CupertinoIconButton(icon: CupertinoIcons.doc_on_doc),
      ]);
    } else {
      actions.addAll([
        const _MaterialIconButton(icon: Icons.favorite_border),
        const SizedBox(width: 32),
        const _MaterialIconButton(icon: Icons.copy),
      ]);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: actions);
  }
}

class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({required this.icon, this.onPressed, this.color});

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed ?? () {},
      child: Icon(icon, size: 24, color: color ?? CupertinoColors.inactiveGray),
    );
  }
}

class _MaterialIconButton extends StatelessWidget {
  const _MaterialIconButton({required this.icon, this.onPressed, this.color});

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      icon: Icon(icon),
      color: color ?? Theme.of(context).colorScheme.outline,
      splashRadius: 24,
    );
  }
}

class _InspirationQuote {
  const _InspirationQuote({required this.text, required this.author});

  final String text;
  final String author;
}
