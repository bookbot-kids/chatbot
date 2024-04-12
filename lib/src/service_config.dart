/// Configs for api serfice
class ServiceConfig {
  final Duration receiveTimeout;
  final Duration connectTimeout;
  final bool enableLog;

  const ServiceConfig(
      {this.receiveTimeout = const Duration(seconds: 60),
      this.connectTimeout = const Duration(seconds: 60),
      this.enableLog = false});
}
