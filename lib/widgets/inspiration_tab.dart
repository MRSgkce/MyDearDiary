import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InspirationTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: isCupertino
          ? const BouncingScrollPhysics(parent: PageScrollPhysics())
          : const PageScrollPhysics(),
      itemCount: _quotes.length,
      itemBuilder: (context, index) {
        final quote = _quotes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _InspirationCard(quote: quote, isCupertino: isCupertino),
        );
      },
    );
  }
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({required this.quote, required this.isCupertino});

  final _InspirationQuote quote;
  final bool isCupertino;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isCupertino
        ? CupertinoColors.separator
        : Theme.of(context).colorScheme.outline.withOpacity(0.3);

    final TextStyle quoteStyle = isCupertino
        ? const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
            height: 1.5,
          )
        : Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ) ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.5,
              );

    final TextStyle authorStyle = isCupertino
        ? const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey)
        : Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54) ??
              const TextStyle(fontSize: 16, color: Colors.black54);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: constraints.maxHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isCupertino
                  ? CupertinoColors.systemBackground
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isCupertino
                  ? [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 16),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '"${quote.text}"',
                          textAlign: TextAlign.center,
                          style: quoteStyle,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '— ${quote.author}',
                          style: authorStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        _ActionRow(isCupertino: isCupertino),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.isCupertino});

  final bool isCupertino;

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _CupertinoIconButton(icon: CupertinoIcons.heart),
          SizedBox(width: 32),
          _CupertinoIconButton(icon: CupertinoIcons.bookmark),
          SizedBox(width: 32),
          _CupertinoIconButton(icon: CupertinoIcons.square_arrow_up),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _MaterialIconButton(icon: Icons.favorite_border),
        SizedBox(width: 32),
        _MaterialIconButton(icon: Icons.bookmark_border),
        SizedBox(width: 32),
        _MaterialIconButton(icon: Icons.ios_share_outlined),
      ],
    );
  }
}

class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Icon(icon, size: 24, color: CupertinoColors.inactiveGray),
    );
  }
}

class _MaterialIconButton extends StatelessWidget {
  const _MaterialIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon),
      color: Theme.of(context).colorScheme.outline,
      splashRadius: 24,
    );
  }
}

class _InspirationQuote {
  const _InspirationQuote({required this.text, required this.author});

  final String text;
  final String author;
}
