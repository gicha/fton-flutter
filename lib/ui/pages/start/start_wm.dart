import 'dart:async';

import 'package:darttonconnect/logger.dart';
import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/contract/contract_controller.dart';
import 'package:fton/model/contract/contract_controller_impl.dart';
import 'package:fton/ui/pages/start/start_page.dart';

mixin StartPageWm on State<StartPage> {
  late ContractController _contractController;
  late final _messenger = ScaffoldMessenger.of(context);

  bool isLoading = false;

  WalletInfo? wallet;
  final mnemonicController = TextEditingController(text: 'testPublicKey');
  final healthDataController = TextEditingController();
  bool contractInited = false;
  bool newDataValid = false;
  final healthDataRecords = <String>[];

  void onWalletConnected(WalletInfo wallet) {
    setState(() => this.wallet = wallet);
    _contractController = ContractControllerImpl(wallet.account!.address);
    initContract();
  }

  void onWalletDisconnected() {
    setState(() => wallet = null);
  }

  Future<void> initContract() async {
    if (contractInited) return;
    setState(() => isLoading = true);
    try {
      final publicKey = mnemonicController.text.trim();
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

  void onHealthDataChanged(String? value) {
    setState(() {
      newDataValid = value?.trim().isNotEmpty ?? false;
    });
  }

  Future<void> addHealthData() async {
    setState(() => isLoading = true);
    try {
      final data = healthDataController.text.trim();
      final encryptedData = data; // add encryption
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
        final encryptedData = await _contractController.getHealthDataValue(i);
        final data = encryptedData; // add decryption
        setState(() => healthDataRecords.add(data));
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
