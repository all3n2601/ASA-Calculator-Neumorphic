import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/history_service.dart';
import '../services/sound_service.dart';
import '../screens/nemorphic_container.dart';

class HistorySidebar extends StatefulWidget {
  final bool darkMode;
  final bool isOpen;
  final Function(String) onHistoryItemTapped;
  final VoidCallback onClose;

  const HistorySidebar({
    super.key,
    required this.darkMode,
    required this.isOpen,
    required this.onHistoryItemTapped,
    required this.onClose,
  });

  @override
  State<HistorySidebar> createState() => _HistorySidebarState();
}

class _HistorySidebarState extends State<HistorySidebar>
    with SingleTickerProviderStateMixin {
  List<CalculationHistory> history = [];
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _loadHistory();
  }

  @override
  void didUpdateWidget(HistorySidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _animationController.forward();
        _loadHistory();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    final loadedHistory = await HistoryService.getHistory();
    setState(() {
      history = loadedHistory;
      isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    await SoundService.playClearTap();
    await HistoryService.clearHistory();
    await _loadHistory();
  }

  Future<void> _removeHistoryItem(CalculationHistory item) async {
    await SoundService.playButtonTap();
    await HistoryService.removeHistoryItem(item);
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    Color backgroundColor = widget.darkMode 
        ? const Color(0xFF2A3441) // Darker, less glaring background
        : const Color(0xFFF5F7FA); // Softer light background to reduce glare
    
    Color textColor = widget.darkMode
        ? Colors.white
        : Colors.grey.shade800; // Better contrast, less harsh
    Color subtitleColor = widget.darkMode
        ? Colors.white.withValues(alpha: 0.8)
        : Colors.grey.shade600; // Better contrast

    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: () {
            SoundService.playButtonTap();
            widget.onClose();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ),
        // Sidebar
        SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: double.infinity,
              child: NeuContainer(
                darkMode: widget.darkMode,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calculation History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              SoundService.playButtonTap();
                              widget.onClose();
                            },
                            child: NeuContainer(
                              darkMode: widget.darkMode,
                              padding: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(20),
                              child: Icon(
                                Icons.close,
                                color: textColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Clear history button
                      if (history.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: backgroundColor,
                                title: Text(
                                  'Clear History',
                                  style: TextStyle(color: textColor),
                                ),
                                content: Text(
                                  'Are you sure you want to clear all calculation history?',
                                  style: TextStyle(color: subtitleColor),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      SoundService.playButtonTap();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: widget.darkMode ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _clearHistory();
                                    },
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                        color: widget.darkMode ? Colors.red : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: NeuContainer(
                            darkMode: widget.darkMode,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: widget.darkMode ? Colors.red : Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Clear All',
                                  style: TextStyle(
                                    color: widget.darkMode ? Colors.red : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // History List
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: widget.darkMode ? Colors.green : Colors.red,
                                ),
                              )
                            : history.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          size: 64,
                                          color: subtitleColor,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No calculations yet',
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Your calculation history will appear here',
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: history.length,
                                    itemBuilder: (context, index) {
                                      final item = history[index];
                                      return Dismissible(
                                        key: Key('${item.equation}_${item.timestamp}'),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 16),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          _removeHistoryItem(item);
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            SoundService.playButtonTap();
                                            widget.onHistoryItemTapped(item.result);
                                            widget.onClose();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 12),
                                            child: NeuContainer(
                                              darkMode: widget.darkMode,
                                              padding: const EdgeInsets.all(16),
                                              borderRadius: BorderRadius.circular(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.equation,
                                                    style: TextStyle(
                                                      color: subtitleColor,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          '= ${item.result}',
                                                          style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        item.formattedTime,
                                                        style: TextStyle(
                                                          color: subtitleColor,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
