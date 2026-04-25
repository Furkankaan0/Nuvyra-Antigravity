import Foundation

/// Abonelik katmanları
enum SubscriptionTier: String, Codable, CaseIterable, Identifiable {
    case free = "free"
    case premium = "premium"
    case premiumPlus = "premium_plus"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .free: "Ücretsiz"
        case .premium: "Premium"
        case .premiumPlus: "Premium Plus"
        }
    }
    
    var productIds: [String] {
        switch self {
        case .free: []
        case .premium: ["com.nuvyra.premium.monthly", "com.nuvyra.premium.yearly"]
        case .premiumPlus: ["com.nuvyra.plus.monthly", "com.nuvyra.plus.yearly"]
        }
    }
}

/// Entitlement durumu
struct EntitlementStatus: Codable {
    var tier: SubscriptionTier
    var isActive: Bool
    var expirationDate: Date?
    var isTrialActive: Bool
    var lastVerifiedAt: Date
    
    static let free = EntitlementStatus(tier: .free, isActive: true, expirationDate: nil, isTrialActive: false, lastVerifiedAt: Date())
    
    var isPremiumOrAbove: Bool { isActive && (tier == .premium || tier == .premiumPlus) }
    var isPremiumPlus: Bool { isActive && tier == .premiumPlus }
}

/// Paywall özellik satırı
struct PaywallFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let tier: SubscriptionTier
    
    static let premiumFeatures: [PaywallFeature] = [
        .init(icon: "camera.fill", title: "Sınırsız Fotoğraflı Kayıt", description: "Öğünlerini fotoğrafla hızlıca kaydet", tier: .premium),
        .init(icon: "chart.bar.fill", title: "Gelişmiş Kalori/Makro", description: "Protein, karbonhidrat ve yağ detayları", tier: .premium),
        .init(icon: "figure.walk", title: "Adaptif Yürüyüş Planı", description: "Sana özel yürüyüş hedefleri", tier: .premium),
        .init(icon: "doc.text.fill", title: "Haftalık Koç Özeti", description: "Her hafta kişisel koçluk raporu", tier: .premium),
        .init(icon: "bell.badge.fill", title: "Gelişmiş Hatırlatmalar", description: "Akıllı ve kişisel bildirimler", tier: .premium),
    ]
    
    static let plusFeatures: [PaywallFeature] = [
        .init(icon: "brain.head.profile", title: "AI Koç Sohbeti", description: "Kişisel beslenme asistanı", tier: .premiumPlus),
        .init(icon: "chart.line.uptrend.xyaxis", title: "İleri Trend Analizi", description: "Uzun vadeli sağlık trendleri", tier: .premiumPlus),
        .init(icon: "square.and.arrow.up", title: "PDF/CSV Dışa Aktarım", description: "Verilerini dışa aktar", tier: .premiumPlus),
    ]
}
