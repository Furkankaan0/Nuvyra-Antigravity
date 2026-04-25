import SwiftUI

/// Nuvyra tasarım sistemi renk tokenları.
/// Apple Award seviyesinde premium, sakin ve güven veren renk paleti.
enum NuvyraColors {
    
    // MARK: - Semantic Colors (Adaptive Light/Dark)
    
    /// Ana marka rengi — CTA butonları, progress ring, vurgular
    static let primary = Color("NuvyraPrimary", bundle: nil)
    
    /// İkincil vurgu — rozetler, grafikler, etiketler
    static let secondary = Color("NuvyraSecondary", bundle: nil)
    
    /// Uyarı rengi — kalori aşımı, hedef kaçırma gibi yumuşak uyarılar
    static let warning = Color("NuvyraWarning", bundle: nil)
    
    // MARK: - Hardcoded Fallbacks (Asset Catalog yoksa)
    
    /// Ana marka rengi — Light: #1DBA8A, Dark: #6CC3FF
    static var primaryAdaptive: Color {
        Color(light: .init(hex: 0x1DBA8A), dark: .init(hex: 0x6CC3FF))
    }
    
    /// İkincil vurgu — Light: #7C8CF8, Dark: #95E06C
    static var secondaryAdaptive: Color {
        Color(light: .init(hex: 0x7C8CF8), dark: .init(hex: 0x95E06C))
    }
    
    /// Uyarı — Light/Dark: #E76F51
    static var warningAdaptive: Color {
        Color(light: .init(hex: 0xE76F51), dark: .init(hex: 0xE76F51))
    }
    
    // MARK: - Background
    
    /// Ana arka plan — Light: #F5FBF8, Dark: #0E1525
    static var background: Color {
        Color(light: .init(hex: 0xF5FBF8), dark: .init(hex: 0x0E1525))
    }
    
    /// Kart arka planı — Light: beyaz %95 opaklık, Dark: #162136
    static var cardBackground: Color {
        Color(light: .white.opacity(0.95), dark: .init(hex: 0x162136))
    }
    
    /// Yüzey — hafif yükseltilmiş alanlar
    static var surface: Color {
        Color(light: .white, dark: .init(hex: 0x1A2740))
    }
    
    // MARK: - Text
    
    /// Birincil metin — Light: #13231D, Dark: #F4F7FB
    static var textPrimary: Color {
        Color(light: .init(hex: 0x13231D), dark: .init(hex: 0xF4F7FB))
    }
    
    /// İkincil metin — açıklamalar, alt metinler
    static var textSecondary: Color {
        Color(light: .init(hex: 0x5A6B63), dark: .init(hex: 0x8A9BAF))
    }
    
    /// Tersiyer metin — çok hafif, ipuçları
    static var textTertiary: Color {
        Color(light: .init(hex: 0x9AABA3), dark: .init(hex: 0x556677))
    }
    
    // MARK: - Gradients
    
    /// Ana CTA buton gradient'i
    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primaryAdaptive, primaryAdaptive.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Kart arka plan gradient'i (cam efekti)
    static var glassGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.15),
                Color.white.opacity(0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Dashboard üst alan gradient'i
    static var headerGradient: LinearGradient {
        LinearGradient(
            colors: [
                primaryAdaptive.opacity(0.12),
                background
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Specific
    
    /// Başarı / hedef tamamlandı
    static var success: Color {
        Color(light: .init(hex: 0x2ECC71), dark: .init(hex: 0x95E06C))
    }
    
    /// Protein rengi
    static let protein = Color(hex: 0x6CC3FF)
    
    /// Karbonhidrat rengi
    static let carbs = Color(hex: 0xFFB347)
    
    /// Yağ rengi
    static let fat = Color(hex: 0xFF6B6B)
    
    /// Su rengi
    static let water = Color(hex: 0x54C7FC)
}

// MARK: - Color Extensions

extension Color {
    /// Hex değerinden Color oluşturur
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
    
    /// Light/Dark mode için ayrı renk tanımı
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}
