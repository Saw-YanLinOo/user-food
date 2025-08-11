import 'package:user/helper/responsive_helper.dart';
import 'package:user/view/base/paginated_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../../../controller/product_controller.dart';
import '../../../../../util/dimensions.dart';
import '../new/menu_card.dart';

class AllProducts extends StatelessWidget {
  final ScrollController scrollController;
  const AllProducts({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveHelper.isDesktop(context)
            ? 
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  'Menu'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeDefault,
                    right: Dimensions.paddingSizeDefault,
                    bottom: Dimensions.paddingSizeLarge),
                child: Text(
                  'Menu'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              const SizedBox(height: 10,),
        GetBuilder<ProductController>(builder: (productController) {
          return PaginatedListView(
              scrollController: scrollController,
              totalSize: productController.productModel?.totalSize,
              offset: productController.productModel?.offset,
              onPaginate: (int? offset) async =>
                  await productController.getAllProductList(false, offset!),
              productView: ResponsiveHelper.isDesktop(context)
                  ?
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 400,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault,
                            right: Dimensions.paddingSizeDefault,
                            bottom: Dimensions.paddingSizeDefault),
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            productController.productModel?.products?.length ??
                                0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 2,
                            position: index,
                            duration: const Duration(seconds: 6),
                            child: ScaleAnimation(
                              //horizontalOffset: 500,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {},
                                  child: MenuCard(
                                    isBestItem: false,
                                    product: productController
                                        .productModel!.products![index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ) :
ResponsiveHelper.isMobile(context)?
                  AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 260,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault,
                            right: Dimensions.paddingSizeDefault,
                            bottom: Dimensions.paddingSizeDefault),
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            productController.productModel?.products?.length ??
                                0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 2,
                            position: index,
                            duration: const Duration(seconds: 6),
                            child: ScaleAnimation(
                              //horizontalOffset: 500,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {},
                                  child: MenuCard(
                                    isBestItem: false,
                                    product: productController
                                        .productModel!.products![index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ):
                    AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 300,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault,
                            right: Dimensions.paddingSizeDefault,
                            bottom: Dimensions.paddingSizeDefault),
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            productController.productModel?.products?.length ??
                                0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 2,
                            position: index,
                            duration: const Duration(seconds: 6),
                            child: ScaleAnimation(
                              //horizontalOffset: 500,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {},
                                  child: MenuCard(
                                    isBestItem: false,
                                    product: productController
                                        .productModel!.products![index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  
                  )
                  
                  
                  
                  ;
        }),
      ],
    );
  }
}
