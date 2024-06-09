abstract class ContractController {
  ContractController(this.contractOwnerAddress);

  final String contractOwnerAddress;
  Future<void> initContract(String publicKey);
  Future<String> getPublicKey();
  Future<void> addHealthData(String encryptedData);
  Future<int> getRecordsCount();
  Future<String> getHealthDataValue(int seqno);
}
