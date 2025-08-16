import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';

class ReadingSettingsDrawer extends ConsumerWidget {
  const ReadingSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fontSize = ref.watch(fontSizeProvider);
    final fontFamily = ref.watch(fontFamilyProvider);

    return Drawer(
      width: 300,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '읽기 설정',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                '글자 크기',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.text_decrease,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  Expanded(
                    child: Slider(
                      value: fontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 12,
                      label: '${fontSize.round()}',
                      onChanged: (value) {
                        ref.read(appStateProvider.notifier).setFontSize(value);
                      },
                    ),
                  ),
                  Icon(
                    Icons.text_increase,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),

              Center(
                child: Text(
                  '${fontSize.round()}pt',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                '폰트',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              ..._buildFontFamilyOptions(theme, fontFamily, ref),

              const SizedBox(height: 24),

              Text(
                '미리보기',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '이것은 선택된 폰트와 크기로 표시되는 미리보기 텍스트입니다.',
                  style: _getTextStyle(
                    theme.textTheme.bodyLarge,
                    fontSize,
                    fontFamily,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(
    TextStyle? baseStyle,
    double fontSize,
    String fontFamily,
  ) {
    if (fontFamily == 'default') {
      return baseStyle?.copyWith(fontSize: fontSize, height: 1.8) ??
          TextStyle(fontSize: fontSize, height: 1.8);
    }

    switch (fontFamily) {
      case 'noto_sans_kr':
        return GoogleFonts.notoSansKr(
          textStyle: baseStyle?.copyWith(fontSize: fontSize, height: 1.8),
        );
      case 'noto_serif_kr':
        return GoogleFonts.notoSerifKr(
          textStyle: baseStyle?.copyWith(fontSize: fontSize, height: 1.8),
        );
      case 'nanum_gothic':
        return GoogleFonts.nanumGothic(
          textStyle: baseStyle?.copyWith(fontSize: fontSize, height: 1.8),
        );
      case 'nanum_myeongjo':
        return GoogleFonts.nanumMyeongjo(
          textStyle: baseStyle?.copyWith(fontSize: fontSize, height: 1.8),
        );
      default:
        return baseStyle?.copyWith(fontSize: fontSize, height: 1.8) ??
            TextStyle(fontSize: fontSize, height: 1.8);
    }
  }

  TextStyle _getFontOptionTextStyle(
    TextStyle? baseStyle,
    String fontFamily,
    Color color,
  ) {
    if (fontFamily == 'default') {
      return baseStyle?.copyWith(color: color) ?? TextStyle(color: color);
    }

    switch (fontFamily) {
      case 'noto_sans_kr':
        return GoogleFonts.notoSansKr(
          textStyle: baseStyle?.copyWith(color: color),
        );
      case 'noto_serif_kr':
        return GoogleFonts.notoSerifKr(
          textStyle: baseStyle?.copyWith(color: color),
        );
      case 'nanum_gothic':
        return GoogleFonts.nanumGothic(
          textStyle: baseStyle?.copyWith(color: color),
        );
      case 'nanum_myeongjo':
        return GoogleFonts.nanumMyeongjo(
          textStyle: baseStyle?.copyWith(color: color),
        );
      default:
        return baseStyle?.copyWith(color: color) ?? TextStyle(color: color);
    }
  }

  List<Widget> _buildFontFamilyOptions(
    ThemeData theme,
    String currentFontFamily,
    WidgetRef ref,
  ) {
    final fontFamilies = [
      {'name': '기본', 'value': 'default'},
      {'name': 'Noto Sans KR', 'value': 'noto_sans_kr'},
      {'name': 'Noto Serif KR', 'value': 'noto_serif_kr'},
      {'name': '나눔고딕', 'value': 'nanum_gothic'},
      {'name': '나눔명조', 'value': 'nanum_myeongjo'},
    ];

    return fontFamilies.map((font) {
      final isSelected = currentFontFamily == font['value'];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            ref.read(appStateProvider.notifier).setFontFamily(font['value']!);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary)
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  font['name']!,
                  style: _getFontOptionTextStyle(
                    theme.textTheme.bodyMedium,
                    font['value']!,
                    isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check, color: theme.colorScheme.primary, size: 20),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
