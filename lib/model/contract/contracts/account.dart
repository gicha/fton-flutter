import 'package:tonutils/tonutils.dart';

/// IMPORTANT: Initialize the [provider] to use
class AccountContract implements Contract {
  AccountContract(this.accountOwner) {
    final code = Cell.fromBocBase64(
      'te6ccgECJwEABVoAART/APSkE/S88sgLAQIBYgIDA3rQAdDTAwFxsKMB+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiFRQUwNvBPhhAvhi2zxVFNs88uCCIwQFAgEgDg8EtgGSMH/gcCHXScIflTAg1wsf3iCCEFrc9OC6jy0w0x8BghBa3PTguvLggdQB0DEzgRFN+EFvJBAjXwNSYMcF8vSI+EIBf23bPH/gIIIQEssZe7rjAoIQlGqYtroGCwcIAITI+EMBzH8BygBVQFBUINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiM8WyFADzxbJWMzIWM8WyQHMEsv/y//J7VQALAAAAABQdWJsaWMga2V5IHVwZGF0ZWQBbjDTHwGCEBLLGXu68uCB+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiAHUAdASbBLbPH8JAViOp9MfAYIQlGqYtrry4IHTPwExyAGCEK/5D1dYyx/LP8n4QgFwbds8f+AwcAsD5gOk+EP4KFQQIATbPFxwWchwAcsBcwHLAXABywASzMzJ+QDIcgHLAXABywASygfL/8nQINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiAXIAYIQ2lwGX1jLH8hYzxbJAczJEDWCCHoSAFpyWX8GRVXbPCEmDAoBKsgBghBqhxjKWMsfy//J+EIBf23bPAsBOm1tIm6zmVsgbvLQgG8iAZEy4hAkcAMEgEJQI9s8DAHKyHEBygFQBwHKAHABygJQBSDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IjPFlAD+gJwAcpoI26zkX+TJG6z4pczMwFwAcoA4w0hbrOcfwHKAAEgbvLQgAHMlTFwAcoA4skB+wANAJh/AcoAyHABygBwAcoAJG6znX8BygAEIG7y0IBQBMyWNANwAcoA4iRus51/AcoABCBu8tCAUATMljQDcAHKAOJwAcoAAn8BygACyVjMAgFqEBECASAUFQIRsUd2zzbPGxRgIxICEbB+Ns82zxsUYCMTAAIkAAIiAgEgFhcCASAcHQICdRgZAN23ejBOC52Hq6WVz2PQnYc6yVCjbNBOE7rGpaVsj5ZkWnXlv74sRzBOBAq4A3AM7HKZywdVyOS2WHBOA3qTvfKost446np7wKs4ZNBOE7Lpy1Zp2W5nQdLNsozdFJBOCBnOrTzivzpKFgOsLcTI9lACD6YBtnm2eNijIxoCD6WBtnm2eNijIxsAAiAACPgnbxACASAeHwIBICAhABGwr7tRNDSAAGAAdbJu40NWlwZnM6Ly9RbWQ1THNncmFtS3hyVFB4cWd3QVdSMnNIdjNSYmNQRDJ6VnlGZ1FNY1JuZTl5ggAhGxCjbPNs8bFGAjIgJNshjINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiNs8VRTbPGxRgIyQAAiEBnu1E0NQB+GPSAAGOMPpAASDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IgB1AHQAdQB0AHT/9P/VUBsFeD4KNcLCoMJuvLgidQB0AHR2zwlAZD4Q/goWts8cFnIcAHLAXMBywFwAcsAEszMyfkAyHIBywFwAcsAEsoHy//J0CDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IgmABCLCHAg+EJVMADoA9D0BDBtAYIA4MQBgBD0D2+h8uCHAYIA4MQiAoAQ9BfIAcj0AMkBzHABygBVIARaINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiM8WEoEBAc8AASDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IjPFsk=',
    );
    final dataCell = Cell.fromBocBase64(
      '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',
    );

    final data = beginCell()
        .storeRef(dataCell)
        .storeUint(BigInt.zero, 1)
        .storeStringRefTail(accountOwner)
        .endCell();
    init = ContractInit(code: code, data: data);
    address = contractAddress(0, StateInit(null, null, code, data));
  }
  @override
  ContractABI? abi;

  @override
  late InternalAddress address;

  @override
  ContractInit? init;

  /// don't forget to initialize to use  @override
  @override
  ContractProvider? provider;

  final String accountOwner;

  Cell get deployCell => beginCell()
      .storeUint(BigInt.from(2490013878), 32)
      .storeUint(BigInt.zero, 64)
      .endCell();

  Cell getPublicKeyCell(String publicKey) => beginCell()
      .storeUint(BigInt.from(1524430048), 32)
      .storeStringRefTail(publicKey)
      .endCell();

  Cell getAddHealthDataCell(Address accessedAddress, String encryptedData) =>
      beginCell()
          .storeUint(BigInt.from(315300219), 32)
          .storeAddress(accessedAddress)
          .storeStringRefTail(encryptedData)
          .endCell();
}
