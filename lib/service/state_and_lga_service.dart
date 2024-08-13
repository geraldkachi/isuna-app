import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/lga_model.dart';
import 'package:misau/models/state_model.dart';
import 'package:misau/models/states_and_lga_model.dart';
import 'package:misau/service/network_service.dart';

class StateAndLgaService {
  final NetworkService _networkService = getIt<NetworkService>();

  List<StateModel>? _stateModel;

  List<StateModel>? get stateModel => _stateModel;

  List<StatesAndLgaModel>? _statesAndLgaModel;

  List<StatesAndLgaModel>? get statesAndLgaModel => _statesAndLgaModel;

  List<LgaModel>? _lgaModel;

  List<LgaModel>? get lgaModel => _lgaModel;

  Future<void> getStateAndLga() async {
    // Send the request to the backend
    try {
      final response = await _networkService.getAlt(
        'https://nigeria-states-towns-lgas.onrender.com/api/all',
      );
      final responsePayload = response;
      debugPrint('response: $responsePayload');
      var decodedResponse = json.decode(responsePayload);
      _statesAndLgaModel = decodedResponse
          .map((value) => StatesAndLgaModel.fromJson(value))
          .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getStates() async {
    // Send the request to the backend
    try {
      final response = await _networkService
          .getAlt('https://nigeria-states-towns-lgas.onrender.com/api/states');
      final responsePayload = response;
      debugPrint('response: ${json.encode(responsePayload)}');
      List decodedResponse = responsePayload;
      _stateModel =
          decodedResponse.map((value) => StateModel.fromJson(value)).toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getLga(String state) async {
    // Send the request to the backend
    try {
      final response = await _networkService.getAlt(
        'https://nigeria-states-towns-lgas.onrender.com/api/$state/lgas',
      );
      final responsePayload = response;
      debugPrint('response: ${json.encode(responsePayload)}');
      List decodedResponse = responsePayload;
      _lgaModel =
          decodedResponse.map((value) => LgaModel.fromJson(value)).toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
