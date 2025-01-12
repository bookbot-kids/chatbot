/// Configs for api serfice
class ServiceConfig {
  // Receive timeout
  final Duration receiveTimeout;

  // Connect timeout
  final Duration connectTimeout;

  // Enable log
  final bool enableLog;

  const ServiceConfig(
      {this.receiveTimeout = const Duration(seconds: 60),
      this.connectTimeout = const Duration(seconds: 60),
      this.enableLog = false});
}
