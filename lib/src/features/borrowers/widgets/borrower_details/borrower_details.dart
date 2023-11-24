import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/edited_borrower_details_providers.dart';
import 'package:librarian_app/src/features/borrowers/providers/selected_borrower_provider.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/issues_card.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/payments_card.dart';

class BorrowerDetails extends ConsumerWidget {
  const BorrowerDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrower = ref.watch(selectedBorrowerProvider)!;

    final emailController = TextEditingController(
      text: ref.watch(emailProvider) ?? borrower.email,
    );
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));

    final phoneController =
        TextEditingController(text: ref.watch(phoneProvider) ?? borrower.phone);
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: borrower.name),
          readOnly: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.person_rounded),
            labelText: 'Name',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 500),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            icon: Icon(Icons.email_rounded),
            labelText: 'Email',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 500),
          ),
          onChanged: (value) {
            ref.read(emailProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone_rounded),
            labelText: 'Phone',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 500),
          ),
          onChanged: (value) {
            ref.read(phoneProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 32),
        const IssuesCard(),
        const SizedBox(height: 32),
        const PaymentsCard(),
      ],
    );
  }
}
