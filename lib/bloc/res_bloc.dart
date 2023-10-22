import 'dart:async';

import 'res_event.dart';
import 'res_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class ResBloc {
  final _stateController = StreamController<ResState>();
  Stream<ResState> get state => _stateController.stream;

  final _eventController = StreamController<ResEvent>();
  Sink<ResEvent> get eventSink => _eventController.sink;

  ResBloc() {
    _eventController.stream.listen((event) async {
      if (event is FetchPhotosEvent) {
        _stateController.add(ResLoadingState());

        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body);
          final photos =
              jsonResponse.map((photo) => Photo.fromJson(photo)).toList();
          _stateController.add(ResLoadedState(photos));
        } else {
          _stateController.add(ResErrorState("Ошибка при загрузке данных"));
        }
      }
    });
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
