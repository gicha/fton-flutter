import 'package:flutter/material.dart';
import 'package:fton/ui/pages/ton_connect/ton_connect_wm.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TonConnectView extends StatefulWidget {
  const TonConnectView({super.key});

  @override
  State<TonConnectView> createState() => _TonConnectViewState();
}

class _TonConnectViewState extends State<TonConnectView> with TonConnectViewWm {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (connected)
                  ElevatedButton(
                    onPressed: disconnect,
                    child: const Text('Disconnect'),
                  )
                else
                  ElevatedButton(
                    onPressed: initialConnect,
                    child: const Text('Create initial connect'),
                  ),
                const SizedBox(height: 15),
                if (universalLink != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .5,
                    ),
                    child: PrettyQrView.data(
                      data: universalLink!,
                      decoration: const PrettyQrDecoration(
                        background: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
