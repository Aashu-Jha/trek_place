import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_place/models/great_places.dart';
import 'package:trek_place/screens/add_place_screen.dart';
import 'package:trek_place/screens/places_detail_screen.dart';
import 'package:trek_place/screens/places_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName : (context) => AddPlaceScreen(),
          PlaceDetailScreen.routeName : (context) => PlaceDetailScreen(),
        },
      ),
    );
  }
}