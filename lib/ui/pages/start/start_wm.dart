import 'dart:async';

import 'package:darttonconnect/logger.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/contract/contract_controller.dart';
import 'package:fton/model/contract/contract_controller_impl.dart';
import 'package:fton/ui/pages/start/start_page.dart';

mixin StartPageWm on State<StartPage> {
  final ContractController _contractController =
      ContractControllerImpl('test214003oee');
  late final _messenger = ScaffoldMessenger.of(context);

  bool isLoading = false;

  final publicKeyController = TextEditingController(text: 'testPublicKey');
  final healthDataController = TextEditingController();
  bool contractInited = false;
  bool publicKeyValid = false;
  bool newDataValid = false;
  final healthDataRecords = <String>[];

  @override
  void initState() {
    initContract().then((_) => loadHealthRecords());
    super.initState();
  }

  Future<void> initContract() async {
    if (contractInited) return;
    setState(() => isLoading = true);
    try {
      final publicKey = publicKeyController.text.trim();
      await _contractController.initContract(publicKey);
      contractInited = true;
      unawaited(loadHealthRecords());
    } catch (e) {
      logger.e('Failed to init contract: $e');
      _messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to init contract: $e'),
        ),
      );
    }
    setState(() => isLoading = false);
  }

  void disconnect() {
    setState(() => contractInited = false);
  }

  void onPublicKeyChanged(String? value) {
    setState(() {
      publicKeyValid = value?.trim().isNotEmpty ?? false;
    });
  }

  void onHealthDataChanged(String? value) {
    setState(() {
      newDataValid = value?.trim().isNotEmpty ?? false;
    });
  }

  Future<void> addHealthData() async {
    setState(() => isLoading = true);
    try {
      final encryptedData = healthDataController.text.trim();
      await _contractController.addHealthData(encryptedData);
      healthDataRecords.add(encryptedData);
      await loadHealthRecords();
      healthDataController.clear();
    } catch (e) {
      setState(() => isLoading = false);
      logger.e('Failed to add health data: $e');
      _messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to add health data: $e'),
        ),
      );
    }
  }

  Future<void> loadHealthRecords() async {
    setState(() => isLoading = true);
    try {
      healthDataRecords.clear();
      final recordsCount = await _contractController.getRecordsCount();
      for (int i = 1; i <= recordsCount; i++) {
        final record = await _contractController.getHealthDataValue(i);
        setState(() {
          healthDataRecords.add(record);
        });
      }
    } catch (e) {
      logger.e('Failed to load health records: $e');
      _messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to load health records: $e'),
        ),
      );
    }
    setState(() => isLoading = false);
  }
}
