import 'package:flutter/material.dart';

import '../common/custom_color.dart';
import '../common/custom_widget.dart';

class CustomRadioCheckbox extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const CustomRadioCheckbox({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: SizedBox(
          height: 35,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: isSelected
                    ? const Icon(Icons.check_box, color: CustomColor.redE8)
                    : const Icon(Icons.check_box_outline_blank_outlined, color: CustomColor.gray_9),
              ),
              const SizedBox(width: 8),
              customWidget.setText(value, color: CustomColor.gray_6),
            ],
          )),
    );
  }
}
