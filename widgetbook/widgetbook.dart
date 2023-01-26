import 'package:flutter/material.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
import 'package:widgetbook/widgetbook.dart';

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      categories: [
        WidgetbookCategory(
          name: "Lending",
          folders: [
            WidgetbookFolder(
              name: "pages",
              widgets: [
                WidgetbookComponent(name: "main", useCases: [
                  WidgetbookUseCase(
                      name: "LendingPage",
                      builder: (context) {
                        return const LendingPage();
                      })
                ]),
              ],
            ),
          ],
        ),
      ],
      themes: [
        WidgetbookTheme(
          name: "Default",
          data: ThemeData(),
        ),
      ],
      appInfo: AppInfo(name: "Librarian"),
    );
  }
}
