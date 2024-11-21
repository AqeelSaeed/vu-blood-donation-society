import 'package:flutter/material.dart';

class DropdownComponent<T> extends StatelessWidget {
  final String? title;
  final List<T> items;
  final String? hint;
  final T? value;
  final String? prefixIcon;
  final bool isExpanded;
  final void Function(T?) onChanged;
  final String Function(T label) labelBuilder;
  final String? Function(T?)? validator;
  final Widget? icon;

  const DropdownComponent(
      {super.key,
      this.title,
      required this.items,
      this.hint,
      required this.value,
      this.prefixIcon,
      this.isExpanded = true,
      required this.labelBuilder,
      this.validator,
      this.icon,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        if (title != null) const SizedBox(height: 8),
        Container(
          // height: 50,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.red),
          ),
          child: DropdownButtonFormField<T>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            // underline: Container(
            //   height: 0,
            //   decoration: const BoxDecoration(color: Colors.transparent),
            // ),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: prefixIcon == null
                    ? null
                    : Image.asset(
                        prefixIcon!,
                        fit: BoxFit.contain,
                        color: Colors.red,
                      ),
                prefixIconConstraints: const BoxConstraints(maxWidth: 21)),
            value: value,
            onChanged: onChanged,
            isDense: true,
            dropdownColor: Colors.white,
            padding: const EdgeInsets.only(left: 15, right: 15),
            isExpanded: isExpanded,
            icon: const Icon(Icons.keyboard_arrow_down_sharp,
                color: Colors.black),
            style: TextStyle(fontSize: 14, color: Colors.black),
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                hint ?? 'Choose',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            focusColor: Colors.transparent,
            items: items
                .map<DropdownMenuItem<T>>((T item) => DropdownMenuItem<T>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Text(
                          labelBuilder(item),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
