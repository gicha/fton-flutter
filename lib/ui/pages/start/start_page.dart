import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:flutter/material.dart';
import 'package:fton/ui/pages/start/start_wm.dart';
import 'package:fton/ui/widgets/ton_connect_button/ton_connect_button.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with StartPageWm {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          IgnorePointer(
            ignoring: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('FTON'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TonConnectButton(
                    onWalletConnected: onWalletConnected,
                    onWalletDisconnected: onWalletDisconnected,
                  ),
                  if (wallet != null) ...[
                    const SizedBox(height: 16),
                    ListTile(
                      title:
                          Text('Connected wallet: ${wallet!.account?.address}'),
                      subtitle: Text(
                        'Chain: ${wallet!.account?.chain == CHAIN.mainnet ? 'Mainnet' : 'Testnet'}',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: mnemonicController,
                            enabled: !contractInited,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Public key',
                            ),
                          ),
                        ),
                        if (contractInited)
                          ElevatedButton(
                            onPressed: disconnect,
                            child: const Text('Change key'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!contractInited)
                      ElevatedButton(
                        onPressed: initContract,
                        child: const Text('Init contract'),
                      )
                    else ...[
                      TextField(
                        controller: healthDataController,
                        onChanged: onHealthDataChanged,
                        decoration: const InputDecoration(
                          labelText: 'Health data',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: newDataValid ? addHealthData : null,
                        child: const Text('Add health data'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadHealthRecords,
                        child: const Text('Load health records'),
                      ),
                      const SizedBox(height: 16),
                      for (final record in healthDataRecords.reversed)
                        ListTile(title: Text(record)),
                    ],
                  ],
                ],
              ),
            ),
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
}
