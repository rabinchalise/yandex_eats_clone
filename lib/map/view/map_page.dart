import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location_repository/location_repository.dart';

import 'package:user_repository/user_repository.dart';

import 'package:yandex_eats_clone/map/map.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(
        userRepository: context.read<UserRepository>(),
        locationRepository: context.read<LocationRepository>(),
      ),
      child: const GoogleMapView(),
    );
  }
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      safeArea: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.isIOS
            ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
            : SystemUiOverlayTheme.androidTransparentDarkSystemBarTheme,
        child: const Stack(
          children: [
            MapView(),
            GoogleMapAddressView(),
            GoogleMapBackButton(),
            GoogleMapSaveLocationButton(),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final isCameraMoving = state.isCameraMoving;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isCameraMoving ? 0 : 1,
            child: FloatingActionButton(
              onPressed: () => context
                  .read<MapBloc>()
                  .add(MapAnimateToCurrentPositionRequested()),
              elevation: 3,
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: const AppIcon(
                icon: LucideIcons.circleDot,
                color: AppColors.black,
              ),
            ).ignorePointer(isMoving: isCameraMoving),
          );
        },
      ),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapBloc _mapBloc;
  bool _isBlocClosed = false;

  @override
  void initState() {
    super.initState();
    _mapBloc = context.read<MapBloc>();
  }

  @override
  void dispose() {
    _isBlocClosed = true; // Mark the bloc as closed before disposing the widget
    _mapBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapType = context.select((MapBloc bloc) => bloc.state.mapType);
    final initialCameraPosition =
        context.select((MapBloc bloc) => bloc.state.initialCameraPosition);
    final isCameraMoving =
        context.select((MapBloc bloc) => bloc.state.isCameraMoving);
    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) =>
                _mapBloc.add(MapCreateRequested(controller: controller)),
            mapType: mapType,
            initialCameraPosition: initialCameraPosition,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            indoorViewEnabled: !isCameraMoving,
            padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
            zoomControlsEnabled: !isCameraMoving,
            onCameraMoveStarted: () {
              _mapBloc.add(const MapCameraMoveStartRequested());
            },
            onCameraIdle: () {
              _mapBloc.add(const MapCameraIdleRequested());
            },
            onCameraMove: (CameraPosition position) {
              // Prevent adding events if the bloc is closed
              if (_isBlocClosed) return;

              _mapBloc.add(MapCameraMoveRequested(position: position));
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, right: AppSpacing.md),
              child: Assets.icons.pinIcon.svg(height: 50, width: 50),
            ).ignorePointer(isMoving: true),
          ),
        ],
      ),
    );
  }
}

extension IgnorePointerX on Widget {
  Widget ignorePointer({bool isMoving = false, bool isMarker = false}) =>
      IgnorePointer(
        ignoring: isMarker || isMoving,
        child: this,
      );
}
