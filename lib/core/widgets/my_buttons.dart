import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

/// ----------------------------------------------------------------- `BACK BUTTON`
class MyBackBtn extends StatelessWidget {
  const MyBackBtn({this.icon, this.onTap, this.size, this.btnSize, super.key});

  final IconData? icon;
  final VoidCallback? onTap;
  final double? size, btnSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      width: 37,
      child: FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: onTap ?? () => Get.back(),
        elevation: 0,
        highlightElevation: 5,
        child: Container(
          height: btnSize ?? 32,
          width: btnSize ?? 32,
          decoration: const BoxDecoration(
            color: Color.fromARGB(40, 0, 0, 0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon ?? Icons.chevron_left_rounded, size: size ?? 25),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `CLOSE`
class MyCloseBtn extends StatelessWidget {
  const MyCloseBtn({this.icon, this.ontap, super.key});

  final VoidCallback? ontap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: ontap ?? () => Get.back(),
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.prim,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.circle,
                color: AppColors.scaffold,
                size: 30,
              ),
            ),
            Icon(icon ?? Icons.close, size: 23, color: AppColors.oppScaffold),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `OUTLINE BUTTONS`
class MyOutlinedBtn extends StatelessWidget {
  const MyOutlinedBtn(
    this.label,
    this.ontap, {
    this.icon,
    this.radius,
    super.key,
  });

  final VoidCallback? ontap;
  final String label;
  final IconData? icon;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    /// ----------------------------- `Label`
    if (icon == null) {
      return OutlinedButton(
        onPressed: ontap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
          side: const BorderSide(width: 1, color: AppColors.prim),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(label, style: AppTStyles.outlineButton),
      );
    }

    /// ----------------------------- `Label & Icon`
    return OutlinedButton.icon(
      onPressed: ontap,
      icon: Icon(icon, color: AppColors.outlineButton),
      label: Text(label, style: AppTStyles.outlineButton),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        side: const BorderSide(width: 1, color: AppColors.prim),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `ELEVATED BUTTONS`
class MyElevatedBtn extends StatelessWidget {
  const MyElevatedBtn(
    this.label,
    this.ontap, {
    this.icon,
    this.radius,
    super.key,
  });

  final VoidCallback? ontap;
  final String label;
  final IconData? icon;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    /// ----------------------------- `Label`
    if (icon == null) {
      return ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
          side: const BorderSide(width: 1, color: AppColors.prim),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(label, style: AppTStyles.elevatedButton),
      );
    }

    /// ----------------------------- `Label & Icon`
    return ElevatedButton.icon(
      onPressed: ontap,
      icon: Icon(icon, color: AppColors.elevatedButton),
      label: Text(label, style: AppTStyles.elevatedButton),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        side: const BorderSide(width: 1, color: AppColors.prim),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `ICON Button`
class MyIconBtn extends StatelessWidget {
  const MyIconBtn(
    this.icon,
    this.ontap, {
    this.size,
    this.color,
    this.radius,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback ontap;
  final double? size;
  final Color? color;
  final double? radius;

  primary(int a) =>
      color != null ? color!.withAlpha(a) : AppColors.prim.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              color: primary(30),
              borderRadius: BorderRadius.circular(radius ?? 100),
            ),
            child: IconButton(
              splashRadius: 30,
              icon: Icon(
                icon,
                size: 32,
                color: color ?? primary(255),
              ),
              onPressed: ontap,
              splashColor: primary(150),
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `SELECTABLE`
class MySelectableIconBtn extends StatelessWidget {
  const MySelectableIconBtn(
    this.isSelected,
    this.selectedIcon,
    this.unSelectedIcon,
    this.ontap, {
    this.radius,
    this.size,
    Key? key,
  }) : super(key: key);

  final IconData selectedIcon;
  final IconData unSelectedIcon;
  final VoidCallback ontap;
  final double? radius;
  final double? size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: InkWell(
            splashColor: AppColors.prim.withAlpha(60),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 100),
                border: Border.all(
                  width: isSelected ? 3.5 : 1.2,
                  color: isSelected
                      ? AppColors.prim
                      : AppColors.prim.withAlpha(80),
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isSelected ? selectedIcon : unSelectedIcon,
                  size: 32,
                  color: AppColors.prim,
                ),
                onPressed: ontap,
                splashColor: AppColors.prim.withAlpha(80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------- `CHIP`
class MyChip extends StatelessWidget {
  const MyChip(this.label, {this.mr = 0, super.key});

  final String label;
  final double mr;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.5,
      margin: EdgeInsets.only(right: mr),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.prim),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(child: Text(label, style: AppTStyles.smallCaption)),
    );
  }
}

/// ----------------------------------------------------------------- `NO INDENT DIVIDER`
class NoIndentDivider extends StatelessWidget {
  const NoIndentDivider({this.i = 0, this.ei = 0, super.key});

  final double i, ei;

  @override
  Widget build(BuildContext context) {
    return Divider(indent: i, endIndent: ei);
  }
}
