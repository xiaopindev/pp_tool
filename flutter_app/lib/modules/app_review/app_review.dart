import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

import 'app_review_controller.dart';

class AppReviewPage extends GetView<AppReviewController> {
  const AppReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'AppReview_Title'.localized,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Get.textTheme.titleLarge?.color),
              ),
            ),
            const SizedBox.shrink(),
            IconButton(
              onPressed: () {
                controller.closeAppReview();
              },
              icon: Icon(Icons.cancel, color: Get.textTheme.bodyMedium?.color),
            ),
          ],
        ),
        Container(
          height: 60,
          color: Colors.transparent,
          child: Center(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              unratedColor: HexColor('#E5E5E5'),
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                controller.updateRateValue(rating);
              },
            ),
          ),
        ),
        Container(
          height: 100,
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Text(
              'AppReview_Text2'.localized,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Get.textTheme.bodyMedium?.color),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            controller.buttonAction();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            fixedSize: const Size.fromHeight(50),
          ),
          child: Obx(() {
            var text = controller.isFullStar.value
                ? 'AppReview_BtnText2'.localized
                : 'AppReview_BtnText1'.localized;
            var textColor = controller.starCount.value > 0
                ? Get.theme.colorScheme.onPrimary
                : Colors.grey;
            return Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            );
          }),
        )
      ],
    );
  }
}
