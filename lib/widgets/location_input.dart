import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trek_place/helpers/location_helper.dart';
import 'package:trek_place/models/place.dart';
import 'package:trek_place/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _imagePreviewUrl;

  void _generateLocationPreviewImage(double lat, double lon) {
    final staticMapImageUrl = LocationHelper.getLocationPreviewImage(latitude: lat, longitude: lon);
    setState(() {
      _imagePreviewUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _generateLocationPreviewImage(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (e) {
      print(e);
      return;
    }

  }
  
  Future<void> _selectOnMap() async {
    try {
      final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
              builder: (ctx) => MapScreen(
                    isSelecting: true,
                initialLocation: PlaceLocation(latitude: 28.61613,longitude: 77.23001),
                  )
            )
          );
      if(selectedLocation == null) {
            return;
          }
      _generateLocationPreviewImage(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    } catch (e) {
      print(e);
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          width: double.infinity,
          height: 170,
          alignment: Alignment.center,
          child: _imagePreviewUrl == null
            ? Text('No Preview Available', textAlign: TextAlign.center,) :
          Image.network(_imagePreviewUrl, fit: BoxFit.cover, width: double.infinity,),
        ),
        Row(
          children: <Widget>[
            TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Location'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor
                )
              ),
            ),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.location_on),
                label: Text('Select on Map'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
