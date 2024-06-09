import 'dart:typed_data';

import 'package:fton/model/contract/contract_controller.dart';
import 'package:fton/model/contract/contracts/account.dart';
import 'package:fton/model/contract/contracts/health_data.dart';
import 'package:fton/model/contract/helpers/wait_for_action_mixin.dart';
import 'package:logger/logger.dart';
import 'package:tonutils/tonutils.dart';

class ContractControllerImpl extends ContractController
    with WaitForActionMixin {
  ContractControllerImpl(super.contractOwnerAddress);

  final client = TonJsonRpc(
    'https://testnet.toncenter.com/api/v2/jsonRPC',
    'bfdde2d576e0ba956a83773736d1b1c63d2f8f71257340dc9637bd11e77e39f8',
  );

  AccountContract? contract;

  final logger = Logger();

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

  WalletContractV3R2 get wallet => client.open(
        WalletContractV3R2(keyPair.publicKey),
      );

  @override
  Future<void> initContract(String publicKey) async {
    logger.d('Init contract');
    final seqno = await wallet.getSeqno();
    final contract =
        this.contract = client.open(AccountContract(contractOwnerAddress));
    final isDeployed = await client.isContractDeployed(contract.address);
    if (isDeployed) {
      logger.d('Contract is already deployed');
      final storedPublicKey = await getPublicKey();
      if (storedPublicKey != publicKey) {
        logger.d('Public key is different. Set new public key');
        return setPublicKey(publicKey);
      }
    }
    await wallet.sendTransfer(
      seqno: seqno,
      privateKey: keyPair.privateKey,
      messages: [
        internal(
          to: SiaInternalAddress(contract.address),
          value: SbiBigInt(BigInt.from(4000000)),
          body: ScCell(contract.deployCell),
          init: ContractMaybeInit(
            code: contract.init?.code,
            data: contract.init?.data,
          ),
        ),
        internal(
          to: SiaInternalAddress(contract.address),
          value: SbiBigInt(BigInt.from(4000000)),
          body: ScCell(contract.getPublicKeyCell(publicKey)),
        ),
      ],
    );
    logger.d('Wait for contract deployment');
    await waitForAction(() => client.isContractDeployed(contract.address));
    logger.d('Wait for public key');
    await waitForAction(
      () => getPublicKey().then((value) => value == publicKey),
    );
    logger.d('Contract is initialized');
  }

  String parseStringFromTupleReader(TupleReader reader) {
    final chars = reader
        .readString()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(', ')
        .map(int.parse)
        .toList();
    return String.fromCharCodes(chars);
  }

  @override
  Future<String> getPublicKey() async {
    if (contract == null) throw 'Contract is not initialized';
    final res = await client.runMethod(contract!.address, 'publicKey');
    return parseStringFromTupleReader(res.stack);
  }

  Future<void> setPublicKey(String publicKey) async {
    if (contract == null) throw 'Contract is not initialized';
    final seqno = await wallet.getSeqno();
    await wallet.sendTransfer(
      seqno: seqno,
      privateKey: keyPair.privateKey,
      messages: [
        internal(
          to: SiaInternalAddress(contract!.address),
          value: SbiBigInt(BigInt.from(4000000)),
          body: ScCell(contract!.getPublicKeyCell(publicKey)),
        ),
      ],
    );
    await waitForAction(() async {
      final storedPublicKey = await getPublicKey();
      logger.d('Stored public key: $storedPublicKey');
      logger.d('Expected public key: $publicKey');
      return storedPublicKey == publicKey;
    });
  }

  @override
  Future<int> getRecordsCount() async {
    if (contract == null) throw 'Contract is not initialized';
    final res = await client.runMethod(
      contract!.address,
      'numHealthDataRecords',
    );
    return res.stack.readBigInt().toInt();
  }

  Future<InternalAddress> getHealthDataAddress(int seqno) async {
    if (contract == null) throw 'Contract is not initialized';
    final healthDataContract = client.open(
      HealthDataContract(
        contract!.address,
        BigInt.from(seqno),
        wallet.address,
      ),
    );
    return healthDataContract.address;
  }

  @override
  Future<String> getHealthDataValue(int seqno) async {
    if (contract == null) throw 'Contract is not initialized';
    final healthDataContractAddress = await getHealthDataAddress(seqno);
    final res = await client.runMethod(
      healthDataContractAddress,
      'encryptedData',
    );
    return parseStringFromTupleReader(res.stack);
  }

  @override
  Future<void> addHealthData(String encryptedData) async {
    final contract = this.contract;
    if (contract == null) throw 'Contract is not initialized';
    final seqno = await wallet.getSeqno();
    final recordsCount = await getRecordsCount();
    logger.d('Records count: $recordsCount');
    logger.d('Add health data record');
    await wallet.sendTransfer(
      seqno: seqno,
      privateKey: keyPair.privateKey,
      messages: [
        internal(
          to: SiaInternalAddress(contract.address),
          value: SbiBigInt(BigInt.from(20000000)),
          body: ScCell(
            contract.getAddHealthDataCell(
              wallet.address,
              encryptedData,
            ),
          ),
        ),
      ],
    );
    final lastRecordSeqno = recordsCount + 1;
    logger.d('Wait for main contract action');
    await waitForAction(
      () => getRecordsCount().then((value) {
        logger.d('Expected count: $lastRecordSeqno');
        logger.d('Records count: $value');
        return value == lastRecordSeqno;
      }),
    );
    logger.d('Fetch record contract address');
    final recordContractAddress = await getHealthDataAddress(lastRecordSeqno);
    logger.d('Wait for record contract deployment');
    await waitForAction(() => client.isContractDeployed(recordContractAddress));
    logger.d('Health data record is added');
  }
}
