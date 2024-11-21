
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gasoilt/api/map.dart';
import 'package:gasoilt/screens/main-section/gas-station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
  int? showIndex;
  List<MapObject> mapObjects = [];
  int objectsLen = 0;

  Future<void> getData() async {
    List data = (await mapList())['AzsList'];
    objectsLen = data.length;
    //добавляем маркеры на карту
    for (var azs in data) {
      mapObjects.add(PlacemarkMapObject(
        mapId: MapObjectId(azs['id'].toString()),
        point: Point(latitude: azs['lat'], longitude: azs['lon']),
        onTap: (_, __) async {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              return Future.error('Location permissions are denied');
            }
          }
          DraggableScrollableController controller =
              DraggableScrollableController();

          Widget buildBottomSheet(
            BuildContext context,
            ScrollController scrollController,
            double bottomSheetOffset,
          ) {
            return GasStation(
              controller: controller,
              text: azs['name'],
              addres: azs['addres'],
              lcontroller: scrollController,
              buildRoute: () async {
                Position pos = await Geolocator.getCurrentPosition();
                //построение маршрута прямо в приложении
                // _requestRoutes(
                //     Point(latitude: azs['lat'], longitude: azs['lon']),
                //     Point(latitude: pos.latitude, longitude: pos.longitude));
                //построение маршрута в яндекс картах
                launchUrl(
                    Uri.parse(
                        'https://yandex.ru/maps/?rtext=${pos.latitude},${pos.longitude}~${azs['lat']},${azs['lon']}&rtt=mt'),
                    mode: LaunchMode.externalApplication);
              },
            );
          }

          showFlexibleBottomSheet(
            context: context,
            minHeight: 0,
            initHeight: 0.22,
            maxHeight: 1,
            builder: buildBottomSheet,
            anchors: [0, 0.22, 1],
            isSafeArea: true,
            barrierColor: Colors.transparent,
            draggableScrollableController: controller,
          );
        },
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('images/location.png'),
            scale: 1)),
      ));
      setState(() {});
    }
  }



  

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .75,
            child: Stack(
              children: [
                YandexMap(
                  fastTapEnabled: true,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  mapObjects: mapObjects,

                  // focusRect: const ScreenRect(
                  //     topLeft: ScreenPoint(
                  //         x: 158.22731018066406, y: 660.2544555664062),
                  //     bottomRight: ScreenPoint(
                  //         x: 164.07867431640625, y: 726.9810791015625)),
                  onMapCreated: (controller) async {
                    final animation = const MapAnimation(
                        type: MapAnimationType.smooth, duration: .5);

                    await controller.moveCamera(
                        CameraUpdate.newCameraPosition(const CameraPosition(
                            target: Point(
                                latitude: 47.20153765412612,
                                longitude: 38.931525186505986))),
                        animation: animation);
                    await controller.moveCamera(CameraUpdate.zoomTo(10),
                        animation: animation);
                  },
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 70, right: 20),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         setState(() {
                //           mapObjects = mapObjects.sublist(0, objectsLen);
                //         });
                //       },
                //       child: Text("Очистить маршруты"),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
