import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ui';

import 'package:user/controller/location_controller.dart';
import 'package:user/controller/order_controller.dart';
import 'package:user/data/model/body/notification_body.dart';
import 'package:user/data/model/response/address_model.dart';
import 'package:user/data/model/response/conversation_model.dart';
import 'package:user/data/model/response/order_model.dart';
import 'package:user/data/model/response/restaurant_model.dart';
import 'package:user/helper/route_helper.dart';
import 'package:user/util/dimensions.dart';
import 'package:user/util/images.dart';
import 'package:user/view/base/custom_app_bar.dart';
import 'package:user/view/screens/order/widget/track_details_view.dart';
import 'package:user/view/screens/order/widget/tracking_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  const OrderTrackingScreen({super.key, required this.orderID});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  final Set<Polyline> _polylines = HashSet<Polyline>();
  void _loadData() async {
    await Get.find<LocationController>().getCurrentLocation(true,
        notify: false,
        defaultLatLng: LatLng(
          double.parse(
              Get.find<LocationController>().getUserAddress()!.latitude!),
          double.parse(
              Get.find<LocationController>().getUserAddress()!.longitude!),
        ));
   // Get.find<OrderController>().trackOrderForGuest(widget.orderID, null, true);
    Get.find<OrderController>().callTrackOrderApiFOrGuest(
        orderModel: Get.find<OrderController>().trackModel,
        orderId: widget.orderID.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadData();
    // Get.find<OrderController>().callTrackOrderApiFOrGuest(
    //     orderModel: Get.find<OrderController>().trackModel,
    //     orderId: widget.orderID.toString());
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<OrderController>().callTrackOrderApiFOrGuest(
          orderModel: Get.find<OrderController>().trackModel,
          orderId: widget.orderID.toString());
    } else if (state == AppLifecycleState.paused) {
      Get.find<OrderController>().cancelTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    Get.find<OrderController>().cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_tracking'.tr),
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? track;
        if (orderController.trackModel != null) {
          track = orderController.trackModel;
        }

        return track != null
            ? Center(
                child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Stack(children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(track.deliveryAddress!.latitude!),
                              double.parse(track.deliveryAddress!.longitude!),
                            ),
                            zoom: 16),
                        mapType: MapType.normal,
                        polylines: _polylines,
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        zoomControlsEnabled: true,
                        markers: _markers,

                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _isLoading = false;
                        },
                        // onCameraMove: (CameraPosition position) {
                        //   if (position.zoom > 16) {
                        //     _controller!.moveCamera(
                        //         CameraUpdate.newCameraPosition(CameraPosition(
                        //       target: position.target,
                        //       zoom: 16,
                        //     )));
                        //   }
                        // },

                        onCameraIdle: () {
                          setMarker(
                            track!.restaurant,
                            track.deliveryMan,
                            track.orderType == 'take_away'
                                ? Get.find<LocationController>()
                                            .position
                                            .latitude ==
                                        0
                                    ? track.deliveryAddress
                                    : AddressModel(
                                        latitude: Get.find<LocationController>()
                                            .position
                                            .latitude
                                            .toString(),
                                        longitude:
                                            Get.find<LocationController>()
                                                .position
                                                .longitude
                                                .toString(),
                                        address: Get.find<LocationController>()
                                            .address,
                                      )
                                : track.deliveryAddress,
                            track.orderType == 'take_away',
                          );
                        },
                      ),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      Positioned(
                        top: Dimensions.paddingSizeSmall,
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                        child: TrackingStepperWidget(
                            status: track.orderStatus,
                            takeAway: track.orderType == 'take_away'),
                      ),
                      Positioned(
                        bottom: Dimensions.paddingSizeSmall,
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                        child: TrackDetailsView(
                            track: track,
                            callback: () async {
                              orderController.cancelTimer();
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBody(
                                    deliverymanId: track!.deliveryMan!.id,
                                    orderId: int.parse(widget.orderID!)),
                                user: User(
                                    id: track.deliveryMan!.id,
                                    fName: track.deliveryMan!.fName,
                                    lName: track.deliveryMan!.lName,
                                    image: track.deliveryMan!.image),
                              ));
                              orderController.callTrackOrderApiFOrGuest(
                                  orderModel: track,
                                  orderId: track.id.toString());
                            }),
                      ),
                    ])))
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void setMarker(Restaurant? restaurant, DeliveryMan? deliveryMan,
      AddressModel? addressModel, bool takeAway) async {
    try {
      Uint8List restaurantImageData =
          await convertAssetToUnit8List(Images.restaurantMarker, width: 100);
      Uint8List deliveryBoyImageData =
          await convertAssetToUnit8List(Images.deliveryMBike, width: 100);
      Uint8List destinationImageData = await convertAssetToUnit8List(
        takeAway ? Images.myLocationMarker : Images.mapMarker,
        width: takeAway ? 50 : 100,
      );

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if (_controller != null) {
        if (double.parse(addressModel!.latitude!) <
            double.parse(restaurant!.latitude!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
            northeast: LatLng(double.parse(restaurant.latitude!),
                double.parse(restaurant.longitude!)),
          );
          rotation = 0;
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(restaurant.latitude!),
                double.parse(restaurant.longitude!)),
            northeast: LatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 12)));
      // if (!ResponsiveHelper.isWeb()) {
      //   zoomToFit(_controller, bounds, centerBounds, padding: 1.5);
      // }

      // Marker
      _markers = HashSet<Marker>();
      addressModel != null
          ? _markers.add(Marker(
              markerId: const MarkerId('destination'),
              position: LatLng(double.parse(addressModel.latitude!),
                  double.parse(addressModel.longitude!)),
              infoWindow: InfoWindow(
                title: 'Destination',
                snippet: addressModel.address,
              ),
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(destinationImageData),
            ))
          : const SizedBox();

      restaurant != null
          ? _markers.add(Marker(
              markerId: const MarkerId('restaurant'),
              position: LatLng(double.parse(restaurant.latitude!),
                  double.parse(restaurant.longitude!)),
              infoWindow: InfoWindow(
                title: 'restaurant'.tr,
                snippet: restaurant.address,
              ),
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(restaurantImageData),
            ))
          : const SizedBox();

      deliveryMan != null
          ? _markers.add(Marker(
              markerId: const MarkerId('delivery_boy'),
              position: LatLng(double.parse(deliveryMan.lat ?? '0'),
                  double.parse(deliveryMan.lng ?? '0')),
              infoWindow: InfoWindow(
                title: 'delivery_man'.tr,
                snippet: deliveryMan.location,
              ),
              rotation: rotation,
              icon: GetPlatform.isWeb
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(deliveryBoyImageData),
            ))
          : const SizedBox();

      // Polyline
      if (deliveryMan != null && addressModel != null) {
        List<LatLng> polylineCoordinates = [];
        PolylinePoints polylinePoints = PolylinePoints();
        // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        //   // 'google_map_api_key',
        //   // PointLatLng(double.parse(deliveryMan.lat ?? '0'),
        //   //     double.parse(deliveryMan.lng ?? '0')),
        //   // PointLatLng(double.parse(addressModel.latitude!),
        //   //     double.parse(addressModel.longitude!)),
          
        // );
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: 'google_map_api_key',
          request: PolylineRequest(
            origin: PointLatLng(double.parse(deliveryMan.lat ?? '0'),
                double.parse(deliveryMan.lng ?? '0')),
            destination: PointLatLng(double.parse(addressModel.latitude!),
                double.parse(addressModel.longitude!)),
            mode: TravelMode.driving,
            wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
          ),
        );

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.red,
            width: 5,
            patterns: [PatternItem.dash(30), PatternItem.gap(10)],
          ));
        });
      }
    } catch (e) {
      log("Error setting marker: $e");
    }
    setState(() {});
  }

  // List<LatLng> _createRoutePoints(
  //     DeliveryMan deliveryMan, AddressModel addressModel) {
  //   List<LatLng> points = [];
  //   // Add intermediate points to simulate a curved route
  //   LatLng startPoint = LatLng(double.parse(deliveryMan.lat ?? '0'),
  //       double.parse(deliveryMan.lng ?? '0'));
  //   LatLng endPoint = LatLng(double.parse(addressModel.latitude!),
  //       double.parse(addressModel.longitude!));

  //   LatLng midPoint1 = LatLng(
  //     (startPoint.latitude + endPoint.latitude) / 2,
  //     (startPoint.longitude + endPoint.longitude) / 2 + 0.01,
  //   );
  //   LatLng midPoint2 = LatLng(
  //     (startPoint.latitude + endPoint.latitude) / 2,
  //     (startPoint.longitude + endPoint.longitude) / 2 - 0.01,
  //   );

  //   points.add(startPoint);
  //   points.add(midPoint1);
  //   points.add(midPoint2);
  //   points.add(endPoint);

  //   return points;
  // }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds,
      LatLng centerBounds,
      {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if (fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
