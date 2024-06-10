import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:flutter/material.dart';
import 'package:fton/ui/widgets/ton_connect_button/ton_connect_button_wm.dart';

class TonConnectButton extends StatefulWidget {
  const TonConnectButton({
    this.onWalletConnected,
    this.onWalletDisconnected,
    super.key,
  });

  final void Function(WalletInfo wallet)? onWalletConnected;
  final VoidCallback? onWalletDisconnected;

  @override
  State<TonConnectButton> createState() => _TonConnectButtonState();
}

class _TonConnectButtonState extends State<TonConnectButton>
    with TonConnectButtonWm {
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: universalLink == null ? null : onButtonTap,
        child: Text(
          universalLink == null
              ? 'Connecting'
              : connected
                  ? 'Disconnect'
                  : 'Connect',
          style: TextStyle(
            color: connected ? Colors.red : Colors.green,
          ),
        ),
      );
}
