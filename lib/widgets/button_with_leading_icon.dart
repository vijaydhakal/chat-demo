import 'package:flutter/material.dart';

class ButtonWithLeadingIcon extends StatelessWidget {
  const ButtonWithLeadingIcon({super.key, 
    @required this.name,
    this.function,
    this.backgroundColor,
    required this.iconImage,
    this.iconColor,
    this.leading,
  });
  final String? name;
  final String iconImage;
  final Function? function;
  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: function == null ? null : () => function!(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: width / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFF707070).withOpacity(0.2)),
              color: backgroundColor,
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    name!,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Positioned(
                  left: 16,
                  child: leading ??
                      Image.network(
                        iconImage,
                        color: iconColor,
                        width: 22,
                        height: 22,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
