import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../themes/manager.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';


class HotFullPage extends StatelessWidget {
  final String imageUrl;
  final String dates;
  final String title;
  final String description;

  HotFullPage({
    super.key,
    required this.imageUrl,
    required this.dates,
    required this.title,
    required this.description,
  });




  String formatDate(String date) {
    try {
      final parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
      final formattedDate = DateFormat("d MMMM yyyy").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return date;
    }
  }


  List<Widget> parseHtmlToWidgets(String html, bool isDark) {
    final List<Widget> widgets = [];
    final regExp = RegExp(r'(<br\s*/?>|<div.*?>|</div>|&nbsp;)');
    final parts = html.split(regExp);

    final urlRegExp = RegExp(r'https?://[^\s<>"]+(?=\s|$|[^\w/-]|[)\]>,;])');

    for (var part in parts) {
      if (part.isEmpty) continue;

      if (part == '&nbsp;') {
        widgets.add(const SizedBox(width: 4));  // Добавляем небольшой отступ
      } else if (part == '<br>' || part == '<br />') {
        widgets.add(const SizedBox(height: 8)); // Добавляем отступ
      } else if (part.startsWith('<div>')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(part.replaceAll('<div>', '').replaceAll('</div>', '')),
          ),
        );
      } else {
        final matches = urlRegExp.allMatches(part);
        int lastEnd = 0;
        List<TextSpan> textSpans = [];

        for (var match in matches) {
          if (lastEnd < match.start) {
            // Добавляем обычный текст между URL
            textSpans.add(TextSpan(
              text: part.substring(lastEnd, match.start),
              style: TextStyle(color: isDark? Colors.white:Colors.black), // Обычный текст
            ));
          }
          // Добавляем ссылку как часть текста
          final url = match.group(0);
          if (url != null) {
            // Проверяем последний символ и удаляем его, если это один из указанных символов
            String correctedUrl = url;
            if (correctedUrl.endsWith(')') || correctedUrl.endsWith(']') ||
                correctedUrl.endsWith('>') || correctedUrl.endsWith(',') ||
                correctedUrl.endsWith(';')) {
              correctedUrl = correctedUrl.substring(0, correctedUrl.length - 1);
            }
            final Uri uri = Uri.parse(correctedUrl);
            textSpans.add(TextSpan(
              text: correctedUrl,
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = () {
                launchUrl(uri, mode: LaunchMode.externalApplication);  // Открытие ссылки
              },
            ));
          }
          lastEnd = match.end;
        }

        if (lastEnd < part.length) {
          textSpans.add(TextSpan(
            text: part.substring(lastEnd),
            style: TextStyle(color: isDark? Colors.white:Colors.black),
          ));
        }


        if (textSpans.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(children: textSpans),
            ),
          ));
        } else {
          widgets.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(part),
          ));
        }
      }
    }

    return widgets;
  }





  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: !isDark
                    ? [const Color(0xffcbffd6), const Color(0xffcaffa0)]
                    : [const Color(0xff0d4b29), const Color(0xff0a8467)],
                stops: const [0, 1],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_right_alt,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Дата проведения",
                    style: const TextStyle(
                        fontSize: 14,
                      color: Colors.grey,
                    ),
                    ),
                  Text(
                    formatDate(dates),
                    style: const TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                  child:  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Ошибка загрузки изображения: $error');
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
                  ),
                  const SizedBox(height: 15),
                 ...parseHtmlToWidgets(description, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
