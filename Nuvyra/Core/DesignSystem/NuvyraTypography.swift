import SwiftUI

/// Nuvyra tipografi sistemi.
/// SF Pro tabanlı, büyük metrik rakamları ve sakin başlıklar.
enum NuvyraTypography {
    
    // MARK: - Metric Numbers (Büyük, güçlü rakamlar)
    
    /// Büyük kalori/adım sayıları — 48pt bold rounded
    static let metricLarge: Font = .system(size: 48, weight: .bold, design: .rounded)
    
    /// Orta metrik rakamlar — 36pt bold rounded
    static let metricMedium: Font = .system(size: 36, weight: .bold, design: .rounded)
    
    /// Küçük metrik rakamlar — 24pt semibold rounded
    static let metricSmall: Font = .system(size: 24, weight: .semibold, design: .rounded)
    
    /// Kart içi metrik — 20pt semibold rounded
    static let metricCard: Font = .system(size: 20, weight: .semibold, design: .rounded)
    
    // MARK: - Headings
    
    /// Sayfa başlığı — Large Title
    static let largeTitle: Font = .largeTitle.weight(.bold)
    
    /// Bölüm başlığı — Title 2
    static let title: Font = .title2.weight(.semibold)
    
    /// Alt bölüm başlığı — Title 3
    static let subtitle: Font = .title3.weight(.medium)
    
    /// Kart başlığı — Headline
    static let cardTitle: Font = .headline.weight(.semibold)
    
    // MARK: - Body
    
    /// Ana gövde metni
    static let body: Font = .body
    
    /// Vurgulu gövde metni
    static let bodyBold: Font = .body.weight(.semibold)
    
    /// Callout — bilgi metinleri
    static let callout: Font = .callout
    
    // MARK: - Small
    
    /// Alt metin — açıklamalar
    static let caption: Font = .caption
    
    /// Küçük etiket — chip, badge
    static let caption2: Font = .caption2.weight(.medium)
    
    /// Footnote — ipuçları, timestamp
    static let footnote: Font = .footnote
    
    // MARK: - Special
    
    /// Onboarding başlık — büyük, ilham veren
    static let onboardingTitle: Font = .system(size: 28, weight: .bold, design: .rounded)
    
    /// Onboarding alt metin
    static let onboardingSubtitle: Font = .system(size: 17, weight: .regular, design: .rounded)
    
    /// Buton metni
    static let button: Font = .system(size: 17, weight: .semibold, design: .rounded)
    
    /// Küçük buton metni
    static let buttonSmall: Font = .system(size: 15, weight: .medium, design: .rounded)
    
    /// Tab bar item
    static let tabItem: Font = .system(size: 10, weight: .medium)
}

// MARK: - View Modifier

extension View {
    /// Nuvyra tipografi stili uygular
    func nuvyraFont(_ font: Font) -> some View {
        self.font(font)
    }
}
