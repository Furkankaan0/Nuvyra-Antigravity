import Foundation

/// Privacy-first analytics servisi.
/// Sağlık verisini reklam/marketing SDK'sına asla göndermez.
protocol AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent)
}

/// Geliştirme ortamı — console'a loglar
final class ConsoleAnalyticsService: AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent) {
        #if DEBUG
        print("📊 [Analytics] \(event.name) — \(event.parameters)")
        #endif
    }
}

/// Üretim analytics servisi — privacy-first provider'a gönderir
final class ProductionAnalyticsService: AnalyticsServiceProtocol {
    func track(_ event: AnalyticsEvent) {
        // TODO: Privacy-first analytics provider entegrasyonu
        // TelemetryDeck, Aptabase, veya custom backend
    }
}
