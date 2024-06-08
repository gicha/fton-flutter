import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/ton_connect/ton_connect_storage.dart';
import 'package:fton/ui/pages/ton_connect/ton_connect_view.dart';

mixin TonConnectViewWm on State<TonConnectView> {
  final TonConnect connector = TonConnect(
    'https://fton.vercel.app/tonconnect-manifest.json',
    customStorage: TonConnectStorage(),
  );
  String? universalLink;
  bool get connected => connector.connected;

  @override
  void initState() {
    print('Connected: $connected');
    connector.onStatusChange((_) {
      print('Connected: $connected');
      print(connector.wallet);
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!connected) restoreConnection();
    });

    super.initState();
  }

  void restoreConnection() {
    connector.restoreConnection();
  }

  void disconnect() {
    if (connector.connected) {
      connector.disconnect();
    }
  }

  void updateQRCode(String newData) {
    setState(() => universalLink = newData);
  }

  /// Create connection and generate QR code to connect a wallet.
  Future<void> initialConnect() async {
    WalletApp? wallet;
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

    final link = await connector.connect(wallet);
    updateQRCode(universalLink = link);
  }
}
