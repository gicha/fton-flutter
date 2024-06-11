import 'package:darttonconnect/models/wallet_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TonConnectBottomSheet extends StatelessWidget {
  const TonConnectBottomSheet(this.wallets, {super.key});

  final List<WalletApp> wallets;

  static Future<WalletApp?> show(
    BuildContext context, {
    required List<WalletApp> wallets,
  }) async =>
      showModalBottomSheet<WalletApp>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => TonConnectBottomSheet(wallets),
      );

  @override
  Widget build(BuildContext context) {
    final telegramWalletIndex =
        wallets.indexWhere((element) => element.name == 'Wallet');
    final telegramWallet =
        telegramWalletIndex != -1 ? wallets[telegramWalletIndex] : null;
    final otherWallets =
        wallets.where((element) => element != telegramWallet).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Connect your wallet',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Open Wallet in Telegram or select your wallet to connect',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        if (telegramWallet != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CupertinoButton(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  'Open Wallet in Telegram',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(telegramWallet),
            ),
          ),
          const SizedBox(height: 20),
        ],
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              otherWallets.length,
              (index) {
                final wallet = otherWallets[index];
                return CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  onPressed: () => Navigator.of(context).pop(wallet),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(wallet.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wallet.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
