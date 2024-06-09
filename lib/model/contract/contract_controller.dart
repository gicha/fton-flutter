import 'dart:typed_data';

import 'package:fton/model/contract/contracts/account.dart';
import 'package:tonutils/tonutils.dart';

class ContractController {
  final _client = TonJsonRpc(
    'https://testnet.toncenter.com/api/v2/jsonRPC',
    'bfdde2d576e0ba956a83773736d1b1c63d2f8f71257340dc9637bd11e77e39f8',
  );

  KeyPair get keyPair => KeyPair.fromPrivateKey(
        Uint8List.fromList(
          [
            105,
            147,
            146,
            161,
            160,
            231,
            96,
            115,
            125,
            167,
            52,
            37,
            47,
            135,
            73,
            33,
            236,
            82,
            237,
            113,
            130,
            51,
            247,
            187,
            211,
            247,
            53,
            77,
            6,
            134,
            62,
            120,
            246,
            238,
            124,
            198,
            46,
            118,
            51,
            14,
            138,
            140,
            95,
            151,
            199,
            190,
            142,
            250,
            69,
            87,
            123,
            241,
            118,
            110,
            15,
            14,
            168,
            158,
            131,
            137,
            180,
            171,
            247,
            183,
          ],
        ),
      );

  WalletContractV3R2 get wallet => _client.open(
        WalletContractV3R2(keyPair.publicKey),
      );

  Future<void> createAccount(String userAddress, String publicKey) async {
    final seqno = await wallet.getSeqno();
    final account = _client.open(AccountContract(userAddress));
    await wallet.sendTransfer(
      seqno: seqno,
      privateKey: keyPair.privateKey,
      messages: [
        internal(
          to: SiaInternalAddress(account.address),
          value: SbiString('0.004'),
          body: ScCell(account.deployCell),
          init: account.initMaybe,
        ),
      ],
    );
  }
}
