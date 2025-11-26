import 'package:flutter/material.dart';
import 'bottom_sheet_container_widget.dart';

class PhoneSelectionBottomSheet extends StatelessWidget {
  final String selectedPhoneAsset;
  final ValueChanged<String> onPhoneSelected;

  const PhoneSelectionBottomSheet({
    super.key,
    required this.selectedPhoneAsset,
    required this.onPhoneSelected,
  });

  final List<Map<String, String>> _phones = const [
    {'name': 'Vivo', 'asset': 'assets/phones/vivo.png'},
    {'name': 'iPhone 14', 'asset': 'assets/phones/iphone_14.png'},
    {'name': 'iPhone 16', 'asset': 'assets/phones/iphone_16.png'},
    {'name': 'Pixel', 'asset': 'assets/phones/google_pixel.png'},
    {'name': 'Samsung', 'asset': 'assets/phones/samsung_galaxy.png'},
    {'name': 'Xiaomi', 'asset': 'assets/phones/xiaomi_redmi.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return BottomSheetContainerWidget(
          expandChild: true,
          title: 'Select Phone',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _phones.length,
              itemBuilder: (context, index) {
                final phone = _phones[index];
                final isSelected = phone['asset'] == selectedPhoneAsset;

                return GestureDetector(
                  onTap: () {
                    onPhoneSelected(phone['asset']!);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            phone['asset']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          phone['name']!,
                          style: TextStyle(
                            color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}
