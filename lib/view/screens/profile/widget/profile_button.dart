import 'package:user/util/dimensions.dart';
import 'package:user/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/view/widgets/custom_text.dart';

class ProfileButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subTitle;
  final bool? isButtonActive;
  final Function onTap;
  final Color? color;
  final Color? cardColor;
  final String? iconImage;
  const ProfileButton(
      {super.key,
      this.icon,
      required this.title,
      required this.onTap,
      this.isButtonActive,
      this.color,
      this.iconImage, this.subTitle, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: isButtonActive != null
              ? Dimensions.paddingSizeExtraSmall
              : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color:cardColor?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.1),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
         Row(
           children: [
             iconImage != null
                 ? Image.asset(iconImage!, height: 25, width: 25,color: Theme.of(context).textTheme.bodyMedium!.color,)
                 : Icon(icon,
                 size: 25,
                 color:
                 color ?? Theme.of(context).textTheme.bodyMedium!.color),
             const SizedBox(width: Dimensions.paddingSizeSmall),
             Text(title, style: robotoRegular),
           ],
         ),
          isButtonActive != null
              ? Row(
                children: [
                  CustomText(text: subTitle??"",color: Theme.of(context).textTheme.bodySmall?.color,),
                  Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: isButtonActive!,
                        activeTrackColor: Theme.of(context).primaryColor,
                        onChanged: (bool? value) => onTap(),
                        inactiveTrackColor:
                            Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
                      ),
                    ),
                ],
              )
              : const SizedBox()
        ]),
      ),
    );
  }
}


// class ProfileButton extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final bool? isButtonActive;
//   final Function onTap;
//   const ProfileButton({Key? key, required this.icon, required this.title, required this.onTap, this.isButtonActive}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap as void Function()?,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: Dimensions.paddingSizeSmall,
//           vertical: isButtonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
//         ),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//           boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
//         ),
//         child: Row(children: [
//           Icon(icon, size: 25),
//           const SizedBox(width: Dimensions.paddingSizeSmall),
//           Expanded(child: Text(title, style: robotoRegular)),
//           isButtonActive != null ? Switch(
//             value: isButtonActive!,
//             onChanged: (bool isActive) => onTap(),
//             activeColor: Theme.of(context).primaryColor,
//             activeTrackColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
//           ) : const SizedBox(),
//         ]),
//       ),
//     );
//   }
// }
