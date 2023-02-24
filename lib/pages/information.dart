import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    const Padding verticalPadding = Padding(padding: EdgeInsets.only(bottom: 32));
    const Padding horizontalPadding = Padding(padding: EdgeInsets.only(right: 8));

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            verticalPadding,
            Image.asset('assets/logo_rv&co.png', fit: BoxFit.fitWidth, width: 250),
            verticalPadding,
            const Text('Cinema Project Manager',
                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            verticalPadding,
            const Text(
                'CPM is a tool to efficiently manage the production of a cinema project. It is developed as an open-source project by the Studio Rv & Co, which is a non-profit organisation that produces audiovisual projects.',
                textAlign: TextAlign.center),
            verticalPadding,
            const Text('More about CPM', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: <Widget>[
              const Spacer(),
              TextButton(
                  onPressed: () => launchUrl(Uri.parse('https://github.com/StudioRvAndCo')),
                  child: const Text('GitHub')),
              const Spacer()
            ]),
            verticalPadding,
            const Text('More about Studio Rv & Co',
                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: <Widget>[
              const Spacer(),
              TextButton(onPressed: () => launchUrl(Uri.parse('https://rvandco.fr')), child: const Text('Website')),
              horizontalPadding,
              TextButton(
                  onPressed: () => launchUrl(Uri.parse('https://www.youtube.com/@studiorvandco')),
                  child: const Text('YouTube')),
              const Spacer()
            ])
          ],
        ),
      ),
    );
  }
}
