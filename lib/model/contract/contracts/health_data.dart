import 'package:tonutils/tonutils.dart';

/// IMPORTANT: Initialize the [provider] to use
class HealthDataContract implements Contract {
  HealthDataContract(this.parent, this.seqno, this.accessedAddress) {
    final code = Cell.fromBocBase64(
      'te6ccgECFgEAAqYAART/APSkE/S88sgLAQIBYgIDA3rQAdDTAwFxsKMB+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiFRQUwNvBPhhAvhi2zxVE9s88uCCEgQFAgFYBgcAnAGSMH/gcCHXScIflTAg1wsf3oIQ2lwGX7qOMNMfAYIQ2lwGX7ry4IHUAdAxggDUhPhCUmDHBfL0ggDxVosIUAMB+QEB+QG6EvL0f+AwcACsyPhDAcx/AcoAVTBQQyDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IjPFsv/WCDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IjPFshYzxbJAczJ7VQCASAICQIBIA4PAhG22Btnm2eNiDASCgIBIAsMAAj4J28QAhGwx3bPNs8bEGASDQC5svRgnBc7D1dLK57HoTsOdZKhRtmgnCd1jUtK2R8syLTry398WI5gnAgVcAbgGdjlM5YOq5HJbLDgnAb1J3vlUWW8cdT094FWcMmgnCdl05as07LczoOlm2UZuikgAAIgAgEgEBECEbT8W2ebZ42IMBITABGwr7tRNDSAAGAAdbJu40NWlwZnM6Ly9RbVJxMkExSlFiM1BHUFdzTExnRXltYjEyVVZqR1NMZXdrTDZGaWlwNjNTNHh5ggAcTtRNDUAfhj0gABjkr6QAEg10mBAQu68uCIINcLCiCBBP+68tCJgwm68uCIAdP/+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiAHUAdAUQzBsFOD4KNcLCoMJuvLgiRQAAiEBlvpAASDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IgBgQEB1wD6QAEg10mBAQu68uCIINcLCiCBBP+68tCJgwm68uCIQzAD0VjbPBUABIsI',
    );
    final dataCell = Cell.fromBocBase64(
      'te6cckECGAEAArAAAQHAAQEFocGJAgEU/wD0pBP0vPLICwMCAWIEBwN60AHQ0wMBcbCjAfpAASDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IhUUFMDbwT4YQL4Yts8VRPbPPLgghQFBgCcAZIwf+BwIddJwh+VMCDXCx/eghDaXAZfuo4w0x8BghDaXAZfuvLggdQB0DGCANSE+EJSYMcF8vSCAPFWiwhQAwH5AQH5AboS8vR/4DBwAKzI+EMBzH8BygBVMFBDINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiM8Wy/9YINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiM8WyFjPFskBzMntVAIBWAgPAgEgCQsCEbbYG2ebZ42IMBQKAAj4J28QAgEgDA4CEbDHds82zxsQYBQNAAIgALmy9GCcFzsPV0srnsehOw51kqFG2aCcJ3WNS0rZHyzItOvLf3xYjmCcCBVwBuAZ2OUzlg6rkclssOCcBvUne+VRZbxx1PT3gVZwyaCcJ2XTlqzTstzOg6WbZRm6KSACASAQEwIBIBESABGwr7tRNDSAAGAAdbJu40NWlwZnM6Ly9RbVJxMkExSlFiM1BHUFdzTExnRXltYjEyVVZqR1NMZXdrTDZGaWlwNjNTNHh5ggAhG0/Ftnm2eNiDAUFwHE7UTQ1AH4Y9IAAY5K+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiAHT//pAASDXSYEBC7ry4Igg1wsKIIEE/7ry0ImDCbry4IgB1AHQFEMwbBTg+CjXCwqDCbry4IkVAZb6QAEg10mBAQu68uCIINcLCiCBBP+68tCJgwm68uCIAYEBAdcA+kABINdJgQELuvLgiCDXCwoggQT/uvLQiYMJuvLgiEMwA9FY2zwWAASLCAACIV3F2gI=',
    );

    final data = beginCell()
        .storeRef(dataCell)
        .storeUint(BigInt.zero, 1)
        .storeAddress(parent)
        .storeInt(seqno, 257)
        .storeAddress(accessedAddress)
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

  final Address parent;
  final BigInt seqno;
  final Address accessedAddress;
}
