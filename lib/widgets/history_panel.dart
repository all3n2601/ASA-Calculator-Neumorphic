import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/history_service.dart';
import '../screens/nemorphic_container.dart';

class HistoryPanel extends StatefulWidget {
  final bool darkMode;
  final Function(String) onHistoryItemTapped;

  const HistoryPanel({
    super.key,
    required this.darkMode,
    required this.onHistoryItemTapped,
  });

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  List<CalculationHistory> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
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
    await HistoryService.clearHistory();
    await _loadHistory();
  }

  Future<void> _removeHistoryItem(CalculationHistory item) async {
    await HistoryService.removeHistoryItem(item);
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.darkMode 
        ? const Color(0xFF374352) 
        : const Color(0xFFe6eeff);
    
    Color textColor = widget.darkMode ? Colors.white : Colors.black;
    Color subtitleColor = widget.darkMode ? Colors.white70 : Colors.black54;

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: NeuContainer(
        darkMode: widget.darkMode,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
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
                              onPressed: () => Navigator.pop(context),
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
                    child: Icon(
                      Icons.delete_outline,
                      color: widget.darkMode ? Colors.red : Colors.red,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
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
                          child: Text(
                            'No calculations yet',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
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
                                onTap: () => widget.onHistoryItemTapped(item.result),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: backgroundColor.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.equation,
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.result,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            item.formattedTime,
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
    );
  }
}
