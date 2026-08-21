/// Konfigurasi base URL API PipoSmart.
///
/// Cara pakai:
/// 1. Pilih [activeEnvironment] sesuai mode testing.
/// 2. Jika pakai ngrok: jalankan `ngrok http 8080`, lalu paste URL HTTPS-nya
///    ke [ngrokBaseUrl] (tanpa slash di akhir).
/// 3. Jika pakai HP di Wi-Fi yang sama: pastikan [lanBaseUrl] memakai IP PC kamu.
///
/// Contoh ngrok:
///   ngrok http 8080
///   → Forwarding  https://xxxx.ngrok-free.app → http://localhost:8080
class ApiConfig {
  ApiConfig._();

  /// Ganti nilai ini saat ganti mode testing.
  static const ApiEnvironment activeEnvironment = ApiEnvironment.ngrok;

  /// Port backend Gin (lihat `backend_app/.env` → PORT).
  static const int apiPort = 8080;

  /// Android Emulator → host machine.
  static const String emulatorBaseUrl = 'http://10.0.2.2:$apiPort';

  /// iOS Simulator → host machine.
  static const String iosSimulatorBaseUrl = 'http://127.0.0.1:$apiPort';

  /// HP fisik (Android/iOS) di Wi-Fi yang sama dengan PC.
  /// IP Wi-Fi PC saat ini: 192.168.1.135 — ubah jika IP berubah.
  static const String lanBaseUrl = ':$apiPort';

  /// URL publik dari ngrok (HTTPS). Ganti setelah `ngrok http 8080`.
  /// Contoh: 'https://abcd-12-34-56-78.ngrok-free.app'
  static const String ngrokBaseUrl = 'https://shingle-immodest-styling.ngrok-free.dev';

  /// Base URL aktif berdasarkan [activeEnvironment].
  static String get baseUrl {
    switch (activeEnvironment) {
      case ApiEnvironment.emulator:
        return emulatorBaseUrl;
      case ApiEnvironment.iosSimulator:
        return iosSimulatorBaseUrl;
      case ApiEnvironment.lan:
        return lanBaseUrl;
      case ApiEnvironment.ngrok:
        return ngrokBaseUrl;
    }
  }

  /// Timeout default untuk Dio.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Header tambahan (ngrok free sering butuh skip browser warning).
  static Map<String, String> get defaultHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (activeEnvironment == ApiEnvironment.ngrok) {
      headers['ngrok-skip-browser-warning'] = 'true';
    }

    return headers;
  }
}

enum ApiEnvironment {
  /// Android Emulator
  emulator,

  /// iOS Simulator
  iosSimulator,

  /// HP fisik lewat IP LAN (Wi-Fi sama)
  lan,

  /// HP / mana saja lewat tunnel ngrok
  ngrok,
}
