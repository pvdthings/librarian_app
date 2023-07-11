import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.onClearPressed,
  });

  final void Function(String value) onChanged;
  final void Function()? onClearPressed;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        constraints: const BoxConstraints(maxWidth: 400),
        hintText: 'Search...',
        icon: Icon(
          Icons.search_rounded,
          color: _searchController.text.isEmpty
              ? null
              : Theme.of(context).primaryIconTheme.color,
        ),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() => _searchController.clear());
                  widget.onClearPressed?.call();
                },
                icon: const Icon(Icons.clear_rounded),
                tooltip: 'Clear Search',
              ),
      ),
    );
  }
}
