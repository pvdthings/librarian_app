import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:librarian_app/src/widgets/detail.dart';

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      const Action(
        title: 'Extend All Due Dates',
        actionEndpoint: '',
        description:
            'Extends all loan due dates to a new specified date. This is very useful if open hours have been canceled.',
      ),
    ];

    final isMobileScreen = isMobile(context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              ...actions.map((a) {
                return FractionallySizedBox(
                  widthFactor: isMobileScreen ? 1 : 0.33,
                  child: _Action(
                    title: a.title,
                    description: a.description,
                    onRun: () {},
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class Action {
  const Action({
    required this.title,
    this.description,
    required this.actionEndpoint,
  });

  final String title;
  final String? description;
  final String actionEndpoint;
}

class _Action extends StatelessWidget {
  const _Action({
    required this.title,
    this.description,
    this.onRun,
  });

  final String title;
  final String? description;
  final Function()? onRun;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.electric_bolt_rounded,
              color: Colors.amber,
            ),
            title: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20)),
          ),
          if (description != null)
            Detail(
              useListTile: true,
              label: 'Description',
              value: description!,
            ),
          if (onRun != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: onRun,
                    child: const Text('Run Action'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
