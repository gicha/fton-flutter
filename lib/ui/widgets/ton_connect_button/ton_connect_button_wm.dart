import 'dart:async';

import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/ton_connect/ton_connect_storage.dart';
import 'package:fton/ui/widgets/ton_connect_button/ton_connect_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

mixin TonConnectButtonWm on State<TonConnectButton> {
  final TonConnect connector = TonConnect(
    'https://fton.vercel.app/tonconnect-manifest.json',
    customStorage: TonConnectStorage(),
  );
  WalletApp? wallet;
  String? universalLink;
  bool get connected => connector.connected;

  @override
  void initState() {
    connector.onStatusChange(
      (_) {
        setState(() {});
        final wallet = connector.wallet;
        if (wallet != null) {
          widget.onWalletConnected?.call(wallet);
          Navigator.of(context).maybePop();
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!connected) restoreConnection();
        initialConnect();
      },
    );
    super.initState();
  }

  void restoreConnection() {
    connector.restoreConnection();
  }

  Future<void> disconnect() async {
    if (connector.connected) {
      await connector.disconnect();
      await initialConnect();
    }
  }

  Future<void> initialConnect() async {
    final wallets = await connector.getWallets();
    if (wallets.isNotEmpty) {
      wallet = wallets.first;
    } else {
      wallet = const WalletApp(
        name: 'TonKeeper',
        bridgeUrl: 'https://bridge.tonapi.io/bridge',
        image:
            'https://play.google.com/store/apps/details?id=com.ton_keeper&hl=en_US',
        aboutUrl: 'https://tonkeeper.com/',
        universalUrl: 'https://app.tonkeeper.com/ton-connect',
      );
    }
    universalLink = await connector.connect(wallet!);
    setState(() {});
  }

  void onButtonTap() {
    if (connected) {
      disconnect();
      widget.onWalletDisconnected?.call();
    } else {
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Scan QR code to connect wallet'),
          content: SizedBox.square(
            dimension: MediaQuery.sizeOf(context).width * .7,
            child: QrImageView(
              data: universalLink!,
              size: MediaQuery.sizeOf(context).width * .7,
              backgroundColor: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
