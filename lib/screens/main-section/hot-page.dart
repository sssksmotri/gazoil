import 'package:flutter/material.dart';
import 'package:gasoilt/api/offers.dart';
import 'package:gasoilt/screens/main-section/actions/hot-full.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/manager.dart';

class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  bool _personal = true;
  List<dynamic> offersList = [];
  List<Widget> offersListDisplay = [];

  void getData() async {
    getAll();
  }

  Future<void> getAll() async {
    if (!_personal) return;
    _personal = false;
    offersListDisplay = [];
    SharedPreferences instance = await SharedPreferences.getInstance();
    String? token = instance.getString('token');

    if (token == null) {
      // Обработка случая, если токен отсутствует
      print("Token is missing");
      return;
    }

    // Получаем список акций
    var response = await getalloffers(token);
    offersList = response['promotions'] ?? [];

    for (var element in offersList) {
      offersListDisplay.add(
        ActionCard(
          MediaQuery.of(context).size.height * .15,
          element['title'] ?? 'Без названия',
          element['description'] ?? 'Описание недоступно',
          element['valid'] ?? 'Дата неизвестна',
          element['pic'] ?? 'https://example.com/placeholder.png',
          element['fulldescription'] ?? '',
          false,
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .67,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: offersListDisplay.length,
            itemBuilder: (context, index) => offersListDisplay[index],
          ),
        ),
      ),
    );
  }
}

// Карточка акции с наложением текста и анимацией при нажатии
class ActionCard extends StatefulWidget {
  final double height;
  final String title;
  final String text;
  final String footer;
  final String image;
  final String description;
  final bool personal;

  const ActionCard(
      this.height, this.title, this.text, this.footer, this.image, this.description, this.personal,
      {super.key});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HotFullPage(
            imageUrl: widget.image,
            dates: widget.footer,
            title: widget.title,
            description: widget.description,
          ),
        ));
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
