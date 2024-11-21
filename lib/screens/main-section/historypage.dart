import 'package:flutter/material.dart';
import 'package:gasoilt/screens/main-section/historyBodies/operations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int body = 1;

  void setBody0() {
    setState(() {
      body = 0;
    });
  }

  void setBody1() {
    setState(() {
      body = 1;
    });
  }

  void setBody2() {
    setState(() {
      body = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // отображаем правильное тело
    return OperationsHistoryBody(
      setBody0: setBody0,
      setBody1: setBody1,
      setBody2: setBody2,
    );
  }
}


Widget pointsContainer(var points, bool isDark, {bool isBurned = false}) {
  return Container(
    height: 70,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    decoration: BoxDecoration(
      color: isBurned
          ? Colors.orange.withOpacity(0.1)
          : points > 0
          ? Colors.greenAccent.withOpacity(0.1)
          : Colors.redAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          isBurned ? FontAwesomeIcons.fire : FontAwesomeIcons.coins,
          color: isBurned ? Colors.red : (points > 0 ? Colors.green : Colors.red),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          isBurned ? '${points}' : (points > 0 ? '+${points}' : '${points}'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isBurned ? Colors.red : (points > 0 ? Colors.green : Colors.red),
            decoration: isBurned ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        if (isBurned)
          const SizedBox(width: 6),
        if (isBurned)
          const Text('сгорели', style: TextStyle(fontSize: 14, color: Colors.red)),
        if (!isBurned) ...[
          const SizedBox(width: 6),
           Text('баллов', style: TextStyle(fontSize: 14,  color: isDark ? Colors.white : Colors.black,)),
        ]
      ],
    ),
  );
}

Widget buildHistoryItem(BuildContext context, String date, String address, String productName, int points, int quantity, bool isDark) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            pointsContainer(points, isDark),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Количество: $quantity',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black54),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '=${quantity.toString()}₽',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

