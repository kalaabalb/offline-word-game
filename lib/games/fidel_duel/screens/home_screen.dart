import '../../../app/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../app/localization.dart';
import '../../../core/game_session.dart';
import '../services/data_service.dart';
import '../widgets/numbered_box.dart';

class FidelDuelLibraryScreen extends StatefulWidget {
  const FidelDuelLibraryScreen({required this.session, super.key});

  final GameSession session;

  @override
  State<FidelDuelLibraryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FidelDuelLibraryScreen> {
  final DataService dataService = DataService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await dataService.loadGameSets();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          strings.text('set.listTitle'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black45,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 10),
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                colors: [
                  JebenaTheme.terracotta,
                  JebenaTheme.saffron,
                  JebenaTheme.terracotta,
                  JebenaTheme.terracotta,
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Floating Bubbles - Fixed syntax
          Positioned(
            top: 100,
            left: 50,
            child: _FloatingBubble(
                size: 80, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: 200,
            right: 30,
            child: _FloatingBubble(
                size: 120, color: Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            top: 300,
            right: 100,
            child: _FloatingBubble(
                size: 60, color: Colors.white.withValues(alpha: 0.15)),
          ),

          // Content
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: dataService.gameSets.length,
                    itemBuilder: (context, index) {
                      final set = dataService.gameSets[index];
                      return NumberedBox(
                        number: set.id,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/triangle',
                            arguments: {
                              'setId': set.id,
                              'playerNames': widget.session.playerNames,
                              'session': widget.session,
                            },
                          ).then((completed) {
                            if (completed == true && context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_set');
          await _loadData();
        },
        backgroundColor: Colors.orangeAccent,
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class _FloatingBubble extends StatefulWidget {
  final double size;
  final Color color;

  const _FloatingBubble({required this.size, required this.color});

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.5, 0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
