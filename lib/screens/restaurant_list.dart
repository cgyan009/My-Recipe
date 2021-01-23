import 'package:flutter/material.dart';
import '../models/restautant_model.dart';

class RestaurantList extends StatelessWidget {
  final Future<List<Restaurant>> restaurants;

  const RestaurantList({Key key, this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searched Restaurants'),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: restaurants,
        initialData: null,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('waiting ...');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0 ? Colors.orange : Colors.amber,
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].url),
                    ),
                  );
                },
              );
          }
          return null; // unreachable
        },
      ),
    );
  }
}
