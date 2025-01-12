/// Configs for api serfice, which is used to configure API service settings.
class ServiceConfig {
  /// Sets the time limit for receiving data from the API.
  final Duration receiveTimeout;

  /// Sets the time limit for establishing a connection to the API.
  final Duration connectTimeout;

  /// Enables or disables logging for the API service
  final bool enableLog;

  const ServiceConfig(
      {this.receiveTimeout = const Duration(seconds: 60),
      this.connectTimeout = const Duration(seconds: 60),
      this.enableLog = false});
}
