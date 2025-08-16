import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../providers/app_state_provider.dart';
import '../widgets/reading_settings_drawer.dart';

class BookReaderScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookReaderScreen({
    super.key,
    required this.bookId,
  });

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen>
    with TickerProviderStateMixin {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _goToPreviousPage(Book book) {
    final currentPage = ref.read(currentPageProvider);
    if (currentPage > 0) {
      ref.read(appStateProvider.notifier).setCurrentPage(currentPage - 1);
      setState(() {
        _showControls = true;
      });
      _startHideControlsTimer();
    }
  }

  void _goToNextPage(Book book) {
    final currentPage = ref.read(currentPageProvider);
    if (currentPage < book.content.length - 1) {
      ref.read(appStateProvider.notifier).setCurrentPage(currentPage + 1);
      setState(() {
        _showControls = true;
      });
      _startHideControlsTimer();
    }
  }

  void _handleTap(TapUpDetails details, Book book) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    // Left third - previous page
    if (tapPosition < screenWidth / 3) {
      _goToPreviousPage(book);
    }
    // Right third - next page
    else if (tapPosition > (screenWidth * 2) / 3) {
      _goToNextPage(book);
    }
    // Middle third - toggle controls
    else {
      _toggleControls();
    }
  }

  TextStyle _getTextStyle(TextStyle? baseStyle, double fontSize, String fontFamily) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = ref.watch(bookByIdProvider(widget.bookId));
    final currentPage = ref.watch(currentPageProvider);
    final isFavorite = ref.watch(isFavoriteProvider(widget.bookId));
    final fontSize = ref.watch(fontSizeProvider);
    final fontFamily = ref.watch(fontFamilyProvider);

    if (book == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('책을 찾을 수 없습니다'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('홈으로 돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    final progress = ((currentPage + 1) / book.content.length) * 100;
    
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const ReadingSettingsDrawer(),
      body: Stack(
        children: [
          // Reading area
          GestureDetector(
            onTapUp: (details) => _handleTap(details, book),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.colorScheme.surface,
              padding: EdgeInsets.only(
                top: _showControls ? 120 : 40,
                bottom: _showControls ? 140 : 40,
                left: 24,
                right: 24,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Page indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${currentPage + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Page content
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          book.content[currentPage],
                          style: _getTextStyle(theme.textTheme.bodyLarge, fontSize, fontFamily),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top header
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showControls ? 0 : -120,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Header row
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.go('/'),
                            icon: const Icon(Icons.arrow_back),
                            iconSize: 20,
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    book.author,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          IconButton(
                            onPressed: () => ref.read(appStateProvider.notifier).toggleFavorite(book.id),
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite 
                                ? Colors.red.shade500 
                                : theme.colorScheme.onSurfaceVariant,
                            ),
                            iconSize: 20,
                          ),
                          
                          IconButton(
                            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                            icon: const Icon(Icons.settings),
                            iconSize: 20,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${currentPage + 1}/${book.content.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom navigation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showControls ? 0 : -140,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: currentPage > 0 ? () => _goToPreviousPage(book) : null,
                              icon: const Icon(Icons.chevron_left),
                              label: const Text('이전'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          IconButton(
                            onPressed: _toggleControls,
                            icon: const Icon(Icons.menu),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              foregroundColor: theme.colorScheme.onSurface,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: currentPage < book.content.length - 1 
                                ? () => _goToNextPage(book) 
                                : null,
                              icon: const Icon(Icons.chevron_right),
                              label: const Text('다음'),
                              iconAlignment: IconAlignment.end,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Reading info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${book.publishYear}년',
                            style: theme.textTheme.bodySmall,
                          ),
                          const Text(' • '),
                          Text(
                            '${book.content.length}페이지',
                            style: theme.textTheme.bodySmall,
                          ),
                          const Text(' • '),
                          Text(
                            '${progress.round()}% 완료',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Touch area hints (only show when controls are visible)
          if (_showControls)
            Positioned.fill(
              child: IgnorePointer(
                child: Row(
                  children: [
                    // Left area hint
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_left,
                          size: 32,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Center area hint
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'TAP',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Right area hint
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chevron_right,
                          size: 32,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}