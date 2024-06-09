mixin WaitForActionMixin {
  Future<void> waitForAction(
    Future<bool> Function() checkCondition, {
    int attempts = 50,
    Duration sleepDuration = const Duration(milliseconds: 500),
  }) async {
    if (attempts <= 0) {
      throw 'Attempt number must be positive';
    }
    for (int i = 0; i < attempts; i++) {
      final isDone = await checkCondition();
      if (isDone) return;
      await Future.delayed(sleepDuration);
    }
    throw "Contract was not deployed. Check your wallet's transactions";
  }
}
