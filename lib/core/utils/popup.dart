import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/widgets/my_buttons.dart';

class Popup {
  //
  /// ---------------------------------------------------------- `general`
  static void general() {
    alert(
      'Oops',
      'Sorry, something went wrong! please report us while we work on resolving it.',
    );
  }

  /// ---------------------------------------------------------- `empty list`
  static Widget nill(String text) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bubble_chart_outlined, size: 30),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------------------------------------- `alert`
  static void alert(String title, String description, {bool? isDismissable}) {
    Get.defaultDialog(
      backgroundColor: AppColors.scaffold,
      barrierDismissible: isDismissable ?? true,
      //
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- title
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '  $title',
                    style: GoogleFonts.quicksand(
                      textStyle: AppTStyles.heading.copyWith(
                        color: AppColors.prim,
                      ),
                    ),
                  ),
                ),
                const MyCloseBtn()
              ],
            ),
          ),
          const Divider(indent: 15, endIndent: 15),
          // ----------------- description
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(description, style: AppTStyles.body),
          ),
          // ----------------- button
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
            child: SizedBox(
              width: double.infinity,
              child: MyOutlinedBtn(
                'Got it',
                () => Get.back(),
                radius: 15,
              ),
            ),
          ),
        ],
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  /// ---------------------------------------------------------- `confirm`
  static void confirm(
    String title,
    String description, {
    required VoidCallback yesFun,
    bool? isDismissable = true,
    VoidCallback? noFun,
  }) {
    Get.defaultDialog(
      backgroundColor: AppColors.scaffold,
      barrierDismissible: isDismissable ?? true,
      //
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- title
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '  $title',
                    style: GoogleFonts.quicksand(
                      textStyle: AppTStyles.heading.copyWith(
                        color: AppColors.prim,
                      ),
                    ),
                  ),
                ),
                if (isDismissable == true) const MyCloseBtn()
              ],
            ),
          ),
          const Divider(indent: 15, endIndent: 15),
          // ----------------- description
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Text(description, style: AppTStyles.body),
          ),
          // ----------------- buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: MyOutlinedBtn(
                    'No',
                    noFun ?? () => Get.back(),
                    icon: Icons.close_rounded,
                    radius: 13,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text('|'),
                ),
                Expanded(
                  child: MyOutlinedBtn('Yes ', () {
                    Get.back();
                    yesFun();
                  }, icon: Icons.check_rounded, radius: 13),
                ),
                const SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  /// ---------------------------------------------------------- `snack bar`
  static void snackbar(String message, {bool? status}) {
    Color myColor(int a) => status == null
        ? const Color(0xFFFFEBAF)
        : status
            ? const Color(0xFF79F17D)
            : const Color(0xFFE9746C);

    Get.showSnackbar(
      GetSnackBar(
        padding: const EdgeInsets.all(0),
        messageText: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: myColor(170),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: myColor(255)),
          ),
          child: Center(
            child: Text(
              message,
              style: AppTStyles.smallCaption.copyWith(
                overflow: TextOverflow.ellipsis,
                color: AppColors.dScaffoldBG,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        duration: const Duration(milliseconds: 4000),
        isDismissible: false,
      ),
    );
  }

  /// ---------------------------------------------------------- `loading`
  static void loading({String? label}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            bottom: label == null
                ? null
                : PreferredSize(
                    preferredSize: const Size(double.infinity, 30),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.prim,
                        border: Border(
                          top: BorderSide(
                              color: AppColors.dScaffoldBG, width: 2),
                          bottom: BorderSide(
                              color: AppColors.dScaffoldBG, width: 2.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: const TextStyle(color: AppColors.dScaffoldBG),
                        ),
                      ),
                    ),
                  ),
          ),
          body: LinearProgressIndicator(
            backgroundColor: AppColors.prim.withAlpha(50),
          ),
        ),
      ),
      barrierColor: AppColors.prim.withAlpha(10),
    );
  }

  /// ---------------------------------------------------------- `circle loader`
  static circleLoader({String? label}) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.listTile,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: AppColors.scaffold,
                    color: AppColors.prim,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              if (label != null)
                Text(
                  label,
                  style: AppTStyles.subHeading,
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------------------------------------------------- `image loader`
  static Widget imageLoader(String imageUrl,
      {BoxFit? fit, double? height, double? width}) {
    return Image.network(
      imageUrl,
      fit: fit,
      height: height,
      width: width,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                value: loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------------------------------------------------------- `terminate loading`
  static void terminateLoading() => Get.close(1);

  /// ---------------------------------------------------------- `CAUTION MESSAGE`
  static Widget caution() => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.crisis_alert,
            size: 18,
            color: AppColors.danger,
          ),
          Text(
            ' This process is irreversible! Please proceed with caution!',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.danger,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}
