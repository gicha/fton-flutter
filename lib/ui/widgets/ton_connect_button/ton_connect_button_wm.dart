import 'dart:async';
import 'dart:convert';

import 'package:darttonconnect/exceptions.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:fton/model/ton_connect/ton_connect_storage.dart';
import 'package:fton/ui/widgets/ton_connect_button/ton_connect_button.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

enum TonConnectStatus {
  loadingWallets('Loading...'),
  readyToConnect('Connect'),
  connecting('Connecting'),
  connected('Disconnect');

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
    wallets = await getWallets();
    setState(() {
      status = TonConnectStatus.readyToConnect;
    });
  }

  Future<List<WalletApp>> getWallets() async {
    final List<WalletApp> walletsList = [];
    try {
      final response = await http.get(
        Uri.parse(
          'https://raw.githubusercontent.com/ton-blockchain/wallets-list/main/wallets.json',
        ),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List) {
          for (final walletJson in responseBody) {
            final wallet = fromMap(walletJson as Map<String, dynamic>);
            if (wallet.bridgeUrl.isNotEmpty) {
              walletsList.add(wallet);
            }
          }
        } else {
          throw FetchWalletsError(
            'Wrong wallets list format, wallets list must be an array.',
          );
        }
      } else {
        throw FetchWalletsError('Failed to fetch wallets list.');
      }
    } catch (_) {}
    return walletsList;
  }

  WalletApp fromMap(Map<String, dynamic> json) {
    final String bridgeUrl = () {
      if (json.containsKey('bridge_url')) {
        return json['bridge_url'].toString();
      }
      if (json.containsKey('bridge')) {
        final bridges = (json['bridge'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>);
        final bridge = bridges.firstWhere(
          (bridge) => bridge['type'] == 'sse',
          orElse: () => {'url': ''},
        );
        return bridge['url'].toString();
      }
      return '';
    }();

    return WalletApp(
      name: json['name'].toString(),
      image: json['image'].toString(),
      bridgeUrl: bridgeUrl,
      aboutUrl: json['about_url'].toString(),
      universalUrl: json.containsKey('universal_url')
          ? json['universal_url'].toString()
          : null,
    );
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

  Future<WalletApp?> selectWallet() async {
    final wallets = this.wallets!;
    return showDialog<WalletApp>(
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
  }

  Future<void> connect() async {
    final selectedWallet = await selectWallet();
    if (selectedWallet == null) return;
    final url = await connector.connect(selectedWallet);
    if (TelegramWebApp.instance.isSupported) {
      await TelegramWebApp.instance.openLink(url, tryInstantView: false);
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
