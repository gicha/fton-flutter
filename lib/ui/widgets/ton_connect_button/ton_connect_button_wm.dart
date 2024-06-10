import 'dart:async';

import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/ton_connect/ton_connect_storage.dart';
import 'package:fton/ui/widgets/ton_connect_button/ton_connect_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

enum TonConnectStatus {
  loadingWallets('Loading...'),
  readyToConnect('Connect'),
  connecting('Connecting'),
  connected('Disconnect'),
  ;

  const TonConnectStatus(this.title);

  final String title;
}

mixin TonConnectButtonWm on State<TonConnectButton> {
  final TonConnect connector = TonConnect(
    'https://fton.vercel.app/tonconnect-manifest.json',
    customStorage: TonConnectStorage(),
  );
  List<WalletApp>? wallets;
  TonConnectStatus status = TonConnectStatus.loadingWallets;

  @override
  void initState() {
    connector.onStatusChange(onWalletStatusChange);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!connector.connected) connector.restoreConnection();
        initialConnect();
      },
    );
    super.initState();
  }

  void onWalletStatusChange(_) {
    setState(() {});
    final wallet = connector.wallet;
    if (wallet != null) {
      status = TonConnectStatus.connected;
      widget.onWalletConnected?.call(wallet);
      Navigator.of(context).maybePop();
    }
  }

  Future<void> disconnect() async {
    if (connector.connected) {
      await connector.disconnect();
      widget.onWalletDisconnected?.call();
      await initialConnect();
    }
  }

  Future<void> initialConnect() async {
    wallets = await connector.getWallets();
    wallets!.add(
      const WalletApp(
        name: 'Wallet',
        image: 'https://wallet.tg/images/logo-288.png',
        aboutUrl: 'https://wallet.tg/',
        universalUrl: 'https://t.me/wallet?attach=wallet',
        bridgeUrl: 'https://bridge.ton.space/bridge',
      ),
    );
    setState(() {
      status = TonConnectStatus.readyToConnect;
    });
  }

  void onButtonTap() {
    switch (status) {
      case TonConnectStatus.loadingWallets:
      case TonConnectStatus.connecting:
        return;
      case TonConnectStatus.readyToConnect:
        connect();
        break;
      case TonConnectStatus.connected:
        disconnect();
        break;
    }
  }

  Future<void> connect() async {
    final wallets = this.wallets!;
    final selectedWallet = await showDialog<WalletApp>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => Center(
        child: Dialog(
          child: Material(
            color: Colors.transparent,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(wallet.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(wallet.name),
                  onTap: () => Navigator.of(context).pop(wallet),
                );
              },
            ),
          ),
        ),
      ),
    );
    if (selectedWallet == null) return;
    final url = await connector.connect(selectedWallet);
    if (TelegramWebApp.instance.isSupported) {
      await TelegramWebApp.instance.openLink(url);
    } else {
      await showAdaptiveDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Scan QR code to connect wallet'),
          content: SizedBox.square(
            dimension: MediaQuery.sizeOf(context).width * .7,
            child: QrImageView(
              data: url,
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
