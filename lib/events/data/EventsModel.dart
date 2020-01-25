import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/constants/strings.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';

class EventsModel with ChangeNotifier {
  EventsDao _eventsDao;
  List<Events> events = [];
  bool isLoading = false;
  CustomHttpNetworkClient _networkClient;

  EventsModel({EventsDao eventsDao, CustomHttpNetworkClient networkClient})
      : this._eventsDao = eventsDao,
        this._networkClient = networkClient {
  fetchEvents();
  }

  Future<Null> fetchEvents() async {
    isLoading = true;
    notifyListeners();
    _networkClient.get('registrations/events', (json) async {
      var body = jsonDecode(json);
      _eventsDao.insertAllEvents(body);
      isLoading = false;
      getAllEvents();
      notifyListeners();
    });
  }

  Future<Null> getAllEvents() async {
    events = await _eventsDao.getAllEvents();
    print('events:$events');
    isLoading = false;
    notifyListeners();
  }
}
